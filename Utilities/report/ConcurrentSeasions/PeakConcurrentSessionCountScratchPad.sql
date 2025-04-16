DECLARE @now DATETIME = GETDATE(), @days INT = 3,@defaultDate DATETIME
SET @defaultDate =  DATEADD(DAY,-@days,@now) 
--SELECT @defaultDate 

declare @int int, @count int ,@eventdate datetime
declare @tblevent table (
	startdatetime datetime,
	enddatetime datetime,
	duration int
)
declare @tbleventSummary table (
	eventdate datetime,
	concurrentrun int
)


;with cte_raw
as
(
select --sessionnumber,
--ISNULL(startdatetime,@defaultDate)'startdatetime',
FORMAT(ISNULL(startdatetime,@defaultDate),'yyyy-MM-dd HH:mm')'startdatetime',
--enddatetime,
--ISNULL(enddatetime,dateadd(SECOND,s.lastupdatedtimezoneoffset,@now))'enddatetime'
FORMAT(ISNULL(enddatetime,dateadd(SECOND,s.starttimezoneoffset,@now)),'yyyy-MM-dd HH:mm')'enddatetime'
--dateadd(SECOND,s.lastupdatedtimezoneoffset,@defaultDate)'defaultdate',
--s.statusid,
--st.description,
--r.name,
--s.lastupdatedtimezoneoffset
FROM dbo.BPASession s WITH (NOLOCK) join dbo.BPAStatus st WITH (NOLOCK) 
on s.statusid = st.statusid
join dbo.BPAResource r on r.resourceid = s.runningresourceid
where enddatetime is null or 
startdatetime >= DATEADD(DAY, -@days, @now)
--or
--enddatetime is null 
--order by startdatetime
)
--select * from cte_raw order by enddatetime
,
cte_data
as
(
select startdatetime,enddatetime,datediff(mi,startdatetime,enddatetime)'duration' from cte_raw --order --by startdatetime, enddatetime
)
insert into @tblevent
select * from cte_data order by startdatetime

--select top 10* from @tblevent order by enddatetime

--select count(*) from @tblevent where enddatetime <= '2025-04-13 21:03:00.000'

--select top 1 @eventdate = startdatetime from @tblevent order by startdatetime

--select @eventdate

--select @eventdate, count(*) from @tblevent where startdatetime = @eventdate

select @count = count(*) from @tblevent 

set @int = 0

while (@count > @int)
begin
select top 1 @eventdate = enddatetime from @tblevent order by enddatetime

insert into @tbleventSummary
select @eventdate, count(*) from @tblevent where enddatetime = @eventdate
set @int = @int + 1
delete @tblevent where enddatetime = @eventdate
end

 select MAX(concurrentrun) from @tbleventSummary 

 select * from @tbleventSummary order by concurrentrun desc




--select * from dbo.BPASession where sessionnumber = 755145
--select * from dbo.BPAStatus
--select top 2* from dbo.BPASession
--select * from dbo.BPAProcess
--select * from dbo.BPALicense
--select * from dbo.BPAResource order by name

--SELECT top 2
--sessionid,
--sessionnumber,
--startdatetime,
--enddatetime,
--FORMAT(ISNULL(enddatetime,@now),'yyyy-MM-dd HH:mm')'enddatetime1',
--DATEDIFF(MI,startdatetime,FORMAT(ISNULL(enddatetime,@now),'yyyy-MM-dd HH:mm')),
--lastupdatedtimezoneoffset
--FROM dbo.BPASession 
--WHERE FORMAT(ISNULL(startdatetime,@defaultDate),'yyyy-MM-dd HH:mm') = '2025-04-16 20:45'
--select GETDATE()

--select top 2* from dbo.BPASession order by startdatetime desc
--select GETDATE(),GETUTCDATE(),SYSUTCDATETIME(),SYSDATETIME()

--select top 1* from dbo.BPASessionLog_NonUnicode order by logid desc


--select GETDATE(), DATEPART(YEAR,getdate()),DATEPART(MM,getdate()),DATEPART(DAY,getdate()),DATEPART(HOUR,getdate()),DATEPART(HOUR,getdate())+3,DATEPART(MINUTE,getdate())
--select top 2 sessionnumber,
--startdatetime,
--enddatetime,
--DATEPART(YEAR,getdate()), DATEPART(MONTH,getdate()),DATEPART(HH,getdate()),DATEPART(HOUR,getdate())+3,DATEPART(MINUTE,getdate()),
--lastupdatedtimezoneoffset from dbo.BPASession order by startdatetime desc

--declare @year varchar(4),@month varchar(2), @day varchar(2),@hour varchar(2), @min varchar(2)
--select 
--@year = DATEPART(YEAR,getdate()), 
--@month = DATEPART(MONTH,getdate()),
--@day = DATEPART(DAY,getdate()),
--@hour = DATEPART(HOUR,getdate())+3,
--@min = DATEPART(MINUTE,getdate())

--select @year+'-'+@month+'-'+@day+' '+@hour+':'+@min


--select FORMAT(getdate(),'MM'),FORMAT(getdate(),'yyyy'),FORMAT(getdate(),'dd') ,FORMAT(getdate(),'HH'),FORMAT(getdate(),'mm') 
--select CONVERT(NVARCHAR(20),GETDATE(),24),DATEPART(HH,GETDATE()), CONVERT(NVARCHAR(20),GETDATE(),23)

--SELECT  DATEDIFF(dd, 0,GETDATE()) + CONVERT(DATETIME,'03:30:00.000')

--select dateadd(SECOND,10800,getdate()),GETDATE()



