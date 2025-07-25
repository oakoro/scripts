/****** Object:  Table [dbo].[BPAScheduleLogEntry]    Script Date: 09/07/2025 16:41:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[BPAScheduleLogEntryTemp](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[schedulelogid] [int] NOT NULL,
	[entrytype] [tinyint] NOT NULL,
	[entrytime] [datetime] NOT NULL,
	[taskid] [int] NULL,
	[logsessionnumber] [int] NULL,
	[terminationreason] [nvarchar](255) NULL,
	[stacktrace] [nvarchar](max) NULL,
 CONSTRAINT [PK_BPAScheduleLogEntryTemp] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BPAScheduleLogEntryTemp]  WITH CHECK ADD  CONSTRAINT [FK_BPAScheduleLogEntryTemp_BPAScheduleLog] FOREIGN KEY([schedulelogid])
REFERENCES [dbo].[BPAScheduleLog] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[BPAScheduleLogEntryTemp] CHECK CONSTRAINT [FK_BPAScheduleLogEntryTemp_BPAScheduleLog]
GO

ALTER TABLE [dbo].[BPAScheduleLogEntryTemp]  WITH CHECK ADD  CONSTRAINT [FK_BPAScheduleLogEntryTemp_BPASession] FOREIGN KEY([logsessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber])
ON DELETE SET NULL
GO

ALTER TABLE [dbo].[BPAScheduleLogEntryTemp] CHECK CONSTRAINT [FK_BPAScheduleLogEntryTemp_BPASession]
GO

ALTER TABLE [dbo].[BPAScheduleLogEntryTemp]  WITH CHECK ADD  CONSTRAINT [FK_BPAScheduleLogEntryTemp_BPATask] FOREIGN KEY([taskid])
REFERENCES [dbo].[BPATask] ([id])
GO

ALTER TABLE [dbo].[BPAScheduleLogEntryTemp] CHECK CONSTRAINT [FK_BPAScheduleLogEntryTemp_BPATask]
GO

ALTER TABLE [dbo].[BPAScheduleLogEntryTemp]  WITH CHECK ADD  CONSTRAINT [CHK_BPAScheduleLogEntryTemp_entrytype] CHECK  (([entrytype]<(10)))
GO

ALTER TABLE [dbo].[BPAScheduleLogEntryTemp] CHECK CONSTRAINT [CHK_BPAScheduleLogEntryTemp_entrytype]
GO


