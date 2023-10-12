/*
Purpose						:	Reset Session status for running processes not responding to Request Stop commands
Written by					:	
Date Created				:	
Date Modified				:
Modified by					:
BluePrims Version supported	:	V5+, V6+

Warning						:	
*/

--select * from dbo.BPASession with (nolock)
--where sessionnumber in (
--204644,204643,204642,204645
--)

--select * from BPAStatus

--update dbo.BPASession
--set statusid = 3
--where sessionnumber in (
--204644,204643,204642,204645
--) and statusid =



 -- Set all 'Stopping' sessions to be 'Stopped' status
 -- Use this if the sessions are known to be no longer running
 --   update BPASession set statusid = 3 where statusid = 7; 

 ---- Set all 'Stopping' sessions to be 'Running' status
 ---- Use this if the sessions may still be running
 --   update BPASession set statusid = 1 where statusid = 7;

 --select * from BPASession s join BPAProcess p on s.processid = p.processid
--where p.name in ('NASA_API','Companies house KR') and statusid <> 3

-- select s.sessionnumber, p.name, st.description
-- from BPASession s join BPAProcess p on s.processid = p.processid
-- join BPAStatus st on st.statusid = s.statusid
--where --p.name in ('NASA_API','Companies house KR') and
--s.statusid not in (2,3,4)

--select * from BPAProcess where name in ('NASA_API','Companies house KR')

--select * from BPAStatus

--update s
--set s.statusid = 3
--from BPASession s join BPAProcess p on s.processid = p.processid
--where p.name in ('NASA_API','Companies house KR') and s.statusid = 5
	
	