--/*
--1.Drop Schema binding view
----DROP VIEW aavw_Sessionnumber
----DROP VIEW aavw_ControlTableUpdate

--2.Switch prod sessionlog table to copy
----ALTER TABLE [dbo].[BPASessionLog_NonUnicode] SWITCH TO [dbo].[BPASessionLog_NonUnicodeCopy];


--3. Initialize Partitioned seesion log table- Copy top 1000 records from copy to prod
--SET IDENTITY_INSERT [dbo].[BPASessionLog_NonUnicode] ON
--INSERT INTO [dbo].[BPASessionLog_NonUnicode]
--           ([logid]
--		   ,[sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset])
-- SELECT	TOP 1000	[logid]
--		   ,[sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset]
--FROM [dbo].[BPASessionLog_NonUnicodeCopy] WITH (NOLOCK)
--ORDER BY logid DESC
--SET IDENTITY_INSERT [dbo].[BPASessionLog_NonUnicode] OFF

--2.Create Partiton Function & Scheme
--/**Identity partition seed value **/
--DECLARE @nextPartitionID bigint --Maximum logid or seed value in BPASessionLog Table
--DECLARE @partitionseedValue bigint --Partition function seed value

--SELECT @nextPartitionID = IDENT_CURRENT('dbo.BPASessionLog_NonUnicode')

--IF @nextPartitionID = 1 SET @partitionseedValue = 0 ELSE SET @partitionseedValue = @nextPartitionID

--/**Create partition function and scheme **/

--IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
--BEGIN
--CREATE PARTITION FUNCTION [PF_Dynamic_NU](bigint) AS range right for values(@partitionseedValue)	
--END
--IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
--BEGIN
--CREATE PARTITION SCHEME [PS_Dynamic_NU] as partition PF_Dynamic_NU all TO ([primary])
--END

--4.Partiton Table
----clusterindexpartition = '
	--CREATE UNIQUE CLUSTERED INDEX [PK_BPASessionLog_NonUnicode]
	--ON [dbo].[BPASessionLog_NonUnicode](logid)
	--WITH (DROP_EXISTING = ON)
	--ON PS_Dynamic_NU (logid);

----@nonclusterindexpartition = '
	
	--DROP INDEX [Index_BPASessionLog_NonUnicode_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode];
	   
	--CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode]
	--(
	--[sessionnumber] ASC
	--)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
	--ON PS_Dynamic_NU (logid);

--5.Confirm partition
SELECT
    t.name AS [Table],
    i.name AS [Index],
    i.type_desc,
    i.is_primary_key,
    ps.name AS [Partition Scheme],
	pf.name AS [Partition Function]
FROM sys.tables t
INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    AND i.type IN (0,1)
INNER JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id
INNER JOIN sys.partition_functions pf
	ON ps.function_id = pf.function_id


	SELECT 
    t.name AS [Table], 
    i.name AS [Index], 
    p.partition_number,
    f.name 'FunctionName',
    r.boundary_id, 
    r.value AS [Boundary Value] ,
	p.rows
	FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE i.type = 1 AND t.name = 'BPASessionLog_NonUnicode' 
ORDER BY p.partition_number ASC;

--6--Copy retained data to partitioned session log table
--SET IDENTITY_INSERT [dbo].[BPASessionLog_NonUnicode] ON
--INSERT INTO [dbo].[BPASessionLog_NonUnicode]
--           ([logid]
--		   ,[sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset])
-- SELECT		[logid]
--		   ,[sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset]
--FROM [dbo].[BPASessionLog_NonUnicodeCopy] WITH (NOLOCK)
--WHERE LOGID >= 581595020 AND LOGID < 583235083
--SET IDENTITY_INSERT [dbo].[BPASessionLog_NonUnicode] OFF

--7.Drop [dbo].[BPASessionLog_NonUnicodeCopy]
--DROP TABLE [dbo].[BPASessionLog_NonUnicodeCopy]
--*/