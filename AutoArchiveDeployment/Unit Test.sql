--/**Identity partition seed value **/
--DECLARE @nextPartitionID bigint, @seedValue bigint
--SELECT @nextPartitionID = IDENT_CURRENT('dbo.BPASessionLog_NonUnicodeCopy'),
--SELECT @nextPartitionID 'NextPartiton'
--IF @nextPartitionID = 1 SET @seedValue = 0 ELSE SET @seedValue = @nextPartitionID
--SELECT @seedValue'seedValue'
--CREATE PARTITION FUNCTION [PF_Dynamic_NU](bigint), as range right for values(@seedValue),	
--CREATE PARTITION SCHEME [PS_Dynamic_NU] as partition PF_Dynamic_NU all to ([primary]),
----SELECT * FROM dbo.BPASessionLog_NonUnicodeCopy
--drop partition scheme [PS_Dynamic_NU]
--drop partition function [PF_Dynamic_NU]
----truncate table dbo.BPASessionLog_NonUnicodeCopy

--SELECT * FROM sys.partition_functions
--SELECT * FROM sys.partition_schemes

--Create Schema
--select * from sys.schemas where name = 'BPC'
--drop schema [BPC]
--IF (SELECT SCHEMA_ID('BPC'),), IS NULL
--BEGIN
--EXECUTE('CREATE SCHEMA [BPC];'),
--END


