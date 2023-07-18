

DECLARE @strClusterIndexpartitionUnicode NVARCHAR(MAX)
DECLARE @strNonclusterIndexpartitionUnicode NVARCHAR(MAX)
DECLARE @strClusterIndexpartitionNonUnicode NVARCHAR(MAX)
DECLARE @strNonClusterIndexpartitionNonUnicode NVARCHAR(MAX)

/****** Create Partition Function and Scheme ******/
IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
BEGIN
CREATE PARTITION FUNCTION [PF_Dynamic_NU](BIGINT) AS RANGE RIGHT FOR VALUES(10000)
END
IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
BEGIN
CREATE PARTITION SCHEME [PS_Dynamic_NU] AS PARTITION PF_Dynamic_NU ALL TO ([PRIMARY])
END

/****** Partition [dbo].[BPASessionLog_NonUnicode] Table ******/
IF (OBJECT_ID(N'[dbo].[BPASessionLog_NonUnicodeTest]',N'U')) IS NOT NULL 
BEGIN
	IF NOT EXISTS (SELECT 1
    FROM sys.tables t
	INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    AND i.type IN (0,1)
	INNER JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id
	WHERE t.name = 'BPASessionLog_NonUnicodeTest') 
	BEGIN
	IF EXISTS (SELECT 1
    FROM sys.tables t INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    WHERE i.name = 'PK_BPASessionLog_NonUnicodeTest2') 
	
	SET @strClusterIndexpartitionNonUnicode = '
	CREATE UNIQUE CLUSTERED INDEX [PK_BPASessionLog_NonUnicodeTest2]
	ON [dbo].[BPASessionLog_NonUnicodeTest](logid)
	WITH (DROP_EXISTING = ON)
	ON PS_Dynamic_NU (logid);'

	EXEC @strClusterIndexpartitionNonUnicode
	END	

	BEGIN
	IF EXISTS (SELECT 1
    FROM sys.tables t INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    WHERE i.name = 'Index_BPASessionLog_Unicode_sessionnumber') 
	
	SET @strNonclusterIndexpartitionUnicode = '
	
	DROP INDEX [Index_BPASessionLog_NonUnicode12Test_sessionnumber] ON [dbo].[BPASessionLog_NonUnicodeTest];
	   
	CREATE NONCLUSTERED INDEX [Index_BPASessionLog_NonUnicode12Test_sessionnumber] ON [dbo].[BPASessionLog_NonUnicodeTest]
	(
	[sessionnumber] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
	ON PS_Dynamic_NU (logid);'

	EXEC @strNonclusterIndexpartitionUnicode
	END
	
END

/****** Partition [dbo].[BPASessionLog_Unicode] Table ******/
IF (OBJECT_ID(N'[dbo].[BPASessionLog_UnicodeTest]',N'U')) IS NOT NULL 
BEGIN
	IF NOT EXISTS (SELECT 1
    FROM sys.tables t
	INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    AND i.type IN (0,1)
	INNER JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id
	WHERE t.name = 'BPASessionLog_UnicodeTest') 
	BEGIN
	IF EXISTS (SELECT 1
    FROM sys.tables t INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    WHERE i.name = 'PK_BPASessionLog_UnicodeTest') 

	SET @strClusterIndexpartitionUnicode = '
	CREATE UNIQUE CLUSTERED INDEX [PK_BPASessionLog_UnicodeTest]
	ON [dbo].[BPASessionLog_UnicodeTest](logid)
	WITH (DROP_EXISTING = ON)
	ON PS_Dynamic_NU (logid);'

	EXEC @strClusterIndexpartitionUnicode
	END	
	
	BEGIN
	IF EXISTS (SELECT 1
    FROM sys.tables t INNER JOIN sys.indexes i
    ON t.object_id = i.object_id
    WHERE i.name = 'Index_BPASessionLog_Unicode_sessionnumber') 
	
	SET @strNonclusterIndexpartitionUnicode = '
	
	DROP INDEX [Index_BPASessionLog_UnicodeTest_sessionnumber] ON [dbo].[BPASessionLog_UnicodeTest];
	   
	CREATE NONCLUSTERED INDEX [Index_BPASessionLog_UnicodeTest_sessionnumber] ON [dbo].[BPASessionLog_UnicodeTest]
	(
	[sessionnumber] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) 
	ON PS_Dynamic_NU (logid);'

	EXEC @strNonclusterIndexpartitionUnicode
	END
	
END

