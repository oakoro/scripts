/****** Object:  Table [dbo].[BPAScheduleLog]    Script Date: 04/06/2024 12:07:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BPAScheduleLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[scheduleid] [int] NOT NULL,
	[instancetime] [datetime] NOT NULL,
	[firereason] [tinyint] NOT NULL,
	[servername] [nvarchar](255) NULL,
	[heartbeat] [datetime] NULL,
 CONSTRAINT [PK_BPAScheduleLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UNQ_BPAScheduleLog_scheduleid_time] UNIQUE NONCLUSTERED 
(
	[scheduleid] ASC,
	[instancetime] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BPAScheduleLog]  WITH CHECK ADD  CONSTRAINT [FK_BPAScheduleLog_BPASchedule] FOREIGN KEY([scheduleid])
REFERENCES [dbo].[BPASchedule] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[BPAScheduleLog] CHECK CONSTRAINT [FK_BPAScheduleLog_BPASchedule]
GO

ALTER TABLE [dbo].[BPAScheduleLog]  WITH CHECK ADD  CONSTRAINT [CHK_BPAScheduleLog_firereason] CHECK  (([firereason]<(5)))
GO

ALTER TABLE [dbo].[BPAScheduleLog] CHECK CONSTRAINT [CHK_BPAScheduleLog_firereason]
GO

