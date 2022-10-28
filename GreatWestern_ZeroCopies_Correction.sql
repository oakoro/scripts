/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [sessionnumber]
      ,[enddatetime]
      ,[rowNumber]
      ,[copyStatus]
      ,[createdTS]
  FROM [BPC].[aa_ControlTable_BPASessionLog_NonUnicode]
  where sessionnumber in 
  (select sessionnumber from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode] where recordCopied = 0) and rowNumber >= 200000
  order by sessionnumber--rowNumber desc
 -- select * from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode] where sessionnumber = 52262

  --update [BPC].[aa_ControlTable_BPASessionLog_NonUnicode]
  --set copyStatus = NULL, createdTS = NULL
  --where sessionnumber in
  --(select sessionnumber from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode] where recordCopied = 0)

  with cte_zerocopies
  as
  (
  select sessionnumber from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode] where recordCopied = 0
  )
  --select * from cte_zerocopies
  ,cte_check
  as
  (
  select sessionnumber,createdTS,recordCopied,recordRead from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode] 
  where sessionnumber in (select sessionnumber from cte_zerocopies)
  )
  --select * from cte_check
  --where count(sessionnumber) > 1
  --order by sessionnumber,createdTS desc
  ,
  cte_updated
  as
  (
  select sessionnumber, count(sessionnumber)'Record' from cte_check
  group by sessionnumber
  having count(sessionnumber) > 1
    )
	--select * from cte_updated
	,
	cte_refresh
	as
	(
	select sessionnumber,createdTS,recordCopied,recordRead,copyDuration from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode] 
 where sessionnumber in (select sessionnumber from cte_updated) 
	)
	select * from cte_refresh
	order by sessionnumber,createdTS desc