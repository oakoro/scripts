/****** Partition [dbo].[BPASessionLog_NonUnicode] Table ******/

DECLARE @clusterindexpartition nvarchar(max), @nonclusterindexpartition nvarchar(max)
IF (OBJECT_ID(N'[dbo].[BPASessionLog_NonUnicode]',N'U')) IS NOT NULL 
BEGIN
	IF NOT EXISTS (SELECT 1
    FROM sys.tables t
	INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    AND i.type IN (0,1)
	INNER JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id
	WHERE t.name = 'BPASessionLog_NonUnicode') 
	BEGIN
	IF EXISTS (SELECT 1
    FROM sys.tables t INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    WHERE i.name = 'PK_BPASessionLog_NonUnicode') 
	
	SET @clusterindexpartition = '
	CREATE UNIQUE CLUSTERED INDEX [PK_BPASessionLog_NonUnicode]
	ON [dbo].[BPASessionLog_NonUnicode](logid)
	WITH (DROP_EXISTING = ON)
	ON PS_Dynamic_NU (logid);'
	PRINT @clusterindexpartition
	END	
	BEGIN
	IF EXISTS (SELECT 1
    FROM sys.tables t INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    WHERE i.name = 'Index_BPASessionLog_NonUnicode_sessionnumber') 
	
	SET @nonclusterindexpartition = '
	
	DROP INDEX [Index_BPASessionLog_NonUnicode_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode];
	   
	CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode_sessionnumber] ON [dbo].[BPASessionLog_NonUnicode]
	(
	[sessionnumber] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
	ON PS_Dynamic_NU (logid);'

	PRINT @nonclusterindexpartition
	END
	
END




