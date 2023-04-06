
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BPAWorkQueueItemCopy](
	[id] [uniqueidentifier] NOT NULL,
	[queueid] [uniqueidentifier] NOT NULL,
	[keyvalue] [nvarchar](255) NULL,
	[status] [nvarchar](255) NULL,
	[attempt] [int] NULL,
	[loaded] [datetime] NULL,
	[completed] [datetime] NULL,
	[exception] [datetime] NULL,
	[exceptionreason] [nvarchar](max) NULL,
	[deferred] [datetime] NULL,
	[worktime] [int] NULL,
	[data] [nvarchar](max) NULL,
	[queueident] [int] NOT NULL,
	[ident] [bigint] IDENTITY(1,1) NOT NULL,
	[sessionid] [uniqueidentifier] NULL,
	[priority] [int] NOT NULL,
	[prevworktime] [int] NOT NULL,
	[attemptworktime]  AS ([worktime]-[prevworktime]) PERSISTED,
	[finished]  AS (isnull([exception],[completed])) PERSISTED,
	[exceptionreasonvarchar]  AS (CONVERT([nvarchar](400),[exceptionreason])),
	[exceptionreasontag]  AS (CONVERT([nvarchar](415),N'Exception: '+replace(CONVERT([nvarchar](400),[exceptionreason]),N';',N':'))) PERSISTED,
	[encryptid] [int] NULL,
	[lastupdated]  AS (coalesce([completed],[exception],[loaded])) PERSISTED,
	[locktime] [datetime] NULL,
	[lockid] [uniqueidentifier] NULL,
 CONSTRAINT [PK_BPAWorkQueueItemCopy] PRIMARY KEY CLUSTERED 
(
	[ident] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy] ADD  DEFAULT ('') FOR [status]
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy] ADD  DEFAULT ((0)) FOR [attempt]
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy] ADD  DEFAULT ((0)) FOR [worktime]
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy] ADD  DEFAULT ((0)) FOR [queueident]
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy] ADD  DEFAULT ((0)) FOR [priority]
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy] ADD  DEFAULT ((0)) FOR [prevworktime]
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy]  WITH CHECK ADD  CONSTRAINT [FK_BPAWorkQueueItemCopy_BPAKeyStore] FOREIGN KEY([encryptid])
REFERENCES [dbo].[BPAKeyStore] ([id])
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy] CHECK CONSTRAINT [FK_BPAWorkQueueItemCopy_BPAKeyStore]
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy]  WITH CHECK ADD  CONSTRAINT [FK_BPAWorkQueueItemCopy_BPAWorkQueue] FOREIGN KEY([queueident])
REFERENCES [dbo].[BPAWorkQueue] ([ident])
GO

ALTER TABLE [dbo].[BPAWorkQueueItemCopy] CHECK CONSTRAINT [FK_BPAWorkQueueItemCopy_BPAWorkQueue]
GO
/****** Object:  Index [Index_BPAWorkQueueItem_completed]    Script Date: 30/03/2023 13:32:39 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_completed] ON [dbo].[BPAWorkQueueItemCopy]
(
	[completed] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Index_BPAWorkQueueItem_exception]    Script Date: 30/03/2023 13:34:08 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_exception] ON [dbo].[BPAWorkQueueItemCopy]
(
	[exception] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_exceptionreasontag]    Script Date: 30/03/2023 13:35:43 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_exceptionreasontag] ON [dbo].[BPAWorkQueueItemCopy]
(
	[exceptionreasontag] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_exceptionreasonvarchar]    Script Date: 30/03/2023 13:36:37 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_exceptionreasonvarchar] ON [dbo].[BPAWorkQueueItemCopy]
(
	[exceptionreasonvarchar] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [index_BPAWorkQueueItemCopy_finished]    Script Date: 30/03/2023 13:37:35 ******/
CREATE NONCLUSTERED INDEX [index_BPAWorkQueueItemCopy_finished] ON [dbo].[BPAWorkQueueItemCopy]
(
	[finished] ASC
)
INCLUDE([queueident],[attemptworktime]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_itemid_attempt]    Script Date: 30/03/2023 13:38:22 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_itemid_attempt] ON [dbo].[BPAWorkQueueItemCopy]
(
	[id] ASC,
	[attempt] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_key]    Script Date: 30/03/2023 13:39:07 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_key] ON [dbo].[BPAWorkQueueItemCopy]
(
	[keyvalue] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_loaded]    Script Date: 30/03/2023 13:40:03 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_loaded] ON [dbo].[BPAWorkQueueItemCopy]
(
	[loaded] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_queueident_completed]    Script Date: 30/03/2023 13:40:39 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_queueident_completed] ON [dbo].[BPAWorkQueueItemCopy]
(
	[queueident] ASC,
	[completed] ASC
)
INCLUDE([id],[attempt],[loaded],[exception],[exceptionreason]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_queueident_exception]    Script Date: 30/03/2023 13:41:25 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_queueident_exception] ON [dbo].[BPAWorkQueueItemCopy]
(
	[queueident] ASC,
	[exception] ASC
)
INCLUDE([id],[attempt],[loaded]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_queueident_finished]    Script Date: 30/03/2023 13:42:03 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_queueident_finished] ON [dbo].[BPAWorkQueueItemCopy]
(
	[queueident] ASC,
	[finished] ASC
)
INCLUDE([completed],[exception],[deferred],[attemptworktime]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemCopy_queuepriorityloaded]    Script Date: 30/03/2023 13:42:48 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemCopy_queuepriorityloaded] ON [dbo].[BPAWorkQueueItemCopy]
(
	[queueident] ASC,
	[priority] ASC,
	[loaded] ASC
)
INCLUDE([sessionid],[finished],[keyvalue],[deferred],[id]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_queueid]    Script Date: 30/03/2023 13:53:56 ******/
CREATE NONCLUSTERED INDEX [Index_queueid_Copy] ON [dbo].[BPAWorkQueueItemCopy]
(
	[queueid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [INDEX_WorkQueueItemCopyGuid]    Script Date: 30/03/2023 14:23:16 ******/
CREATE NONCLUSTERED INDEX [INDEX_WorkQueueItemCopyGuid] ON [dbo].[BPAWorkQueueItemCopy]
(
	[id] ASC
)
INCLUDE([finished],[deferred],[ident],[queueident]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [INDEX_WorkQueueItemCopyPriority]    Script Date: 30/03/2023 14:25:28 ******/
CREATE NONCLUSTERED INDEX [INDEX_WorkQueueItemCopyPriority] ON [dbo].[BPAWorkQueueItemCopy]
(
	[priority] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [nci_wi_BPAWorkQueueItemCopy_FC8BA3F5DC18B825B3C553DD75847941]    Script Date: 30/03/2023 15:22:08 ******/
CREATE NONCLUSTERED INDEX [nci_wi_BPAWorkQueueItemCopy_FC8BA3F5DC18B825B3C553DD75847941] ON [dbo].[BPAWorkQueueItemCopy]
(
	[loaded] ASC
)
INCLUDE([attempt],[completed],[deferred],[exception],[finished],[id],[queueid],[worktime]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

