--no boundaries initially - proc will create as needed

--CREATE PARTITION FUNCTION PF_MyPartitionFunction(datetime)
--AS RANGE RIGHT FOR VALUES();
--go

--CREATE PARTITION SCHEME PS_MyPartitionScheme
--AS PARTITION PF_MyPartitionFunction ALL TO ([PRIMARY]);
--go
--CREATE TABLE dbo.MyPartitionedTable
--(  PartitionColumnDateTime datetime
--) ON PS_MyPartitionScheme(PartitionColumnDateTime)

--CREATE TABLE dbo.MyPartitionedTable_Staging
--(      PartitionColumnDateTime datetime
--) ON PS_MyPartitionScheme(PartitionColumnDateTime)
--GO