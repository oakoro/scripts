DECLARE @DaysToKeep INT = 180

-----------------
DECLARE @Threshold DATETIME = DATEADD(DAY,-@DaysToKeep,GETDATE())

select @Threshold

SELECT COUNT(*)'DeleteCount' FROM BPAAuditEvents
WHERE eventdatetime < @Threshold

SELECT COUNT(*)'RetainedCount' FROM BPAAuditEvents
WHERE eventdatetime > @Threshold

SELECT  MIN(eventdatetime) FROM BPAAuditEvents

SELECT sum(isnull(datalength([eventdatetime]),0)
      +isnull(datalength([eventid]),0)
      +isnull(datalength([sCode]),0)
      +isnull(datalength([sNarrative]),0)
      +isnull(datalength([gSrcUserID]),0)
      +isnull(datalength([gTgtUserID]),0)
      +isnull(datalength([gTgtProcID]),0)
      +isnull(datalength([gTgtResourceID]),0)
      +isnull(datalength([comments]),0)
      +isnull(datalength([EditSummary]),0)
      +isnull(datalength([oldXML]),0)
      +isnull(datalength([newXML]),0)) 'TotalSize'
  FROM [dbo].[BPAAuditEvents] 

SELECT sum(isnull(datalength([eventdatetime]),0)
      +isnull(datalength([eventid]),0)
      +isnull(datalength([sCode]),0)
      +isnull(datalength([sNarrative]),0)
      +isnull(datalength([gSrcUserID]),0)
      +isnull(datalength([gTgtUserID]),0)
      +isnull(datalength([gTgtProcID]),0)
      +isnull(datalength([gTgtResourceID]),0)
      +isnull(datalength([comments]),0)
      +isnull(datalength([EditSummary]),0)
      +isnull(datalength([oldXML]),0)
      +isnull(datalength([newXML]),0)) 'DeletedSize'
  FROM [dbo].[BPAAuditEvents] 
  WHERE eventdatetime < @Threshold

  SELECT sum(isnull(datalength([eventdatetime]),0)
      +isnull(datalength([eventid]),0)
      +isnull(datalength([sCode]),0)
      +isnull(datalength([sNarrative]),0)
      +isnull(datalength([gSrcUserID]),0)
      +isnull(datalength([gTgtUserID]),0)
      +isnull(datalength([gTgtProcID]),0)
      +isnull(datalength([gTgtResourceID]),0)
      +isnull(datalength([comments]),0)
      +isnull(datalength([EditSummary]),0)
      +isnull(datalength([oldXML]),0)
      +isnull(datalength([newXML]),0)) 'RetainedSize'
  FROM [dbo].[BPAAuditEvents] 
  WHERE eventdatetime > @Threshold

--22529635710
--12578364996
--9951270714

