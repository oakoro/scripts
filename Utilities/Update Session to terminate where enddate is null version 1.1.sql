/*
	Orginal Author: David Dinh
					Sept 2, 2021

	DISCLAIMER: This is only to be run by a qualified DBA or SQL Developer.  If you need assistance, please log a trouble ticket.  It is recommended that you back 
		up your database before implementing.

-- =========================================================================================================================================
	Desc: Use this SQL to add an enddatetime and a terminate status to sessions that terminated unexpectedly by Blue Prism (crash or otherwise).  This will close the the loop so that 
		BP does not take up a license unnecessarily.  This is intended for old lingering sessions.

		Please note, you should not terminate a process that is currently running.  If you do, it will be reflected in the IC as such, but will still be running on the RR.

		REFERENCE SESSION STATUS
		0	Pending
		1	Running
		2	Terminated
		3	Stopped
		4	Completed
		5	Debugging
		6	Archived
		7	Stopping
		8	Warning

-- These are the records that will be updated.  An enddatetime which is NULL will be updated to startdatetime + 1 day (24 hours)
--    and records older than [@DaysFromCurrentDay] days from current date.

-- To select which records will be updated, highlight and run the commented code below.  Make sure @DaysFromCurrentDay as the same value as 
--	 outside script.

					DECLARE	@DaysFromCurrentDay INT = 30; -- Number of days to update from current date

					DECLARE @BenchMarkDate DATETIME = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -@DaysFromCurrentDay)	

					select 
					      [sessionnumber]
						  ,[startdatetime]
						  ,[enddatetime]
						  ,[statusid]
						  ,[lastupdated]
					from BPASession
					WHERE
						enddatetime is null
						and statusid in (0, 1, 7, 8)
						and 
						(
							startdatetime < @BenchMarkDate
						)
*/
-- =========================================================================================================================================


-- The query below is the UPDATE query.  This is the query that will actually do the update.  If you want to see what will be updated first,
--	Run the select in the block above.

-- *****************************************************************************************************************************************
-- CHANGE ME CHANGE ME !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- Number of days to update from current date.  Foe example, if you want to terminate anything older that 30 days, put 30 here, and it will
--	  delete records 31, 32...days ago.
-- *****************************************************************************************************************************************
DECLARE	@DaysFromCurrentDay INT = 30; 
-- *****************************************************************************************************************************************


DECLARE @BenchMarkDate DATETIME = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -@DaysFromCurrentDay) 

UPDATE BPASession
	   SET enddatetime = startdatetime + 1,
	   statusid = 2
WHERE 
		enddatetime is null
		and statusid in (0, 1, 7, 8)
		and 
		(
			startdatetime < @BenchMarkDate
		)



