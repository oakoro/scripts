
/*
	Step 1 - Populate the database name appropriately (Line 9)
	Step 2 - Populate the @UserName and @LockDateTime values inline with the values present in the UI. 
		     If certain values are not present, or if you want to delete all locks, leave the default values accordingly (Line 14 and 15)
	Step 3 - Run the first output and confirm the results match what you see in the UI
	Step 4 - Run the whole script, uncommenting line 55 and 87 if happy with the output of Step 3
*/


DECLARE 
	 @ProcessID		UNIQUEIDENTIFIER
	,@UserName		NVARCHAR(128) = N'mitch.baker'  -- N'UserName@MyCompany.com'
	,@LockDateTime	DATETIME	  = NULL --  '2022-06-09 14:59:07.497';

SELECT
	 BuR.username
	,BuR.userid
	,BpL.processid
    ,BpL.lockdatetime
    ,BpL.userid
    ,BpL.machinename
FROM
	BPAProcessLock BpL
JOIN
	BPAUser BuR
ON
	BpL.userid = BuR.userid
WHERE
	CASE WHEN @UserName <> N'' 
		THEN
			CASE WHEN BuR.username = @UserName
				THEN
					1
				ELSE
					0
			END
		ELSE
			1
	END = 1
AND
	CASE WHEN @LockDateTime IS NOT NULL
		THEN
			CASE WHEN BpL.lockdatetime = @LockDateTime
				THEN
					1
				ELSE
					0
			END
		ELSE
			1
	END = 1;


--DELETE BpL
--FROM
--	BPAProcessLock BpL
--JOIN
--	BPAUser BuR
--ON
--	BpL.userid = BuR.userid
--WHERE
--	CASE WHEN @UserName <> N'' 
--		THEN
--			CASE WHEN BuR.username = @UserName
--				THEN
--					1
--				ELSE
--					0
--			END
--		ELSE
--			1
--	END = 1
--AND
--	CASE WHEN @LockDateTime IS NOT NULL
--		THEN
--			CASE WHEN BpL.lockdatetime = @LockDateTime
--				THEN
--					1
--				ELSE
--					0
--			END
--		ELSE
--			1
--	END = 1;
