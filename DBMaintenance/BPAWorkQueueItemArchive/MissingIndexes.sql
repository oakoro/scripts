/****** Object:  Index [Index_BPAWorkQueueItemRetain_completed]    Script Date: 20/05/2026 20:59:43 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_completed] ON [dbo].[BPAWorkQueueItemRetain]
(
	[completed] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Index_BPAWorkQueueItemRetain_exception]    Script Date: 20/05/2026 21:00:08 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_exception] ON [dbo].[BPAWorkQueueItemRetain]
(
	[exception] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_exceptionreasontag]    Script Date: 20/05/2026 21:00:28 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_exceptionreasontag] ON [dbo].[BPAWorkQueueItemRetain]
(
	[exceptionreasontag] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_exceptionreasonvarchar]    Script Date: 20/05/2026 21:00:50 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_exceptionreasonvarchar] ON [dbo].[BPAWorkQueueItemRetain]
(
	[exceptionreasonvarchar] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

/****** Object:  Index [index_BPAWorkQueueItemRetain_finished]    Script Date: 20/05/2026 21:01:10 ******/
CREATE NONCLUSTERED INDEX [index_BPAWorkQueueItemRetain_finished] ON [dbo].[BPAWorkQueueItemRetain]
(
	[finished] ASC
)
INCLUDE([queueident],[attemptworktime]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_itemid_attempt]    Script Date: 20/05/2026 21:01:35 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_itemid_attempt] ON [dbo].[BPAWorkQueueItemRetain]
(
	[id] ASC,
	[attempt] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_key]    Script Date: 20/05/2026 21:01:57 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_key] ON [dbo].[BPAWorkQueueItemRetain]
(
	[keyvalue] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_loaded]    Script Date: 20/05/2026 21:02:19 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_loaded] ON [dbo].[BPAWorkQueueItemRetain]
(
	[loaded] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_queueident_completed]    Script Date: 20/05/2026 21:02:41 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_queueident_completed] ON [dbo].[BPAWorkQueueItemRetain]
(
	[queueident] ASC,
	[completed] ASC
)
INCLUDE([id],[attempt],[loaded],[exception],[exceptionreason]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_queueident_exception]    Script Date: 20/05/2026 21:03:06 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_queueident_exception] ON [dbo].[BPAWorkQueueItemRetain]
(
	[queueident] ASC,
	[exception] ASC
)
INCLUDE([id],[attempt],[loaded]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_queueident_finished]    Script Date: 20/05/2026 21:03:28 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_queueident_finished] ON [dbo].[BPAWorkQueueItemRetain]
(
	[queueident] ASC,
	[finished] ASC
)
INCLUDE([completed],[exception],[deferred],[attemptworktime]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Index_BPAWorkQueueItemRetain_queuepriorityloaded]    Script Date: 20/05/2026 21:03:52 ******/
CREATE NONCLUSTERED INDEX [Index_BPAWorkQueueItemRetain_queuepriorityloaded] ON [dbo].[BPAWorkQueueItemRetain]
(
	[queueident] ASC,
	[priority] ASC,
	[loaded] ASC
)
INCLUDE([sessionid],[finished],[keyvalue],[deferred],[id]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Index_queueid_Retain]    Script Date: 20/05/2026 21:04:15 ******/
CREATE NONCLUSTERED INDEX [Index_queueid_Retain] ON [dbo].[BPAWorkQueueItemRetain]
(
	[queueid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [INDEX_WorkQueueItemRetainGuid]    Script Date: 20/05/2026 21:04:35 ******/
CREATE NONCLUSTERED INDEX [INDEX_WorkQueueItemRetainGuid] ON [dbo].[BPAWorkQueueItemRetain]
(
	[id] ASC
)
INCLUDE([finished],[deferred],[ident],[queueident]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [INDEX_WorkQueueItemRetainPriority]    Script Date: 20/05/2026 21:04:58 ******/
CREATE NONCLUSTERED INDEX [INDEX_WorkQueueItemRetainPriority] ON [dbo].[BPAWorkQueueItemRetain]
(
	[priority] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [nci_wi_BPAWorkQueueItemRetain_FC8BA3F5DC18B825B3C553DD75847941]    Script Date: 20/05/2026 21:05:18 ******/
CREATE NONCLUSTERED INDEX [nci_wi_BPAWorkQueueItemRetain_FC8BA3F5DC18B825B3C553DD75847941] ON [dbo].[BPAWorkQueueItemRetain]
(
	[loaded] ASC
)
INCLUDE([attempt],[completed],[deferred],[exception],[finished],[id],[queueid],[worktime]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO





