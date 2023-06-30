SET NOCOUNT ON
DECLARE @schema nvarchar(10), @table nvarchar(200), @index nvarchar(200), 
		@fragment float, @str nvarchar(400),@partition_id tinyint, @debug bit = 1

DROP TABLE IF EXISTS dbo.indexmaintenance;

CREATE TABLE indexmaintenance(
[schema] varchar(10),
[table] varchar(200),
[index] varchar(200),
[fragment] float,
[processeddate] datetime
)

DROP TABLE IF EXISTS dbo.#Partitioned
CREATE TABLE #Partitioned (
TableName sysname,
Partitiion_id sysname,
IndexName sysname
)

;with cte_1
as
(
select 
OBJECT_NAME(object_id)'TableName',partition_number,
ROW_NUMBER() over (partition by object_id order by index_id) 'Position'
from  sys.partitions 
where OBJECT_NAME(object_id) like 'BPA%'
)
insert #Partitioned
select distinct  OBJECT_NAME(p.object_id),
partition_number,i.name
from
sys.partitions p join sys.indexes i on p.object_id = i.object_id and p.index_id = i.index_id
where OBJECT_NAME(p.object_id) in
(select distinct a.TableName 
from cte_1 a 
where a.partition_number > 1)

DECLARE defrag_index CURSOR
FOR
SELECT  
SCHEMA_NAME(o.[schema_id]) AS [Schema Name],
OBJECT_NAME(ps.OBJECT_ID) AS [Object Name], 
i.[name] AS [Index Name], 
ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL, NULL, NULL , N'LIMITED') AS ps
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON ps.[object_id] = i.[object_id] 
AND ps.index_id = i.index_id
INNER JOIN sys.objects AS o WITH (NOLOCK)
ON i.[object_id] = o.[object_id]
WHERE ps.database_id = DB_ID()
AND ps.page_count > 500 AND ps.avg_fragmentation_in_percent > 29.99
AND OBJECT_NAME(ps.OBJECT_ID) NOT LIKE '%PRE65' AND i.[name] IS NOT NULL
ORDER BY OBJECT_NAME(ps.OBJECT_ID) ,ps.avg_fragmentation_in_percent DESC OPTION (RECOMPILE);

OPEN defrag_index

FETCH NEXT FROM defrag_index INTO @schema, @table, @index, @fragment

WHILE @@FETCH_STATUS = 0

BEGIN
--PRINT  @schema +' '+ @table+' '+ @index+' ' + convert(nvarchar(10),@fragment)
IF @table = 'BPASessionLog_NonUnicode'
BEGIN
	IF EXISTS (SELECT 1 FROM #Partitioned WHERE TableName = @table)
	BEGIN
	SELECT @partition_id = Partitiion_id FROM #Partitioned WHERE TableName = @table AND IndexName = @index
	END
		BEGIN
		SET @str = 'ALTER INDEX '+@index +' ON '+@schema+'.'+@table+ ' REORGANIZE PARTITION '+CONVERT(NVARCHAR(10),@partition_id)
		--ALTER INDEX [PK_bpsessionlogPartitionTest] ON bpsessionlogPartitionTest REORGANIZE PARTITION = 3
		PRINT (@str)
		END
END
	



--INSERT indexmaintenance VALUES(@schema,@table,@index,@fragment,getdate())


FETCH NEXT FROM defrag_index INTO @schema, @table, @index, @fragment
END
CLOSE defrag_index
DEALLOCATE defrag_index

select * from #Partitioned
SET NOCOUNT OFF