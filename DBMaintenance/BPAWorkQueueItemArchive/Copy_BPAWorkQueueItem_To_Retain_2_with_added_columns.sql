-- Variables
DECLARE @BatchSize INT = 20000;
DECLARE @RowsAffected INT = (select count(*) from [dbo].[BPAWorkQueueItemRestore]);
Declare @int INT = 0
while (@int < @RowsAffected)
begin
set identity_insert [dbo].[BPAWorkQueueItemCopy] on
INSERT INTO [dbo].[BPAWorkQueueItemCopy]
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
           ,[lockid]
		   ,[sla] 
		   ,[sladatetime]
		   ,[processname]
		   ,[issuggested]
		   )
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
	  ,[sla] 
	  ,[sladatetime]
	  ,[processname]
	  ,[issuggested]
  FROM [dbo].[BPAWorkQueueItemRestore] s
 WHERE NOT EXISTS
    (
        SELECT 1
        FROM [dbo].[BPAWorkQueueItemCopy] t
        WHERE t.ident = s.ident
    )
    ORDER BY s.ident;
set identity_insert [dbo].[BPAWorkQueueItemCopy] off

set @int = @int + @@ROWCOUNT

    --SET @RowsAffected = @@ROWCOUNT;

    PRINT CONCAT('Rows copied: ', @RowsAffected);

IF @@ROWCOUNT = 0
	BEGIN
	BREAK;
	END

end

--select * from [dbo].[BPAWorkQueueItemCopy]

--ALTER TABLE [dbo].[BPAWorkQueueItemCopy]
--ADD [sladatetime] [datetime] NULL, [processname] [nvarchar](255) NULL ,
--	[issuggested] [bit] NULL, [sla] [bigint] NULL;
