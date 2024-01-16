SELECT DATEPART(YEAR,[eventdatetime])'Year',
sum(isnull(datalength([eventdatetime]),0)
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
      +isnull(datalength([newXML]),0))/1024/1024 'TotalSize'
  FROM [dbo].[BPAAuditEvents] 
  GROUP BY DATEPART(YEAR,[eventdatetime])
  ORDER BY Year