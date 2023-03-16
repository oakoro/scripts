with cte
as
(
select s.sessionnumber, s.startdatetime,count(*)'RecordCount' from [dbo].[BPASessionLog_NonUnicode] sl join dbo.BPASession s on sl.sessionnumber = s.sessionnumber
group by s.sessionnumber,s.startdatetime
--order by --RecordCount desc--
--s.startdatetime
)
--select --datepart(year,startdatetime)'Year',
--datepart(MONTH,startdatetime)'Month',datepart(year,startdatetime)'Year',
--sum(RecordCount)'RecordCount' from cte 
--where startdatetime > '2021-11-24 13:36:06.710'
--group by datepart(MONTH,startdatetime), datepart(YEAR,startdatetime) 
--order by datepart(YEAR,startdatetime) 
--select --*
--sum(RecordCount) 
--from cte  where startdatetime between '2021-11-24 13:36:06.710' and '2021-11-25 19:36:06.710'
--order by startdatetime
select * from [dbo].[BPASessionLog_NonUnicode] where sessionnumber in
(select sessionnumber from cte where startdatetime between '2021-11-24 13:36:06.710' and '2021-11-25 19:36:06.710')
and logid > 30326388

--select count(*) from BPASessionLog_NonUnicode_PartitionTest
--select max(logid) from BPASessionLog_NonUnicode_PartitionTest
--truncate table BPASessionLog_NonUnicode_PartitionTest

--DROP INDEX [aaix_vwSessionnumber] ON [BPC].[aavw_ControlTableUpdate]
--GO
--2021-11-25 23:36:06.710