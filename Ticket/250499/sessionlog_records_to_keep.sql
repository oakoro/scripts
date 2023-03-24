select logid,startdatetime from BPASessionLog_NonUnicode with (nolock)
where sessionnumber = 21368
order by logid 

select count(*) from BPASessionLog_NonUnicode with (nolock)
where logid > 62661789 --2433998 rows