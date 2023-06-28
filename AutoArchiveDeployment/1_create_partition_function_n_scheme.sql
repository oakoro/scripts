/**Identity partition seed value **/
DECLARE @nextPartitionID bigint --Maximum logid or seed value in BPASessionLog Table
DECLARE @partitionseedValue bigint --Partition function seed value

SELECT @nextPartitionID = IDENT_CURRENT('dbo.BPASessionLog_NonUnicodeCopy')

IF @nextPartitionID = 1 SET @partitionseedValue = 0 ELSE SET @partitionseedValue = @nextPartitionID

/**Create partition function and scheme **/

IF NOT EXISTS(SELECT 1 FROM sys.partition_functions WHERE name = 'PF_Dynamic_NU')
BEGIN
CREATE PARTITION FUNCTION [PF_Dynamic_NU](bigint) AS range right for values(@partitionseedValue)	
END
IF NOT EXISTS(SELECT 1 FROM sys.partition_schemes WHERE name = 'PS_Dynamic_NU')
BEGIN
CREATE PARTITION SCHEME [PS_Dynamic_NU] as partition PF_Dynamic_NU all TO ([primary])
END
