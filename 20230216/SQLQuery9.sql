sp_who2 active

select top 1 logid,sessionnumber,startdatetime from [dbo].[BPASessionLog_NonUnicodeRetain] with (nolock)
order by logid desc --868832860  848393371  848393371

--select top 1*  from [dbo].[BPASessionLog_NonUnicode] with (nolock)
--order by logid desc --868832860

select * from sys.dm_exec_requests where session_id > 50 and status not in ('background','sleeping')


--dbcc inputbuffer(129)--856788994

--17:13 
--17:23
--852150107
--select *  from [dbo].[BPASessionLog_NonUnicode] with (nolock)
--where logid > 852150107

--select 868832860 - 858152144
--select 858152144 - 848393371
