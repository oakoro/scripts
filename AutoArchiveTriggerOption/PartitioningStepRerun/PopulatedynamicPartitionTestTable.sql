
--set identity_insert dynamicPartitionTest1 on
--insert dynamicPartitionTest1([id],[activitykey],[activityDate],[amount])
--select [id],[activitykey],[activityDate],[amount] from dynamicPartitionTest
--set identity_insert dynamicPartitionTest1 off

--declare @int int = 10
----set @int = 10
--while (@int > 0)
--begin
--select @int
--declare @a int, @b datetime = getdate(), @c money
--select top 1 @a=[activitykey],@b = [activityDate], @c=  [amount] from dynamicPartitionTest order by id desc
----select @a, @b, @c
--insert dynamicPartitionTest([activitykey],[activityDate],[amount])
--values(@a+2,@b,@c +2.7)
--set @int = @int - 1
--end






