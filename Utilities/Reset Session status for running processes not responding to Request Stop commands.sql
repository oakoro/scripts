/*
Purpose						:	Reset Session status for running processes not responding to Request Stop commands
Written by					:	
Date Created				:	
Date Modified				:
Modified by					:
BluePrims Version supported	:	V5+, V6+

Warning						:	
*/



 -- Set all 'Stopping' sessions to be 'Stopped' status
 -- Use this if the sessions are known to be no longer running
    update BPASession set statusid = 3 where statusid = 7; 

 -- Set all 'Stopping' sessions to be 'Running' status
 -- Use this if the sessions may still be running
    update BPASession set statusid = 1 where statusid = 7;
	
	