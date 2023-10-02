--/*** Part 1: Drop Existing Views which could cause this automation to fail ***/

--/****** Object:  View [BPC].[aavw_Sessionnumber]    Script Date: 9/14/2023 12:22:30 PM ******/
--DROP VIEW IF EXISTS [BPC].[aavw_Sessionnumber]
--GO

--/****** Object:  View [BPC].[aavw_ControlTableUpdate]    Script Date: 9/14/2023 12:23:14 PM ******/
--DROP VIEW IF EXISTS [BPC].[aavw_ControlTableUpdate]
--GO

--/*** Part 2: Drop Temp Tables if they Exist then recreate the BPASessionLog_NonUnicode Temp tables ***/

--DROP TABLE IF EXISTS [dbo].[BPASessionLog_NonUnicode_Temp];
--GO

--DROP TABLE IF EXISTS [dbo].[BPASessionLog_NonUnicode_Temp02];
--GO

--/****** Object:  Table [dbo].[BPASessionLog_NonUnicode_Temp]    Script Date: 9/14/2023 12:20:02 PM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[BPASessionLog_NonUnicode_Temp](
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
-- CONSTRAINT [PK_BPASessionLog_NonUnicode_Temp] PRIMARY KEY CLUSTERED 
--(
--	[logid] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

--/****** Object:  Index [Index_BPASessionLog_NonUnicode_Temp_sessionnumber]    Script Date: 9/14/2023 12:20:03 PM ******/
--CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_Temp_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_Temp]
--(
--	[sessionnumber] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

--ALTER TABLE [dbo].[BPASessionLog_NonUnicode_Temp]  WITH CHECK ADD  CONSTRAINT [FK_BPASessionLog_NonUnicode_Temp_BPASession] FOREIGN KEY([sessionnumber])
--REFERENCES [dbo].[BPASession] ([sessionnumber])
--GO

--ALTER TABLE [dbo].[BPASessionLog_NonUnicode_Temp] CHECK CONSTRAINT [FK_BPASessionLog_NonUnicode_Temp_BPASession]
--GO

--/****** Object:  Table [dbo].[BPASessionLog_NonUnicode_Temp02]    Script Date: 9/14/2023 12:20:02 PM ******/
--DROP TABLE IF EXISTS [dbo].[BPASessionLog_NonUnicode_Temp02];
--GO

--CREATE TABLE [dbo].[BPASessionLog_NonUnicode_Temp02](
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
-- CONSTRAINT [PK_BPASessionLog_NonUnicode_Temp02] PRIMARY KEY CLUSTERED 
--(
--	[logid] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

--/****** Object:  Index [Index_BPASessionLog_NonUnicode_Temp02_sessionnumber]    Script Date: 9/14/2023 12:20:03 PM ******/
--CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_Temp02_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode_Temp02]
--(
--	[sessionnumber] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

/*** Part 3: Create Partiton Function & Scheme ***/

/* Declare Identity Partition Seed Value */
--DECLARE @nextPartitionID bigint --Maximum logid or seed value in BPASessionLog Table
--DECLARE @partitionseedValue bigint --Partition function seed value

--SELECT @nextPartitionID = IDENT_CURRENT('BPASessionLog_NonUnicode_AutoPT')

--IF @nextPartitionID = 1 SET @partitionseedValue = 0 ELSE SET @partitionseedValue = @nextPartitionID
--select @partitionseedValue
--/* Create the Partition Function */

--IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU_AutoPT')
--BEGIN
--CREATE PARTITION FUNCTION [PF_Dynamic_NU_AutoPT](bigint) AS range right for values(@partitionseedValue)	
--END

--/* Create the Partition Scheme */

--IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU_AutoPT')
--BEGIN
--CREATE PARTITION SCHEME [PS_Dynamic_NU_AutoPT] as partition PF_Dynamic_NU_AutoPT all TO ([primary])
--END

/*** Part 4: Move the data out of the BPASessionLog_NonUnicode table ***/

/* Switch all BPASessionLog_NonUnicode data to BPASessionLog_NonUnicode_Temp table */

--begin transaction
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BPASessionLog_NonUnicode_Temp]') AND type in (N'U'))
--alter table BPASessionLog_NonUnicode_AutoPT switch to BPASessionLog_NonUnicode_Temp;
--commit transaction

/* Move the maximum logid from BPASessionLog_NonUnicode_Temp table to the BPASessionLog_NonUnicode_Temp02 table */
--Begin Transaction

--		set identity_insert BPASessionLog_NonUnicode_Temp02 on;

--        insert into BPASessionLog_NonUnicode_Temp02
--        (
--            logid,
--            sessionnumber,
--            stageid,
--            stagename,
--            stagetype,
--            processname,
--            pagename,
--            objectname,
--            actionname,
--            result,
--            resulttype,
--            startdatetime,
--            enddatetime,
--            attributexml,
--            automateworkingset,
--            targetappname,
--            targetappworkingset,
--            starttimezoneoffset,
--            endtimezoneoffset
--        )
-- select logid,
--               sessionnumber,
--               stageid,
--               stagename,
--               stagetype,
--               processname,
--               pagename,
--               objectname,
--               actionname,
--               result,
--               resulttype,
--               startdatetime,
--               enddatetime,
--               attributexml,
--               automateworkingset,
--               targetappname,
--               targetappworkingset,
--               starttimezoneoffset,
--               endtimezoneoffset
--        from
--            dbo.BPASessionLog_NonUnicode_Temp with (nolock)
--			where logid = (Select max(logid) from bpasessionlog_nonunicode_Temp);

--		set identity_insert BPASessionLog_NonUnicode_Temp02 off;

--Commit transaction;

/* Verify that the maximum logid from BPASessionLog_NonUnicode_Temp table has been copied to the BPASessionLog_NonUnicode_Temp02 table then delete this row from the BPASessionLog_NonUnicode_Temp table */

--Begin Transaction

--IF Exists (select logid from BPASessionLog_NonUnicode_Temp where logid = (Select max(logid) from bpasessionlog_nonunicode_Temp02))
--delete from BPASessionLog_NonUnicode_Temp where logid = (Select logid from bpasessionlog_nonunicode_Temp02)

--Commit transaction

/*** Part 5: Partiton the Table by adding the indexes to the PS_Dynamic_NU Schema***/

--clusterindexpartition = 
	--If (Select top 1 logid from [dbo].[BPASessionLog_NonUnicode_AutoPT]) is null
	--CREATE UNIQUE CLUSTERED INDEX [PK_BPASessionLog_NonUnicode_AutoPT]
	--ON [dbo].[BPASessionLog_NonUnicode_AutoPT](logid)
	--WITH (DROP_EXISTING = ON)
	--ON PS_Dynamic_NU_AutoPT1 (logid);

----	/****** Object:  Index [PK_BPASessionLog_NonUnicode_Temp]    Script Date: 02/10/2023 13:32:37 ******/
----ALTER TABLE [dbo].[BPASessionLog_NonUnicode_AutoPT] DROP CONSTRAINT [PK_BPASessionLog_NonUnicode_AutoPT] WITH ( ONLINE = OFF )
----GO

----/****** Object:  Index [PK_BPASessionLog_NonUnicode_Temp]    Script Date: 02/10/2023 13:32:37 ******/
----ALTER TABLE [dbo].[BPASessionLog_NonUnicode_AutoPT] ADD  CONSTRAINT [PK_BPASessionLog_NonUnicode_AutoPT] PRIMARY KEY CLUSTERED 
----(
----	[logid] ASC
----)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
----GO








--@nonclusterindexpartition = 
	
	--DROP INDEX [Index_BPASessionLog_NonUnicode_sessionnumber_AutoPT] ON [dbo].[BPASessionLog_NonUnicode_AutoPT];
	   
	--If (Select top 1 logid from [dbo].[BPASessionLog_NonUnicode_AutoPT]) is null
	--CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_sessionnumber_AutoPT] ON [dbo].[BPASessionLog_NonUnicode_AutoPT]
	--(
	--[sessionnumber] ASC
	--)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
	--ON PS_Dynamic_NU_AutoPT1 (logid);

/*** Part 6: Move the data back to the BPASessionLog_NonUnicode table ***/

/*** Add check min/max constraints to the BPASessionLog_NonUnicode_Temp table to switch the data back to the BPASessionLog_NonUnicode table ***/

--Begin
--Declare @MN bigint = (Select min(logid) from bpasessionlog_nonunicode_Temp)
--Declare @MX bigint = (Select max(logid) from bpasessionlog_nonunicode_Temp02)
--declare @sqlcmd01 nvarchar(500)
--declare @sqlcmd02 nvarchar(500)

--set @sqlcmd01 = N'alter table BPASessionLog_NonUnicode_Temp with check add constraint ckMinLogid check (logid is not null and logid >= ' + convert(varchar, @MN) + ' )'
--set @sqlcmd02 = N'alter table BPASessionLog_NonUnicode_Temp with check add constraint ckMaxLogid check (logid is not null and logid < ' + convert(varchar, @MX) + ' )'

--Exec sp_executesql @sqlcmd01;
--Exec sp_executesql @sqlcmd02;
--End

/* Switch all sessionlog temp02 data back to the production table */

--Begin transaction;

--ALTER TABLE dbo.BPASessionLog_NonUnicode_Temp SWITCH TO dbo.BPASessionLog_NonUnicode_AutoPT partition 1;

--commit transaction; 

/* Copy the maximum logid from temp02 to BPASessionLog_NonUnicode table */
--Begin Transaction

--		set identity_insert BPASessionLog_NonUnicode_AutoPT on;

--        insert into BPASessionLog_NonUnicode_AutoPT
--        (
--            logid,
--            sessionnumber,
--            stageid,
--            stagename,
--            stagetype,
--            processname,
--            pagename,
--            objectname,
--            actionname,
--            result,
--            resulttype,
--            startdatetime,
--            enddatetime,
--            attributexml,
--            automateworkingset,
--            targetappname,
--            targetappworkingset,
--            starttimezoneoffset,
--            endtimezoneoffset
--        )
-- select logid,
--               sessionnumber,
--               stageid,
--               stagename,
--               stagetype,
--               processname,
--               pagename,
--               objectname,
--               actionname,
--               result,
--               resulttype,
--               startdatetime,
--               enddatetime,
--               attributexml,
--               automateworkingset,
--               targetappname,
--               targetappworkingset,
--               starttimezoneoffset,
--               endtimezoneoffset
--        from
--            dbo.BPASessionLog_NonUnicode_Temp02 with (nolock);

--		set identity_insert BPASessionLog_NonUnicode_AutoPT off;

--Commit transaction;

/*** Part 7: Verify Partition and Clean up ***/

/* View Partitioned Table information */
SELECT
    OBJECT_SCHEMA_NAME(pstats.object_id) AS SchemaName
    ,OBJECT_NAME(pstats.object_id) AS TableName
    ,ps.name AS PartitionSchemeName
    ,ds.name AS PartitionFilegroupName
    ,pf.name AS PartitionFunctionName
    ,CASE pf.boundary_value_on_right WHEN 0 THEN 'Range Left' ELSE 'Range Right' END AS PartitionFunctionRange
    ,CASE pf.boundary_value_on_right WHEN 0 THEN 'Upper Boundary' ELSE 'Lower Boundary' END AS PartitionBoundary
    ,prv.value AS PartitionBoundaryValue
    ,c.name AS PartitionKey
    ,CASE 
        WHEN pf.boundary_value_on_right = 0 
        THEN c.name + ' > ' + CAST(ISNULL(LAG(prv.value) OVER(PARTITION BY pstats.object_id ORDER BY pstats.object_id, pstats.partition_number), 'Infinity') AS VARCHAR(100)) + ' and ' + c.name + ' <= ' + CAST(ISNULL(prv.value, 'Infinity') AS VARCHAR(100)) 
        ELSE c.name + ' >= ' + CAST(ISNULL(prv.value, 'Infinity') AS VARCHAR(100))  + ' and ' + c.name + ' < ' + CAST(ISNULL(LEAD(prv.value) OVER(PARTITION BY pstats.object_id ORDER BY pstats.object_id, pstats.partition_number), 'Infinity') AS VARCHAR(100))
    END AS PartitionRange
    ,pstats.partition_number AS PartitionNumber
    ,pstats.row_count AS PartitionRowCount
    ,p.data_compression_desc AS DataCompression
FROM sys.dm_db_partition_stats AS pstats
INNER JOIN sys.partitions AS p ON pstats.partition_id = p.partition_id
INNER JOIN sys.destination_data_spaces AS dds ON pstats.partition_number = dds.destination_id
INNER JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
INNER JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
INNER JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
INNER JOIN sys.indexes AS i ON pstats.object_id = i.object_id AND pstats.index_id = i.index_id AND dds.partition_scheme_id = i.data_space_id AND i.type <= 1 /* Heap or Clustered Index */
INNER JOIN sys.index_columns AS ic ON i.index_id = ic.index_id AND i.object_id = ic.object_id AND ic.partition_ordinal > 0
INNER JOIN sys.columns AS c ON pstats.object_id = c.object_id AND ic.column_id = c.column_id
LEFT JOIN sys.partition_range_values AS prv ON pf.function_id = prv.function_id AND pstats.partition_number = (CASE pf.boundary_value_on_right WHEN 0 THEN prv.boundary_id ELSE (prv.boundary_id+1) END)
WHERE pstats.object_id = OBJECT_ID('BPASessionLog_NonUnicode_AutoPT')
ORDER BY TableName, PartitionNumber;

/*** Drop Temp tables ***/
--DROP TABLE [dbo].[BPASessionLog_NonUnicode_Temp];
--DROP TABLE [dbo].[BPASessionLog_NonUnicode_Temp02]
