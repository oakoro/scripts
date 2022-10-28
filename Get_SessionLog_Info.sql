begin
declare @tbl table(NewestLogDate datetime,OldestLogDate datetime,RecordCount bigint,SQLServer varchar(400),DBName varchar(50),RunDate datetime);
declare @NewestDate datetime, @OldestDate datetime,@rowCount bigint;
with cte_BPASessionLog1
as
(
select top 1 startdatetime 'NewestDate' from BPASessionLog_NonUnicode
order by logid desc
)
select @NewestDate = NewestDate from cte_BPASessionLog1;

with cte_BPASessionLog2
as
(
select top 1 startdatetime 'OldestDate' from BPASessionLog_NonUnicode
order by logid 
)
select @OldestDate = OldestDate  from cte_BPASessionLog2;

with cte_BPASessionLog3
as
(
select distinct rows
 from sys.partitions
where OBJECT_NAME(object_id) = 'BPASessionLog_NonUnicode' 
)
select @rowCount = rows  from cte_BPASessionLog3;
insert @tbl (OldestLogDate,NewestLogDate,RecordCount,SQLServer,DBName,RunDate)
select @OldestDate,@NewestDate,@rowCount,@@SERVERNAME,DB_NAME(),getdate();
select * from @tbl
end
