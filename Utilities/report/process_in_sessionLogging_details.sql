with cte_sl
as
(
SELECT  [logid]
      , [sessionnumber]
      ,ISNULL(DATALENGTH([stageid]),0) [stageid]
      ,ISNULL(DATALENGTH([stagename]),0) [stagename]
      ,ISNULL(DATALENGTH([stagetype]),0) [stagetype]
      ,ISNULL(DATALENGTH([processname]),0) [processname_data]
      ,ISNULL(DATALENGTH([pagename]),0) [pagename]
      ,ISNULL(DATALENGTH([objectname]),0) [objectname]
      ,ISNULL(DATALENGTH([actionname]),0) [actionname]
      ,ISNULL(DATALENGTH([result]),0) [result]
      ,ISNULL(DATALENGTH([resulttype]),0) [resulttype]
      ,ISNULL(DATALENGTH([startdatetime]),0) [startdatetime]
      ,ISNULL(DATALENGTH([enddatetime]),0) [enddatetime]
      ,ISNULL(DATALENGTH([attributexml]),0) [attributexml]
      ,ISNULL(DATALENGTH([automateworkingset]),0) [automateworkingset]
      ,ISNULL(DATALENGTH([targetappname]),0) [targetappname]
      ,ISNULL(DATALENGTH([targetappworkingset]),0) [targetappworkingset]
      ,ISNULL(DATALENGTH([starttimezoneoffset]),0) [starttimezoneoffset]
      ,ISNULL(DATALENGTH([endtimezoneoffset]),0) [endtimezoneoffset]
      ,DATALENGTH([attributesize]) [attributesize]
  FROM [dbo].[BPASessionLog_NonUnicode] with (nolock)
  where logid > 8994895
  ),
cte_s
as
(select sessionnumber, p.name
from dbo.BPASession s with (nolock) join dbo.BPAProcess p with (nolock) on s.processid = p.processid
)
,
cte_combine
as
(
SELECT b.name
		,[stageid]
      ,[stagename]
      ,[stagetype]
      ,[processname_data]
      ,[pagename]
      ,[objectname]
      ,[actionname]
      ,[result]
      ,[resulttype]
      ,[startdatetime]
      ,[enddatetime]
      ,[attributexml]
      ,[automateworkingset]
      ,[targetappname]
      ,[targetappworkingset]
      ,[starttimezoneoffset]
      ,[endtimezoneoffset]
      ,[attributesize]
  FROM cte_sl a join cte_s b on a.sessionnumber = b.sessionnumber
  ),
  cte_size
  as
  (
  select 
  name,
  ([stageid]
      +[stagename]
      +[stagetype]
      +[processname_data]
      +[pagename]
      +[objectname]
      +[actionname]
      +[result]
      +[resulttype]
      +[startdatetime]
      +[enddatetime]
      +[attributexml]
      +[automateworkingset]
      +[targetappname]
      +[targetappworkingset]
      +[starttimezoneoffset]
      +[endtimezoneoffset]
      +[attributesize]) Size
  from
  cte_combine
  )
  select name, SUM(size) Size
  from cte_size
  group by name
  order by Size