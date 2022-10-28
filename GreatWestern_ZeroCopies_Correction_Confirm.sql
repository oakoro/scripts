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
  ,cte_check_StillMissing
  as
  (
  select distinct sessionnumber, max(recordRead)'recordRead' from cte_check
  group by sessionnumber
  )
  select * from cte_check_StillMissing where recordRead = 0