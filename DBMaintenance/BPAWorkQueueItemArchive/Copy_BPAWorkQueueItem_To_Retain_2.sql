-- Variables
DECLARE @BatchSize INT = 10000;
DECLARE @RowsAffected INT = (select count(*) from [dbo].[BPAWorkQueueItemRestore]);
Declare @int INT = 0
while (@int < @RowsAffected)
begin
set identity_insert [dbo].[BPAWorkQueueItemRetain] on
INSERT INTO [dbo].[BPAWorkQueueItemRetain]
           ([id]
           ,[queueid]
           ,[keyvalue]
           ,[status]
           ,[attempt]
           ,[loaded]
           ,[completed]
           ,[exception]
           ,[exceptionreason]
           ,[deferred]
           ,[worktime]
           ,[data]
           ,[queueident]
			,[ident]
           ,[sessionid]
           ,[priority]
           ,[prevworktime]
           ,[encryptid]
           ,[locktime]
           ,[lockid])
SELECT top (@BatchSize) [id]
      ,[queueid]
      ,[keyvalue]
      ,[status]
      ,[attempt]
      ,[loaded]
      ,[completed]
      ,[exception]
      ,[exceptionreason]
      ,[deferred]
      ,[worktime]
      ,[data]
      ,[queueident]
      ,[ident]
      ,[sessionid]
      ,[priority]
      ,[prevworktime]
      --,[attemptworktime]
      --,[finished]
      --,[exceptionreasonvarchar]
      --,[exceptionreasontag]
      ,[encryptid]
      --,[lastupdated]
      ,[locktime]
      ,[lockid]
  FROM [dbo].[BPAWorkQueueItemRestore] s
 WHERE NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[BPAWorkQueueItemRetain] t
        WHERE t.ident = s.ident
    )
    ORDER BY s.ident;
set identity_insert [dbo].[BPAWorkQueueItemRetain] off

set @int = @int + @@ROWCOUNT

    --SET @RowsAffected = @@ROWCOUNT;

    PRINT CONCAT('Rows copied: ', @RowsAffected);

IF @@ROWCOUNT > 0
	BEGIN
	BREAK;
	END

end

