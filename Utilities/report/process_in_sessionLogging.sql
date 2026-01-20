with cte_1
AS
(

SELECT  processname
        ,DATALENGTH([logid]) [logid]
      ,DATALENGTH([sessionnumber]) [sessionnumber]
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
  FROM [dbo].[BPASessionLog_NonUnicode]
  where logid > 8994895
),
cte_2
AS
(
select
  processname, 
    ( [logid]
      +[sessionnumber]
      +[stageid]
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
      +[attributesize]
    ) Size
  FROM cte_1
)
select processname, sum(size) Size from cte_2
where processname is NOT NULL
group by processname
order by [Size]






