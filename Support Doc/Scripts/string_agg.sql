--select * from [bpc].[aa_ControlTable_BPASession_Old]

declare @arr varchar(max),@string nvarchar(max)
SELECT @arr = STRING_AGG (sessionnumber,',')
FROM [bpc].[aa_ControlTable_BPASession_Old]
where sessionenddate = '2020-06-04'

--select @arr

set @string = '
select * from [bpc].[aa_ControlTable_BPASession_Old]
where sessionnumber in ('+@arr+')'
print @string

exec sp_executesql @string


select top 2 string_agg (sessionnumber,',') from 
bpc.SmallSessionnumber_oketest

declare @sessionno varchar(800)
select @sessionno = string_agg (sessionnumber,',') from 
bpc.SmallSessionnumber_oketest
select @sessionno
 --select count(*) from bpc.SmallSessionnumber_oketest

 select string_agg (sessionnumber,',') as test from 
bpc.SmallSessionnumber_oketest


