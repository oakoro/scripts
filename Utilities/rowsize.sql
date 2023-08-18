
with cte_1
as
(
select  logid, 
isnull(datalength([logid]), 1)[logidSize] , 
isnull(datalength([sessionnumber]), 1) [sessionnumber], 
isnull(datalength([stageid]), 1) [stageid], 
isnull(datalength([stagename]), 1) [stagename], 
isnull(datalength([stagetype]), 1) [stagetype], 
isnull(datalength([processname]), 1)[processname] , 
isnull(datalength([pagename]), 1)[pagename] , 
isnull(datalength([objectname]), 1) [objectname], 
isnull(datalength([actionname]), 1) [actionname], 
isnull(datalength([result]), 1)[result] , 
isnull(datalength([resulttype]), 1) [resulttype], 
isnull(datalength([startdatetime]), 1)[startdatetime] , 
isnull(datalength([enddatetime]), 1) [enddatetime], 
isnull(datalength([attributexml]), 1) [attributexml], 
isnull(datalength([automateworkingset]), 1) [automateworkingset], 
isnull(datalength([targetappname]), 1) [targetappname], 
isnull(datalength([targetappworkingset]), 1)[targetappworkingset] , 
isnull(datalength([starttimezoneoffset]), 1)[starttimezoneoffset] , 
isnull(datalength([endtimezoneoffset]), 1)[endtimezoneoffset] , 
isnull(datalength([attributesize]), 1)[attributesize] from BPASessionLog_NonUnicode
),
cte_2
as
(
select logid , (0 + isnull(datalength([logid]), 1) + isnull(datalength([sessionnumber]), 1) + isnull(datalength([stageid]), 1) + isnull(datalength([stagename]), 1) + isnull(datalength([stagetype]), 1) + isnull(datalength([processname]), 1) + isnull(datalength([pagename]), 1) + isnull(datalength([objectname]), 1) + isnull(datalength([actionname]), 1) + isnull(datalength([result]), 1) + isnull(datalength([resulttype]), 1) + isnull(datalength([startdatetime]), 1) + isnull(datalength([enddatetime]), 1) + isnull(datalength([attributexml]), 1) + isnull(datalength([automateworkingset]), 1) + isnull(datalength([targetappname]), 1) + isnull(datalength([targetappworkingset]), 1) + isnull(datalength([starttimezoneoffset]), 1) + isnull(datalength([endtimezoneoffset]), 1) + isnull(datalength([attributesize]), 1)) as rowsize from BPASessionLog_NonUnicode         
)
select cte_1.*,cte_2.rowsize
from cte_1 join cte_2 on cte_1.logid = cte_2.logid
order by cte_2.rowsize desc