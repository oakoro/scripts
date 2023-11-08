definition
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- =====================================================================================
-- Description: Master stored procedure that calls BPASessionlog partition management SPs
-- Script execution Example: BPC.aasp_manage_BPASessionlogpartitions
-- Alter statement added to change partition retention from 6 to 5
-- =======================================================================================

CREATE PROCEDURE [BPC].[aasp_manage_BPASessionlogpartitions]

AS
IF EXISTS(SELECT 1 FROM sys.indexes i     
			INNER JOIN sys.partition_schemes ps   
			ON i.data_space_id = ps.data_space_id
WHERE OBJECT_NAME(object_id) in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode'))
BEGIN
-- Create new partition if required - Call [BPC].[aasp_create_New_Sessionlog_partition]  .
EXECUTE [BPC].[aasp_create_New_Sessionlog_partition] 
   @tablename = '[dbo].[BPASessionLog_NonUnicode]'
  ,@partitionfunction = 'PF_Dynamic_NU';


-- Drop copied partition - Call [BPC].[aasp_delete_copied_Sessionlog_partition] 
EXECUTE [BPC].[aasp_delete_copied_Sessionlog_partition] 
   @tableschema = 'dbo'
  ,@tablename = 'BPASessionLog_NonUnicode'
  ,@partitionfunction = 'PF_Dynamic_NU'
  ,@partitionsretained = 5;
  END

-- =============================================
-- Description: Create new partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_create_New_Sessionlog_partition] '[dbo].[BPASessionLog_NonUnicode]','PF_Dynamic_NU'
-- variable description: 
--	@tablename - Partitioned table name, 
--  @partitionfunction - partition function
-- =============================================

CREATE PROCEDURE [BPC].[aasp_create_New_Sessionlog_partition]
@tablename NVARCHAR(400),@partitionfunction NVARCHAR(50)

AS

DECLARE @nextPartitionID BIGINT
SELECT @nextPartitionID = IDENT_CURRENT(@tablename)




---Test if partitiopn already exist and create the next partiton
IF @nextPartitionID IS NOT NULL
BEGIN
IF NOT EXISTS(
SELECT prv.value
FROM sys.partition_functions AS pf
join sys.partition_range_values AS prv ON pf.function_id = prv.function_id
WHERE pf.name = @partitionfunction AND prv.value = @nextPartitionID
)
BEGIN
alter partition scheme PS_Dynamic_NU next used [primary];
alter partition function PF_Dynamic_NU() split range(@nextPartitionID);
END
ELSE
BEGIN
PRINT 'Partition already exists';
END
END

-- =============================================
-- Description: Updates adf watermark table for Workqueueitem
-- variable description: 
--	@tablename - Table copied e.g Workqueueitem, 
--  @last_processed_date - Date of last table copy
-- =============================================


CREATE PROC [BPC].[aasp_Update_adf_watermark_WQI]
@last_processed_date datetime, 
@tablename varchar(50)

AS

BEGIN

    UPDATE [BPC].[adf_watermark] SET last_processed_date = @last_processed_date
    WHERE tablename = @tablename

END


-- =============================================
-- Description: Delete copied partition in BPASessionLog_NonUnicode table
-- Script execution Example: BPC.aasp_delete_copied_Sessionlog_partition 'dbo','BPASessionLog_NonUnicode','PF_Dynamic_NU',2
-- variable description: 
--	@tableschema - Table Schema, @tablename - Partitioned table name, 
--  @partitionfunction - partition function, @partitionsretained - No of retained partitions
-- =============================================

CREATE PROCEDURE [BPC].[aasp_delete_copied_Sessionlog_partition]
@tableschema NVARCHAR(20), @tablename NVARCHAR(400),@partitionfunction NVARCHAR(50),@partitionsretained TINYINT

AS

DECLARE @nextpartitionboundarytodelete BIGINT -- Oldest Next partiton boundary to delete
DECLARE @truncatetablestr NVARCHAR(200) -- Partition truncate script
DECLARE @partitionnumber NVARCHAR(20) -- Partition number to delete
DECLARE @lastprocessedlogid BIGINT -- Last logid copied to data lake
DECLARE @partitionboundarycount TINYINT -- Existing table partitions
DECLARE @alterpartationstr NVARCHAR(200) -- Partition delete script

SELECT @lastprocessedlogid = logid FROM [BPC].[adf_watermark] WHERE tablename = @tablename;

SELECT @partitionboundarycount = COUNT(*) FROM sys.partition_range_values r JOIN sys.partition_functions f ON r.function_id = f.function_id
WHERE f.name = @partitionfunction 

;WITH cte_tablepartitioninfo
AS
(
SELECT 
     p.partition_number,
     CONVERT(BIGINT,r.value) AS [Boundary_Value] ,
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
    ON f.function_id = r.function_id AND r.boundary_id = p.partition_number  
WHERE i.type <= 1 AND SCHEMA_NAME(t.schema_id) = @tableschema AND t.name = @tablename 
)
SELECT TOP 1 @nextpartitionboundarytodelete =  Boundary_Value, @partitionnumber = partition_number FROM cte_tablepartitioninfo 
ORDER BY partition_number 


IF @nextpartitionboundarytodelete IS NOT NULL AND @lastprocessedlogid >= @nextpartitionboundarytodelete AND @partitionboundarycount > @partitionsretained
BEGIN
SET @truncatetablestr = 'truncate table ' +@tableschema+'.' +@tablename + ' with (partitions ('+@partitionnumber+'))'


SET @alterpartationstr = 'alter partition function '+@partitionfunction+'() merge range('+convert(NVARCHAR(20),@nextpartitionboundarytodelete)+')'


EXECUTE sp_executesql @truncatetablestr
EXECUTE sp_executesql @alterpartationstr

END


-- ===================================================================================
-- Description: Get maximum logid to copy. Where chunksize is not provided, 
-- maximum logid will default to actual maximum logid in BPASessionLog_NonUnicode table
-- Usages: 
-- If chunksize is provided: 
-- EXEC [BPC].[adfsp_get_maxlogid] 330000000,  10000000
-- If chunksize is NOT provided: 
-- EXEC [BPC].[adfsp_get_maxlogid] 330000000
-- ====================================================================================

CREATE PROCEDURE [BPC].[adfsp_get_maxlogid]
(
	 @minlogid BIGINT, @rowamt BIGINT = NULL
)
AS

SET NOCOUNT ON	
	
	DECLARE @addrow BIGINT, @maxLogid BIGINT
	DECLARE @mxid BIGINT =  (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))
	

	IF @rowamt IS NOT NULL
		BEGIN
		SET @addrow = @minlogid + @rowamt
		END
		ELSE SET @addrow = 0

	IF @mxid IS NOT NULL AND @addrow = 0
		BEGIN
			SET @maxLogid = @mxid
		END
		ELSE IF @mxid IS NOT NULL AND @addrow <> 0
		BEGIN
			IF @mxid >= @addrow
			BEGIN
			SET @maxLogid = @addrow
			END
			ELSE SET @maxLogid = @mxid
		END 
		ELSE IF @mxid IS NULL
		SET @maxLogid = @minlogid
		
SELECT @maxLogid as 'MaxLogid'	
SET NOCOUNT OFF	

                    -- ==============================================================================
                    -- Description: Get minimum logid to copy
                    -- Usage: EXEC [BPC].[adfsp_get_minlogid] 'BPASessionLog_NonUnicode'
                    -- ==============================================================================
                    
                    CREATE PROCEDURE [BPC].[adfsp_get_minlogid]
                         @tableName NVARCHAR(255)
                    
                    
                    AS
                    
                    DECLARE @sqlCommandWM NVARCHAR(1000),
                        @ParmDefinition NVARCHAR(500),
                        @minlogidWM NVARCHAR(20),
                        @minlogidWMOUT BIGINT,
                        @sqlCommandActual NVARCHAR(1000),
                        @ParmDefinition1 NVARCHAR(500),
                        @minlogidActual BIGINT,
                        @minlogidActualOUT BIGINT,
                        @minLogid BIGINT
                    
                    
                    SET @sqlCommandWM = N'SELECT @minlogidWM = logid  FROM bpc.adf_watermark WHERE tableName = ''' + @tableName + ''';'
                    SET @ParmDefinition = N'@tableName NVARCHAR(255), @minlogidWM BIGINT OUTPUT';
                    EXEC sp_EXECutesql @sqlCommandWM, @ParmDefinition, @tableName = @tableName, @minlogidWM = @minlogidWMOUT OUTPUT;
                    
                    
                    
                    SET @sqlCommandActual = N'SELECT TOP 1 @minlogidActual = logid FROM dbo.'+@tableName +' WITH (nolock) WHERE logid >= '+CONVERT(NVARCHAR(20),@minlogidWMOUT) +' ORDER BY logid'
                    SET @ParmDefinition1 = N'@tableName NVARCHAR(255), @minlogidActual BIGINT OUTPUT';
                    EXEC sp_EXECutesql @sqlCommandActual, @ParmDefinition1, @tableName = @tableName, @minlogidActual = @minlogidActualOUT OUTPUT;
                    
                    
                    IF @minlogidActualOUT > @minlogidWMOUT
                    BEGIN
                    SELECT @minlogidActualOUT AS 'minlogid'
                    END
                    ELSE
                    SELECT @minlogidWMOUT AS 'minlogid'
                    


-- ==============================================================================
-- Description: Copy data from BPASessionLog_NonUnicode table to ADLS
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_get_sessionlog_data]
(
	@tableName nvarchar(30), @minlogid bigint, @maxlogid bigint
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @sqlCommand nvarchar(1000),
	@ParmDefinition nvarchar(500)

set @sqlCommand = N'select logid, sessionnumber, stageid, stagename, stagetype, processname, pagename, objectname, actionname, result, resulttype, startdatetime, enddatetime, attributexml, automateworkingset ,targetappname, targetappworkingset, starttimezoneoffset, endtimezoneoffset, attributesize from dbo.' + @tableName + ' with (nolock) where logid > ' + CONVERT(nvarchar,@minlogid) + ' and  logid <= ' + CONVERT(nvarchar,@maxlogid) + ' order by logid;';
set @ParmDefinition = N'@tableName nvarchar(255), @minlogid bigint, @maxlogid bigint';
Exec sp_executesql @sqlCommand, @ParmDefinition, @tableName = @tableName, @minlogid = @minlogid, @maxlogid = @maxlogid

END


-- ==============================================================================
-- Description: Update adf watermark table after copy from BPASessionLog_NonUnicode table
-- ==============================================================================

CREATE PROC [BPC].[adfsp_update_watermark_sessionlog]
 @logid bigint,
 @tableName varchar(255)
 AS

 BEGIN
   UPDATE bpc.adf_watermark
   SET logid = @logid, 
   last_processed_date = GETDATE()
   WHERE tableName = @tableName
 END


