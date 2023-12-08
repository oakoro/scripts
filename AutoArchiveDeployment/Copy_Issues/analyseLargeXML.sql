with cte_1
as
(
select  logid, 
isnull(datalength([result]), 1)[result] , 
isnull(datalength([attributexml]), 1) [attributexml]
 from BPASessionLog_NonUnicode with (nolock)
where sessionnumber in (
select sessionnumber from dbo.BPASession with (nolock) 
where startdatetime > GETDATE() - 30 )
)
select * from cte_1 where (result > 1000 or attributexml > 1000)