/****** Object:  StoredProcedure [BPC].[aasp_create_New_Sessionlog_partition]    Script Date: 20/09/2023 16:10:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Description: Create new partition in BPASessionLog_NonUnicode table
-- Script execution Example: [BPC].[aasp_create_New_Sessionlog_partition] '[dbo].[BPASessionLog_NonUnicode]','PF_Dynamic_NU'
-- variable description: 
--	@tablename - Partitioned table name, 
--  @partitionfunction - partition function
-- Automate for unicode and non-unicode
-- Check for existing partition Boundary Value
-- =============================================

ALTER PROCEDURE [BPC].[aasp_create_New_Sessionlog_partition_Test_Unicode]
@partitionfunction NVARCHAR(50) = 'PS_Dynamic_NUTest'

AS

DECLARE @nextPartitionID BIGINT,
		@LoggingType BIT,
		@sessionLogtable NVARCHAR(50),
		@existingBoundaryValue BIGINT

SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	SET @LoggingType = 1
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_UnicodeTest1'

SELECT @nextPartitionID = IDENT_CURRENT(@sessionlogtable)

SELECT TOP 1 @existingBoundaryValue = CONVERT(BIGINT,r.value)
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
WHERE i.type = 1 AND t.name = @sessionlogtable and  r.value IS NOT NULL
ORDER BY p.partition_number DESC ;


---Test if partitiopn already exist and create the next partiton
IF @nextPartitionID IS NOT NULL AND @nextPartitionID <> @existingBoundaryValue
BEGIN
IF NOT EXISTS(
SELECT prv.value
FROM sys.partition_functions AS pf
join sys.partition_range_values AS prv ON pf.function_id = prv.function_id
WHERE pf.name = @partitionfunction AND prv.value = @nextPartitionID
)
BEGIN
alter partition scheme PS_Dynamic_NUTest next used [primary];
alter partition function PF_Dynamic_NUTest() split range(@nextPartitionID);
END
END
GO


