select count(*) from dbo.BPAAuditEvents with (nolock)
go
SELECT isnull(datalength([eventdatetime]),0)'eventdatetime'
      ,isnull(datalength([eventid]),0)'eventid'
      ,isnull(datalength([sCode]),0)'sCode'
      ,isnull(datalength([sNarrative]),0)'sNarrative'
      ,isnull(datalength([gSrcUserID]),0)'gSrcUserID'
      ,isnull(datalength([gTgtUserID]),0)'gTgtUserID'
      ,isnull(datalength([gTgtProcID]),0)'gTgtProcID'
      ,isnull(datalength([gTgtResourceID]),0)'gTgtResourceID'
      ,isnull(datalength([comments]),0)'comments'
      ,isnull(datalength([EditSummary]),0)'EditSummary'
      ,isnull(datalength([oldXML]),0)'oldXML'
      ,isnull(datalength([newXML]),0)'newXML'
  FROM [dbo].[BPAAuditEvents]