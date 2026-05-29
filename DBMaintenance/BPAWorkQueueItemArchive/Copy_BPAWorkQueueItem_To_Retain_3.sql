-- Variables
DECLARE @BatchSize INT = 50000;
declare @t table (tblrc bigint)
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
    --ORDER BY s.ident;
--PRINT CONCAT('Rows copied1: ', @@ROWCOUNT)
insert @t
	SELECT @@ROWCOUNT;

set @int = (select tblrc from @t) + @int

SELECT @int 'INT',@@ROWCOUNT'@@ROWCOUNT'
    --SET @RowsAffected = @@ROWCOUNT;
delete @t
    PRINT CONCAT('Rows copied2: ', @int);

--IF @@ROWCOUNT = @int
--	BEGIN
--	BREAK;
--	END
set identity_insert [dbo].[BPAWorkQueueItemCopy] off
end

--select count(*) from [dbo].[BPAWorkQueueItemCopy]
--truncate table [dbo].[BPAWorkQueueItemCopy]

--ALTER TABLE [dbo].[BPAWorkQueueItemCopy]
--ADD [sla] [bigint] NULL, [sladatetime] [datetime] NULL, [processname] [nvarchar](255) NULL ,
--	[issuggested] [bit] NULL ;

--drop table [dbo].[BPAWorkQueueItemCopy]
