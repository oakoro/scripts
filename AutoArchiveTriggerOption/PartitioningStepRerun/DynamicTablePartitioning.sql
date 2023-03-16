/****Step 1 Create Test table creation ***/

CREATE TABLE [dbo].[dynamicPartitionTest](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[activitykey] [int] NOT NULL,
	[activityDate] [datetime] NOT NULL,
	[amount] [money] NOT NULL,
 CONSTRAINT [PK_dynamicPartitionTest] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]



/****Step 2 Create dynamic partition function and scheme***/
create partition function PF_dynamicPartition(int) as range right for values()	
create partition scheme PS_dynamicPartition as partition PF_dynamicPartition all to ([primary])


/***Step 3 Create Table Partition ***/
CREATE UNIQUE CLUSTERED INDEX [PK_dynamicPartitionTest]
    ON dbo.dynamicPartitionTest (id)
    WITH (DROP_EXISTING = ON)
    ON PS_dynamicPartition (id)



/***Step 4 Get top id and create partition boundaries ***/

declare @firstPartitonID int, @nextPartitionID int
select @firstPartitonID = IDENT_CURRENT('dbo.dynamicPartitionTest') -- Get last identity number in the table

---Test if partitiopn already exist and create the next partiton
if not exists(
select prv.value
from sys.partition_functions as pf
join sys.partition_range_values as prv on pf.function_id = prv.function_id
where pf.name = 'PF_dynamicPartition' and prv.value = @firstPartitonID
)
begin
alter partition scheme PS_dynamicPartition next used [primary];
alter partition function PF_dynamicPartition() split range(@firstPartitonID);
end
else
begin
set @firstPartitonID = @nextPartitionID
alter partition scheme PS_dynamicPartition next used [primary];
alter partition function PF_dynamicPartition() split range(@nextPartitionID);
end



/* test***
select *
from sys.partition_functions as pf
join sys.partition_range_values as prv on pf.function_id = prv.function_id
where pf.name = 'PF_dynamicPartition'

select * from sys.partitions where OBJECT_ID = object_id(N'dbo.dynamicPartitionTest')
and partition_number = 1 and index_id in (0,1)
*/