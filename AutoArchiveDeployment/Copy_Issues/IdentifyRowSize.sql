declare @sumDataSize bigint = (
select sum( 
isnull(datalength([result]), 1)+isnull(datalength([attributexml]), 1) )
 from BPASessionLog_NonUnicode with (nolock)
where logid between 23377848 and 28377848)

select @sumDataSize

--select count(*) from BPASessionLog_NonUnicode with (nolock)
--where logid between 23377848 and 28377848--101.001 ,4836363


--select  sum(
--isnull(datalength([logid]), 1) + 
--isnull(datalength([sessionnumber]), 1) + 
--isnull(datalength([stageid]), 1) + 
--isnull(datalength([stagename]), 1)+ 
--isnull(datalength([stagetype]), 1) + 
--isnull(datalength([processname]), 1) + 
--isnull(datalength([pagename]), 1) + 
--isnull(datalength([objectname]), 1) + 
--isnull(datalength([actionname]), 1) + 
--isnull(datalength([result]), 1) + 
--isnull(datalength([resulttype]), 1) + 
--isnull(datalength([startdatetime]), 1) + 
--isnull(datalength([enddatetime]), 1) + 
--isnull(datalength([attributexml]), 1) + 
--isnull(datalength([automateworkingset]), 1) + 
--isnull(datalength([targetappname]), 1) + 
--isnull(datalength([targetappworkingset]), 1) + 
--isnull(datalength([starttimezoneoffset]), 1)+ 
--isnull(datalength([endtimezoneoffset]), 1) + 
--isnull(datalength([attributesize]), 1) ) from BPASessionLog_NonUnicode with (nolock)
--where logid between 7549560 and 7551560
;
--with cte_10
--as
--(
--select logid,sum(
--isnull(datalength([result]), 1)+isnull(datalength([attributexml]), 1) ) Total
-- from BPASessionLog_NonUnicode with (nolock)
--where logid between 7549560 and 7551560
--group by logid
--)
--select sum(Total) from cte_10

--with cte_12
--as
--(
--select logid, sum(
--isnull(datalength([logid]), 1) + 
--isnull(datalength([sessionnumber]), 1) + 
--isnull(datalength([stageid]), 1) + 
--isnull(datalength([stagename]), 1)+ 
--isnull(datalength([stagetype]), 1) + 
--isnull(datalength([processname]), 1) + 
--isnull(datalength([pagename]), 1) + 
--isnull(datalength([objectname]), 1) + 
--isnull(datalength([actionname]), 1) + 
--isnull(datalength([result]), 1) + 
--isnull(datalength([resulttype]), 1) + 
--isnull(datalength([startdatetime]), 1) + 
--isnull(datalength([enddatetime]), 1) + 
--isnull(datalength([attributexml]), 1) + 
--isnull(datalength([automateworkingset]), 1) + 
--isnull(datalength([targetappname]), 1) + 
--isnull(datalength([targetappworkingset]), 1) + 
--isnull(datalength([starttimezoneoffset]), 1)+ 
--isnull(datalength([endtimezoneoffset]), 1) + 
--isnull(datalength([attributesize]), 1) ) Total from BPASessionLog_NonUnicode with (nolock)
--where logid between 23377848 and 28377848
--group by logid
--)
--select sum(Total) from cte_12