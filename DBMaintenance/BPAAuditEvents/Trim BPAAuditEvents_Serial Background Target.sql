DECLARE @DaysToKeep INT = 180
DECLARE @Threshold DATETIME = DATEADD(DAY,-@DaysToKeep,GETDATE())
DECLARE @delTable TABLE (eventid INT)
DECLARE @count INT, @eventid INT, @msg VARCHAR(MAX)

INSERT @delTable
SELECT eventid FROM [dbo].[BPAAuditEvents]
WHERE [eventdatetime] < @Threshold

SELECT @count = COUNT(*) FROM @delTable
SET @msg = 'Record count before delete = '+ CONVERT(VARCHAR(20),@count)
RAISERROR(@msg,0,0)

WHILE (SELECT COUNT(*) FROM @delTable) > 0
  BEGIN
  SELECT TOP 1 @eventid = eventid FROM @delTable
  DELETE [dbo].[BPAAuditEvents] WHERE eventid = @eventid
  PRINT CONVERT(VARCHAR(10),@eventid)+' deleted'
  DELETE @delTable WHERE eventid = @eventid
 END
SELECT @count = COUNT(*) FROM @delTable
SET @msg = 'Record count after delete = '+ CONVERT(VARCHAR(20),@count)
RAISERROR(@msg,0,0)


