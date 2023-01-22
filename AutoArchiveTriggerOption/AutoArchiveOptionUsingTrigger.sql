/*Create bpasession update history table*/
create table tblBPASessionUpdateTracking (
[sessionid] uniqueidentifier,
[sessionnumber] int,
[startdatetime] datetime,
[enddatetime] datetime,
copystatus bit Null,
copydate datetime Null
)

create table tblSessionReadyToCopy (
[sessionnumber] int
)


/*
Create update trigger on bpasession table
Trigger updates bpasession update history table with all updates 
affecting enddatetime column - No cost (Table automation)
*/
create trigger triggerBPASessionUpdateTracking on [dbo].[BPASession]
after update
as
if  exists (select 1 from inserted WHERE enddatetime is not null)
begin
insert tblBPASessionUpdateTracking ([sessionid],[sessionnumber],[startdatetime],[enddatetime] )
select [sessionid],[sessionnumber],[startdatetime],[enddatetime] from inserted
end

/*
Copy completed sessionlog data based on 
bpasession update history table - ADF
*/
--select * from [dbo].[BPASessionLog_NonUnicode] 
--WHERE sessionnumber in (select sessionnumber from OkeTriggerTableTest WHERE [status] is null or[status] = 0)
EXECUTE COPY_SESSIONLOG SCRIPT

/*
Update status in
bpasession update history table - ADF
*/

update tblBPASessionUpdateTracking 
set copystatus = 1, copydate = GETDATE()
WHERE sessionnumber IN (SELECT sessionnumber FROM tblSessionReadyToCopy)

/*
Delete Copied sessionlog data - ADF
*/
delete [dbo].[BPASessionLog_NonUnicode] s join tblBPASessionUpdateTracking t
on s.sessionnumber = t.sessionnumber
WHERE t.copystatus = 1

/* Testing
select * from [dbo].[BPASession] --WHERE sessionnumber = 51 
order by enddatetime desc
--WHERE enddatetime is null

update [dbo].[BPASession]
set enddatetime = Null
WHERE sessionnumber in (105	,
51	,
100	,
103	,
101	,
94	,
93	,
72	,
87	,
1030	,
584	,
583	,
582	,
581	,
609	,
590	,
588	,
589	,
587	
)

update [dbo].[BPASession]
set enddatetime = getdate()
WHERE sessionnumber in (
105	,
51	
)

select * from tblBPASessionUpdateTracking

--truncate table tblBPASessionUpdateTracking
*/