select sessionnumber, count(*) as 'RecordCount' from [dbo].[BPASessionLog_NonUnicode] with (nolock)
--where sessionnumber in (select sessionnumber from OkeTriggerTableTest where [status] is null)
group by sessionnumber
ORDER BY RecordCount
--update OkeTriggerTableTest
--set status = Null