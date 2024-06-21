/****** Object:  Table [dbo].[BPAScheduleLogEntry]    Script Date: 04/06/2024 12:11:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BPAScheduleLogEntry](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[schedulelogid] [int] NOT NULL,
	[entrytype] [tinyint] NOT NULL,
	[entrytime] [datetime] NOT NULL,
	[taskid] [int] NULL,
	[logsessionnumber] [int] NULL,
	[terminationreason] [nvarchar](255) NULL,
	[stacktrace] [nvarchar](max) NULL,
 CONSTRAINT [PK_BPAScheduleLogEntry] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BPAScheduleLogEntry]  WITH CHECK ADD  CONSTRAINT [FK_BPAScheduleLogEntry_BPAScheduleLog] FOREIGN KEY([schedulelogid])
REFERENCES [dbo].[BPAScheduleLog] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[BPAScheduleLogEntry] CHECK CONSTRAINT [FK_BPAScheduleLogEntry_BPAScheduleLog]
GO

ALTER TABLE [dbo].[BPAScheduleLogEntry]  WITH CHECK ADD  CONSTRAINT [FK_BPAScheduleLogEntry_BPASession] FOREIGN KEY([logsessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber])
ON DELETE SET NULL
GO

ALTER TABLE [dbo].[BPAScheduleLogEntry] CHECK CONSTRAINT [FK_BPAScheduleLogEntry_BPASession]
GO

ALTER TABLE [dbo].[BPAScheduleLogEntry]  WITH CHECK ADD  CONSTRAINT [FK_BPAScheduleLogEntry_BPATask] FOREIGN KEY([taskid])
REFERENCES [dbo].[BPATask] ([id])
GO

ALTER TABLE [dbo].[BPAScheduleLogEntry] CHECK CONSTRAINT [FK_BPAScheduleLogEntry_BPATask]
GO

ALTER TABLE [dbo].[BPAScheduleLogEntry]  WITH CHECK ADD  CONSTRAINT [CHK_BPAScheduleLogEntry_entrytype] CHECK  (([entrytype]<(10)))
GO

ALTER TABLE [dbo].[BPAScheduleLogEntry] CHECK CONSTRAINT [CHK_BPAScheduleLogEntry_entrytype]
GO

