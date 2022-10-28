 DECLARE @daystokeep INT = 30
 declare @threshold datetime;

    set @threshold = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -@daystokeep);

if object_id('tempdb..#sessions') is not null

    drop table #sessions
	 CREATE TABLE #sessions (sessno INT PRIMARY KEY )

	insert into #sessions(sessno)
	select sessionnumber from BPASession 
	where startdatetime is null
	          or enddatetime is null
			  or DATEADD(SECOND,-ISNULL(starttimezoneoffset,0),startdatetime) >= @threshold;

alter table  
   dbo.BPASessionLog_NonUnicode switch to dbo.[BPASessionLog_NonUnicodeOATest]

 
 insert BPASessionLog_NonUnicode
 select l.* from [BPASessionLog_NonUnicodeOATest] l  join #sessions s on l.sessionnumber = s.sessno; 





	