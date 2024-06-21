/****** Object:  Table [dbo].[BPATask]    Script Date: 04/06/2024 12:13:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BPATask](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[scheduleid] [int] NOT NULL,
	[name] [nvarchar](128) NULL,
	[description] [nvarchar](max) NULL,
	[onsuccess] [int] NULL,
	[onfailure] [int] NULL,
	[failfastonerror] [bit] NOT NULL,
	[delayafterend] [int] NOT NULL,
 CONSTRAINT [PK_BPATask] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BPATask] ADD  CONSTRAINT [DEF_BPATask_failfastonerror]  DEFAULT ((1)) FOR [failfastonerror]
GO

ALTER TABLE [dbo].[BPATask] ADD  DEFAULT ((0)) FOR [delayafterend]
GO

ALTER TABLE [dbo].[BPATask]  WITH CHECK ADD  CONSTRAINT [FK_BPATask_BPASchedule] FOREIGN KEY([scheduleid])
REFERENCES [dbo].[BPASchedule] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[BPATask] CHECK CONSTRAINT [FK_BPATask_BPASchedule]
GO

ALTER TABLE [dbo].[BPATask]  WITH CHECK ADD  CONSTRAINT [FK_BPATask_BPATask_failure] FOREIGN KEY([onfailure])
REFERENCES [dbo].[BPATask] ([id])
GO

ALTER TABLE [dbo].[BPATask] CHECK CONSTRAINT [FK_BPATask_BPATask_failure]
GO

ALTER TABLE [dbo].[BPATask]  WITH CHECK ADD  CONSTRAINT [FK_BPATask_BPATask_success] FOREIGN KEY([onsuccess])
REFERENCES [dbo].[BPATask] ([id])
GO

ALTER TABLE [dbo].[BPATask] CHECK CONSTRAINT [FK_BPATask_BPATask_success]
GO

