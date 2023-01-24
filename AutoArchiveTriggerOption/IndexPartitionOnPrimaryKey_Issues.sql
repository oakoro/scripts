--USE [oketestOP]
--GO

--/****** Object:  Table [dbo].[sessionlog_partitioned]    Script Date: 24/01/2023 12:43:21 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[bpsessionlogPartitionTest](
--	[logid] [int] IDENTITY(1,1) NOT NULL,
--	[sessionnumber] int NULL,
--	[stageid] [nvarchar](255) NULL,
--	[stagename] [nvarchar](255) NULL,
--	[stagetype] [float] NULL,
--	[processname] [nvarchar](255) NULL,
--	[pagename] [nvarchar](255) NULL,
--	[objectname] [nvarchar](255) NULL,
--	[actionname] [nvarchar](255) NULL,
--	[result] [nvarchar](255) NULL,
--	[resulttype] [float] NULL,
--	[startdatetime] [datetime] NULL,
--	[enddatetime] [nvarchar](255) NULL,
--	[attributexml] [nvarchar](max) NULL,
--	[automateworkingset] [float] NULL,
--	[targetappname] [nvarchar](255) NULL,
--	[targetappworkingset] [float] NULL,
--	[starttimezoneoffset] [float] NULL,
--	[endtimezoneoffset] [nvarchar](255) NULL
--)
--GO
--CREATE TABLE [dbo].bpsessionlogPartitionTest(
--	[logid] [bigint] IDENTITY(1,1) NOT NULL,
--	[sessionnumber] [int] NOT NULL,
--	[stageid] [uniqueidentifier] NULL,
--	[stagename] [varchar](128) NULL,
--	[stagetype] [int] NULL,
--	[processname] [varchar](128) NULL,
--	[pagename] [varchar](128) NULL,
--	[objectname] [varchar](128) NULL,
--	[actionname] [varchar](128) NULL,
--	[result] [varchar](max) NULL,
--	[resulttype] [int] NULL,
--	[startdatetime] [datetime] NULL,
--	[enddatetime] [datetime] NULL,
--	[attributexml] [varchar](max) NULL,
--	[automateworkingset] [bigint] NULL,
--	[targetappname] [varchar](32) NULL,
--	[targetappworkingset] [bigint] NULL,
--	[starttimezoneoffset] [int] NULL,
--	[endtimezoneoffset] [int] NULL,
--	[attributesize]  AS (isnull(datalength([attributexml]),(0))) PERSISTED NOT NULL,
-- CONSTRAINT [PK_bpsessionlogPartitionTest] PRIMARY KEY CLUSTERED 
--(
--	[logid] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

--select * from bpsessionlogPartitionTest order by logid

--create partition function PF_bpsessionlog(int) --Dynamic value range as range would vary
--as range right for values()  

--create partition scheme PS_bpsessionlog
--as partition PF_bpsessionlog all to ([primary])


drop index [PK_bpsessionlogPartitionTest] on [dbo].[bpsessionlogPartitionTest]
/*
Msg 3723, Level 16, State 4, Line 70
An explicit DROP INDEX is not allowed on index 'dbo.bpsessionlogPartitionTest.PK_bpsessionlogPartitionTest'. It is being used for PRIMARY KEY constraint enforcement.

-- Drop Constraint
ALTER TABLE [dbo].[bpsessionlogPartitionTest]
DROP CONSTRAINT [PK_bpsessionlogPartitionTest]
GO
*/


CREATE CLUSTERED INDEX [PK_bpsessionlogPartitionTest] ON [dbo].[bpsessionlogPartitionTest]
(
	[logid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
ON PS_bpsessionlog([logid])
/*
Msg 1907, Level 16, State 1, Line 82
Cannot recreate index 'PK_bpsessionlogPartitionTest'. The new index definition does not match the constraint being enforced by the existing index.
*/
 