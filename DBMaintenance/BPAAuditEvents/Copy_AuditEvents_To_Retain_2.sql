DECLARE @BatchSize INT = 20000
DECLARE @RowsAffected INT = (SELECT COUNT(*) FROM [dbo].[BPAAuditEventsRestore])
DECLARE @int INT = 0
SELECT @RowsAffected
WHILE (@int < @RowsAffected)
BEGIN 
SET IDENTITY_INSERT [dbo].[BPAAuditEventsCopy] ON
INSERT INTO [dbo].[BPAAuditEventsCopy]
           ([eventdatetime]
		   ,[eventid]
           ,[sCode]
           ,[sNarrative]
           ,[gSrcUserID]
           ,[gTgtUserID]
           ,[gTgtProcID]
           ,[gTgtResourceID]
           ,[comments]
           ,[EditSummary]
           ,[oldXML]
           ,[newXML])
SELECT TOP (@BatchSize) 
		[eventdatetime]
      ,[eventid]
      ,[sCode]
      ,[sNarrative]
      ,[gSrcUserID]
      ,[gTgtUserID]
      ,[gTgtProcID]
      ,[gTgtResourceID]
      ,[comments]
      ,[EditSummary]
      ,[oldXML]
      ,[newXML]
  FROM [dbo].[BPAAuditEventsRestore] s
  WHERE NOT EXISTS 
  (
  SELECT 1 FROM [dbo].[BPAAuditEventsCopy] d
  WHERE s.eventid = d.eventid
  )
  ORDER BY s.eventid

SET @int = @int + @@ROWCOUNT

IF @@ROWCOUNT = 0
	BEGIN
		BREAK
	END

PRINT CONCAT('Rows copied: ', @RowsAffected);

SET IDENTITY_INSERT [dbo].[BPAAuditEventsCopy] OFF

END


