select OBJECT_NAME(object_id),* from sys.partitions
where object_id in (object_id('sessionlog'),object_id('partitiontest'),object_id('sessionlog_partitioned'))

--create partition function sessionlog_partition_function(float)
--	as range right for values (4,8,12);

--create partition scheme sessionlog_partition_scheme
--	as partition sessionlog_partition_function
--	all to ('primary')

--create table partitiontest ([sessionnumber] float, [startdatetime] datetime)
--on sessionlog_partition_scheme([sessionnumber])

--create partition function sessionlog_partition_function1(int)
--	as range right for values (200,400,600,800);

--create partition scheme sessionlog_partition_scheme2
--	as partition sessionlog_partition_function1
--	all to ('primary')


--create clustered index pk_sessionnumber_sessionlog
--on sessionlog_partitioned(id) on sessionlog_partition_scheme2(id)