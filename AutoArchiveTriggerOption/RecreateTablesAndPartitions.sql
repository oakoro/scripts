--drop table dbo.MyPartitionedTable
--drop table dbo.MyPartitionedTable_Staging
--drop PARTITION SCHEME PS_MyPartitionScheme
--drop PARTITION FUNCTION PF_MyPartitionFunction
select * from [dbo].[MyPartitionedTable]
select * from [dbo].[MyPartitionedTable_Staging]

--delete  from [dbo].[MyPartitionedTable]

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

