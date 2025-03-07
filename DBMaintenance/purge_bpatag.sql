--select count(*) from BPATag where id not in (select tagid from BPAWorkQueueItemTag)--356792--3510

----select * into BPATagBkp from BPATag

--select * from BPAWorkQueueItemTag where tagid in (2,3)

--delete from BPATag where id not in (select tagid from BPAWorkQueueItemTag)
--delete BPATag where id = 2
declare @id int, @count int, @int int
declare @table table (id int) 
insert @table
select top 100000 id from BPATag where id not in (select tagid from BPAWorkQueueItemTag)

select @count = count(*) from @table
set @int = 0
while @count > @int
begin
select top 1 @id = id from @table
--select @id

delete from BPATag where id = @id
delete @table where id = @id
set @int = @int + 1
end

select count(*) from BPATag with (nolock) where id not in (select tagid from BPAWorkQueueItemTag with (nolock))