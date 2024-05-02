SELECT datepart(YEAR,eventdatetime) 'Year', datepart(MONTH,eventdatetime) 'Month',
sum(
isnull(datalength([eventdatetime]),0) 
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
      +isnull(datalength([newXML]),0))/1024 'DataSize'
  FROM [dbo].[BPAAuditEvents] 
Group by datepart(YEAR,eventdatetime) ,datepart(MONTH,eventdatetime)
ORDER BY Year,Month

select
sum(
isnull(datalength([eventdatetime]),0) 
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
      +isnull(datalength([newXML]),0))/1024 'DataSize'
  FROM [dbo].[BPAAuditEvents]
  --579869
  --606216
  go
  sp_spaceused'[dbo].[BPAAuditEvents]'