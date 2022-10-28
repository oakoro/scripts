select * from [bpc].[aatbl_ActivityLogs_BPASessionLog_NonUnicode]
where deletedTS is null --and recordCopied = 0
--where sessionnumber in (
--587,
--609,
--7804,
--7806,
--7802,
--7805,
--1576,
--1579,
--7803,
--1578,
--1471,
--1473,
--1472,
--7848,
--1577,
--1575,
--7847,
--7850,
--1470,
--1469,
--7849
--)

order by recordCopied 

--select * from [bpc].[aatbl_ActivityLogs_BPASessionLog_NonUnicode_MultiSessonNumCopy_20221003]
--where sessionnumber is not null 
--order by recordCopied desc

--update [bpc].[aatbl_ActivityLogs_BPASessionLog_NonUnicode]
--set deletedStatus = 'CompletedForced', deletedTS = getdate()
--where deletedTS is null and recordCopied = 0