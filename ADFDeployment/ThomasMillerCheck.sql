select * from [BPC].[aa_ControlTable_BPASessionLog_NonUnicode]
where 
 sessionnumber in (
14769,
14774,
14780,
14760,
14784,
14788,
15899,
15897,
15905,
15908,
16141,
16145,
16144,
16149,
16155,
16158,
16161,
16164,
16165,
16167,
16262,
16266,
16265,
16272,
16270,
16346,
16354,
16357,
16362,
16365,
16353,
16352,
16369,
16370,
16371,
16491,
16498,
16494,
16499,
16500,
16503,
16504,
16506,
16507,
16511)
order by createdTS desc 


--update [BPC].[aa_ControlTable_BPASessionLog_NonUnicode]
--set copyStatus = 'Failed', createdTS = getdate()
--where  sessionnumber in (16262,
--16270,
--16266,
--16141,
--15897
--)

/*
16262
16270
16266
16141
15897
*/
/*
16643
16632
16641
16645
16635
16648
16640
16637
16636
16634
*/
--select * from [BPC].[aa_SessionNumLessThan200KCache_BPASessionLog_NonUnicode] with (nolock)

--SELECT TOP (25) [sessionnumber] ,[rowNumber]
--FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] 
--WHERE copyStatus IS NULL
--AND [rowNumber] < 200000
--ORDER BY [enddatetime] 

--select * from [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode]
--order by createdTS desc

sp_who2

select * from sys.dm_exec_requests
where status  not in ('background','sleeping')

kill 84