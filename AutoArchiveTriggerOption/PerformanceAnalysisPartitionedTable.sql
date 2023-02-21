--ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE
set statistics io,time on
--select top 20* from [dbo].[BPASessionLog_NonUnicode]
--where logid = 4875468
select * from [dbo].[BPASessionLog_NonUnicode] where sessionnumber = 588
 
set statistics io,time off

/*
select COUNT(*) from [dbo].[BPASessionLog_NonUnicode]
Parttioned
Scan count 8, logical reads 72432, physical reads 0
CPU time = 1218 ms,  elapsed time = 3958 ms.
Unpartitioned
Scan count 1, logical reads 116578, physical reads 0
CPU time = 1234 ms,  elapsed time = 4197 ms.

select top 20* from [dbo].[BPASessionLog_NonUnicode] --with (nolock)
where sessionnumber in (select sessionnumber from dbo.BPASession)
Parttioned
Scan count 2, logical reads 6, physical reads 0
 CPU time = 0 ms,  elapsed time = 0 ms.
Unpartitioned
Scan count 1, logical reads 9, physical reads 0
  CPU time = 0 ms,  elapsed time = 0 ms

  select sessionnumber, COUNT(*) from [dbo].[BPASessionLog_NonUnicode]
group by sessionnumber
Parttioned
Scan count 8, logical reads 72438, physical reads 0
CPU time = 2015 ms,  elapsed time = 5268 ms.

Unpartitioned
Scan count 1, logical reads 116577
CPU time = 3359 ms,  elapsed time = 9736 ms.

select * from [dbo].[BPASessionLog_NonUnicode] where sessionnumber = 69
Parttioned
Scan count 8, logical reads 35644, physical reads 0
CPU time = 32 ms,  elapsed time = 41 ms.
Unpartitioned
Scan count 1, logical reads 47264, physical reads 0
CPU time = 47 ms,  elapsed time = 34 ms.

select * from [dbo].[BPASessionLog_NonUnicode] where sessionnumber = 87
Parttioned
Scan count 8, logical reads 344882, physical reads 283
CPU time = 375 ms,  elapsed time = 25611 ms.
Unpartitioned
Scan count 1, logical reads 457271, physical reads 373
CPU time = 406 ms,  elapsed time = 48604 ms.

select * from [dbo].[BPASessionLog_NonUnicode] where sessionnumber = 581
Partitioned
Scan count 8, logical reads 559351, physical reads 0
CPU time = 485 ms,  elapsed time = 5389 ms.

UnPartitioned
Scan count 1, logical reads 961835, physical reads 840
CPU time = 344 ms,  elapsed time = 27243 ms.

select * from [dbo].[BPASessionLog_NonUnicode] where sessionnumber = 588
Parttioned
Scan count 8, logical reads 1097852, physical reads 25
CPU time = 8406 ms,  elapsed time = 308245 ms
UnPartitioned
Scan count 1, logical reads 1477510, physical reads 601
CPU time = 1468 ms,  elapsed time = 1043677 ms.

934702
934703
934704
934705
934706
934707

*/

--SELECT logid FROM BPASessionLog_NonUnicode
--ORDER BY RAND()

