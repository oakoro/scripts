DECLARE @Retention DATETIME

/*
Create replica table and create indexes
*/
IF (OBJECT_ID('[oke_arch].[BPASessionLog_NonUnicodeOATestCopy]','U')) IS NULL
BEGIN
CREATE TABLE [oke_arch].[BPASessionLog_NonUnicodeOATestCopy](
	[logid] [bigint] IDENTITY(1,1) NOT NULL,
	[sessionnumber] [int] NOT NULL,
	[stageid] [uniqueidentifier] NULL,
	[stagename] [varchar](128) NULL,
	[stagetype] [int] NULL,
	[processname] [varchar](128) NULL,
	[pagename] [varchar](128) NULL,
	[objectname] [varchar](128) NULL,
	[actionname] [varchar](128) NULL,
	[result] [varchar](max) NULL,
	[resulttype] [int] NULL,
	[startdatetime] [datetime] NULL,
	[enddatetime] [datetime] NULL,
	[attributexml] [varchar](max) NULL,
	[automateworkingset] [bigint] NULL,
	[targetappname] [varchar](32) NULL,
	[targetappworkingset] [bigint] NULL,
	[starttimezoneoffset] [int] NULL,
	[endtimezoneoffset] [int] NULL,
	[attributesize]  AS (isnull(datalength([attributexml]),(0))) PERSISTED NOT NULL,
 CONSTRAINT [PK_BPASessionLog_NonUnicodeOATestCopy] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

ALTER TABLE [oke_arch].[BPASessionLog_NonUnicodeOATestCopy]  WITH CHECK ADD  CONSTRAINT [FK_BPASessionLog_NonUnicode_BPASession2] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber]);


ALTER TABLE [oke_arch].[BPASessionLog_NonUnicodeOATestCopy] CHECK CONSTRAINT [FK_BPASessionLog_NonUnicode_BPASession2];

CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_enddatetime1] ON [oke_arch].[BPASessionLog_NonUnicodeOATestCopy]
(
	[sessionnumber] ASC,
	[enddatetime] ASC
)
INCLUDE([endtimezoneoffset]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];

CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_sessionnumberOATest1] ON [oke_arch].[BPASessionLog_NonUnicodeOATestCopy]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];

END

IF (OBJECT_ID('[oke_arch].[BPASessionLog_NonUnicodeOATestCopy]','U')) IS NOT NULL
BEGIN
TRUNCATE TABLE [oke_arch].[BPASessionLog_NonUnicodeOATestCopy];
ALTER TABLE [oke_arch].[BPASessionLog_NonUnicodeOATest] SWITCH TO [oke_arch].[BPASessionLog_NonUnicodeOATestCopy]


END
SET IDENTITY_INSERT [oke_arch].[BPASessionLog_NonUnicodeOATestCopy] ON
INSERT INTO [oke_arch].[BPASessionLog_NonUnicodeOATestCopy]
           ([sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset])
SELECT 
			[sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset]
FROM 
[oke_arch].[BPASessionLog_NonUnicodeOATest]
WHERE DATEDIFF(DD,[enddatetime],GETDATE()) >= @Retention
SET IDENTITY_INSERT [oke_arch].[BPASessionLog_NonUnicodeOATestCopy] OFF
/*
Copy data to retain from replica table to original prod table
*/
--select min(enddatetime), max(enddatetime) from [oke_arch].[BPASessionLog_NonUnicodeOATest]

--DECLARE @Retention INT = 120
--INSERT 
--SELECT DATEDIFF(DD,'2022-01-07',GETDATE())






--DROP TABLE [oke_arch].[BPASessionLog_NonUnicodeOATestCopy]
--select count(*) from [oke_arch].[BPASessionLog_NonUnicodeOATest];--2205570
--select count(*) from [oke_arch].[BPASessionLog_NonUnicodeOATestCopy];
--ALTER TABLE [oke_arch].[BPASessionLog_NonUnicodeOATestCopy] SWITCH TO [oke_arch].[BPASessionLog_NonUnicodeOATest]