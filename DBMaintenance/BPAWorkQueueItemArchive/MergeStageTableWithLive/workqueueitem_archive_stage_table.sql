/****** Object:  Table [dbo].[BPAWorkQueueItemRestore]    Script Date: 29/05/2026 14:27:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BPAWorkQueueItemRestore](
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
	[ident] [bigint] NOT NULL,
	[sessionid] [uniqueidentifier] NULL,
	[priority] [int] NOT NULL,
	[prevworktime] [int] NOT NULL,
	[attemptworktime] [int] NULL,
	[finished] [datetime] NULL,
	[exceptionreasonvarchar] [nvarchar](max) NULL,
	[exceptionreasontag] [nvarchar](max) NULL,
	[encryptid] [int] NULL,
	[lastupdated] [datetime] NULL,
	[locktime] [datetime] NULL,
	[lockid] [uniqueidentifier] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--ALTER TABLE [dbo].[BPAWorkQueueItemRestore]
--ADD [sladatetime] [datetime] NULL, [processname] [nvarchar](255) NULL ,
	--[issuggested] [bit] NULL, [sla] [bigint] NULL;