/*Create bpasession update history table*/
create table OkeTriggerTableTest (
[sessionid] uniqueidentifier,
[sessionnumber] int,
[startdatetime] datetime,
[enddatetime] datetime,
status bit Null
)

create table tblSessionReadyToCopy (
[sessionnumber] int
)


/*
Create update trigger on bpasession table
Trigger updates bpasession update history table with all updates 
affecting enddatetime column - No cost (Table automation)
*/
alter trigger tiggerOketest on [dbo].[BPASession]
after update
as
if  exists (select 1 from inserted where enddatetime is not null)
begin
insert OkeTriggerTableTest ([sessionid],[sessionnumber],[startdatetime],[enddatetime] )
select [sessionid],[sessionnumber],[startdatetime],[enddatetime] from inserted
end

/*
Copy completed sessionlog data based on 
bpasession update history table - ADF
*/
select * from [dbo].[BPASessionLog_NonUnicode] 
where sessionnumber in (select sessionnumber from OkeTriggerTableTest where [status] is null or[status] = 0)

/*
Update status in
bpasession update history table - ADF
*/

update OkeTriggerTableTest 
set status = 1
where [status] is null or [status] = 0

/*
Delete Copied sessionlog data - ADF
*/
delete [dbo].[BPASessionLog_NonUnicode] s join OkeTriggerTableTest t
on s.sessionnumber = t.sessionnumber
where t.status = 1

/* Testing
select * from [dbo].[BPASession] --where sessionnumber = 51 
order by enddatetime desc
--where enddatetime is null

update [dbo].[BPASession]
set enddatetime = Null
where sessionnumber in (select sessionnumber from OkeTriggerTableTest)
--sessionid = 'DAD4E939-3E07-4F35-9907-03BC4CEE8C12'

update [dbo].[BPASession]
set enddatetime = getdate()
where sessionnumber in (
609
)

select * from OkeTriggerTableTest

--truncate table OkeTriggerTableTest
*/