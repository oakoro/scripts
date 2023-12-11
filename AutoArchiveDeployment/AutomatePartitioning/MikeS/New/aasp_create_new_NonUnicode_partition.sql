/****** Object:  StoredProcedure [BPC].[aasp_create_new_NonUnicode_partition]    Script Date: 11/17/2023 4:17:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Description: Partitions the BPASessionLog_NonUnicode Table
-- Script execution Example: EXECUTE BPC.aasp_create_new_NonUnicode_partition
-- =============================================
CREATE PROCEDURE [BPC].[aasp_create_new_NonUnicode_partition]

AS
BEGIN
/*** Part 1: Drop Existing Views which could cause this automation to fail ***/

/****** Object:  View [BPC].[aavw_Sessionnumber]    Script Date: 9/14/2023 12:22:30 PM ******/
DROP VIEW IF EXISTS [BPC].[aavw_Sessionnumber];

/****** Object:  View [BPC].[aavw_ControlTableUpdate]    Script Date: 9/14/2023 12:23:14 PM ******/
DROP VIEW IF EXISTS [BPC].[aavw_ControlTableUpdate];

/*** Part 2: Drop Temp Table if it Exist ***/

DROP TABLE IF EXISTS [dbo].[BPASessionLog_NonUnicode_Temp];

/*** Part 3: Recreate the BPASessionLog_NonUnicode_Temp table ***/

/****** Object:  Table [dbo].[BPASessionLog_NonUnicode_Temp]    Script Date: 9/14/2023 12:20:02 PM ******/

CREATE TABLE [dbo].[BPASessionLog_NonUnicode_Temp](
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
 CONSTRAINT [PK_BPASessionLog_NonUnicode_Temp] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


/****** Object:  Index [Index_BPASessionLog_NonUnicode_Temp_sessionnumber]    Script Date: 9/14/2023 12:20:03 PM ******/
CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_Temp_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_Temp]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];


ALTER TABLE [dbo].[BPASessionLog_NonUnicode_Temp]  WITH CHECK ADD  CONSTRAINT [FK_BPASessionLog_NonUnicode_Temp_BPASession] FOREIGN KEY([sessionnumber])
REFERENCES [dbo].[BPASession] ([sessionnumber]);


ALTER TABLE [dbo].[BPASessionLog_NonUnicode_Temp] CHECK CONSTRAINT [FK_BPASessionLog_NonUnicode_Temp_BPASession];

/*** Part 4: Create Partiton Function & Scheme ***/

/* Declare Identity Partition Seed Value */
DECLARE @nextPartitionID bigint --Maximum logid or seed value in BPASessionLog Table
DECLARE @partitionseedValue bigint --Partition function seed value

SELECT @nextPartitionID = IDENT_CURRENT('dbo.BPASessionLog_NonUnicode')

IF @nextPartitionID = 1 SET @partitionseedValue = 0 ELSE SET @partitionseedValue = @nextPartitionID

/* Create the Partition Function */

IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
BEGIN
CREATE PARTITION FUNCTION [PF_Dynamic_NU](bigint) AS range right for values(@partitionseedValue)	
END

/* Create the Partition Scheme */

IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
BEGIN
CREATE PARTITION SCHEME [PS_Dynamic_NU] as partition PF_Dynamic_NU all TO ([primary])
END

/*** Part 5: Move the data out of the BPASessionLog_NonUnicode table ***/

/* Switch all BPASessionLog_NonUnicode data to BPASessionLog_NonUnicode_Temp table */

begin transaction
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BPASessionLog_NonUnicode_Temp]') AND type in (N'U'))
alter table BPASessionLog_NonUnicode switch to BPASessionLog_NonUnicode_Temp;
commit transaction

/*** Part 6: Partiton the Table by adding the indexes to the PS_Dynamic_NU Schema***/

----clusterindexpartition = 
	If (Select top 1 logid from [dbo].[BPASessionLog_NonUnicode]) is null
	CREATE UNIQUE CLUSTERED INDEX [PK_BPASessionLog_NonUnicode]
	ON [dbo].[BPASessionLog_NonUnicode](logid)
	WITH (DROP_EXISTING = ON)
	ON PS_Dynamic_NU (logid);

----@nonclusterindexpartition = 
	
	DROP INDEX [Index_BPASessionLog_NonUnicode_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode];
	   
	If (Select top 1 logid from [dbo].[BPASessionLog_NonUnicode]) is null
	CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode]
	(
	[sessionnumber] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
	ON PS_Dynamic_NU (logid);

/*** Part 7: Move the data back to the BPASessionLog_NonUnicode table ***/

/* Move the maximum logid from BPASessionLog_NonUnicode_Temp table to the BPASessionLog_NonUnicode table */
Begin Transaction

		set identity_insert BPASessionLog_NonUnicode on;

        insert into BPASessionLog_NonUnicode
        (
            logid,
            sessionnumber,
            stageid,
            stagename,
            stagetype,
            processname,
            pagename,
            objectname,
            actionname,
            result,
            resulttype,
            startdatetime,
            enddatetime,
            attributexml,
            automateworkingset,
            targetappname,
            targetappworkingset,
            starttimezoneoffset,
            endtimezoneoffset
        )
 select logid,
               sessionnumber,
               stageid,
               stagename,
               stagetype,
               processname,
               pagename,
               objectname,
               actionname,
               result,
               resulttype,
               startdatetime,
               enddatetime,
               attributexml,
               automateworkingset,
               targetappname,
               targetappworkingset,
               starttimezoneoffset,
               endtimezoneoffset
        from
            dbo.BPASessionLog_NonUnicode_Temp with (nolock)
			where logid = (Select max(logid) from bpasessionlog_nonunicode_Temp);

		set identity_insert BPASessionLog_NonUnicode off;

Commit transaction;

/* Verify that the maximum logid from BPASessionLog_NonUnicode_Temp table has been copied to the BPASessionLog_NonUnicode_Temp02 table then delete this row from the BPASessionLog_NonUnicode_Temp table */

Begin Transaction

IF Exists (select logid from BPASessionLog_NonUnicode_Temp where logid = (Select max(logid) from BPASessionLog_NonUnicode))
delete from BPASessionLog_NonUnicode_Temp where logid = (Select MIN(logid) from BPASessionLog_NonUnicode)

Commit transaction

/*** Add check min/max constraints to the BPASessionLog_NonUnicode_Temp table to switch the data back to the BPASessionLog_NonUnicode table ***/

Begin
Declare @MN bigint = (Select min(logid) from BPASessionLog_NonUnicode_Temp)
Declare @MX bigint = (Select max(logid) from BPASessionLog_NonUnicode)
declare @sqlcmd01 nvarchar(500)
declare @sqlcmd02 nvarchar(500)

set @sqlcmd01 = N'alter table BPASessionLog_NonUnicode_Temp with check add constraint ckMinLogid check (logid is not null and logid >= ' + convert(varchar, @MN) + ' )'
set @sqlcmd02 = N'alter table BPASessionLog_NonUnicode_Temp with check add constraint ckMaxLogid check (logid is not null and logid < ' + convert(varchar, @MX) + ' )'

Exec sp_executesql @sqlcmd01;
Exec sp_executesql @sqlcmd02;
End

/* Switch all sessionlog temp02 data back to the production table */

Begin transaction;

ALTER TABLE dbo.BPASessionLog_NonUnicode_Temp SWITCH TO dbo.BPASessionLog_NonUnicode partition 1;

commit transaction; 

/*** Part 8: Verify Partition ***/
IF (SELECT TOP (1) ps.name AS [Partition Scheme] FROM sys.tables t INNER JOIN sys.indexes i ON t.object_id = i.object_id AND i.type IN (0,1) INNER JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id WHERE t.name in ('BPASessionLog_NonUnicode')) = 'PS_Dynamic_NU'
BEGIN
Select 'BPASessionLog_NonUnicode Successfully Partitioned' as Results;

/*** Drop Temp tables ***/
DROP TABLE [dbo].[BPASessionLog_NonUnicode_Temp];
END 

ELSE 
Select 'BPASessionLog_NonUnicode Partitioning Failed'  as Results;

END
GO

