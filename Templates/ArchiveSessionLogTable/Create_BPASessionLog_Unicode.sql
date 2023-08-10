/****** Object:  Table [dbo].[BPASessionLog_Unicode]    Script Date: 10/08/2023 17:12:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BPASessionLog_Unicode](
	[logid] [bigint] IDENTITY(1,1) NOT NULL,
	[sessionnumber] [int] NOT NULL,
	[stageid] [uniqueidentifier] NULL,
	[stagename] [nvarchar](128) NULL,
	[stagetype] [int] NULL,
	[processname] [nvarchar](128) NULL,
	[pagename] [nvarchar](128) NULL,
	[objectname] [nvarchar](128) NULL,
	[actionname] [nvarchar](128) NULL,
	[result] [nvarchar](max) NULL,
	[resulttype] [int] NULL,
	[startdatetime] [datetime] NULL,
	[enddatetime] [datetime] NULL,
	[attributexml] [nvarchar](max) NULL,
	[automateworkingset] [bigint] NULL,
	[targetappname] [nvarchar](32) NULL,
	[targetappworkingset] [bigint] NULL,
	[starttimezoneoffset] [int] NULL,
	[endtimezoneoffset] [int] NULL,
	[attributesize]  AS (isnull(datalength([attributexml]),(0))) PERSISTED NOT NULL,
 CONSTRAINT [PK_BPASessionLog_Unicode] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BPASessionLog_Unicode]  WITH CHECK ADD  CONSTRAINT [FK_BPASessionLog_Unicode_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber])
GO

ALTER TABLE [dbo].[BPASessionLog_Unicode] CHECK CONSTRAINT [FK_BPASessionLog_Unicode_BPASession]
GO

/****** Object:  Index [Index_BPASessionLog_Unicode_sessionnumber]    Script Date: 10/08/2023 17:13:17 ******/
CREATE NONCLUSTERED INDEX [Index_BPASessionLog_Unicode_sessionnumber] ON [dbo].[BPASessionLog_Unicode]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

