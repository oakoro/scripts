 DECLARE @CopySessionLogTable NVARCHAR(30),
		@loggingTable NVARCHAR(30),
		@loggingType BIT,
		@switchSessionLogBack NVARCHAR(MAX)

SELECT @loggingType = unicodeLogging FROM BPASysConfig
--SET @LoggingType = 1 --Test for Unicode
IF @loggingType = 0

BEGIN
SET @loggingTable = 'BPASessionLog_NonUnicode'
SET @CopySessionLogTable = 'BPASessionLog_NonUnicodeCopy'
END
ELSE
BEGIN
SET @loggingTable = 'BPASessionLog_Unicode'
SET @CopySessionLogTable = 'BPASessionLog_UnicodeCopy'
END

SET @switchSessionLogBack = 'ALTER TABLE DBO.'+QUOTENAME(@CopySessionLogTable) + ' SWITCH TO DBO.'+QUOTENAME(@loggingTable) +' PARTITION 1;'
PRINT @switchSessionLogBack
--EXEC (@switchSessionLogBack)