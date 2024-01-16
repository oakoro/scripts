SELECT DATEPART(YEAR,[eventdatetime])'Year',DATEPART(QUARTER,[eventdatetime])'Quarter',DATEPART(MONTH,[eventdatetime])'MONTH',
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
      +isnull(datalength([newXML]),0))/1024/1024 'TotalSize',
	  count(*) 'TotalCount'
  FROM [dbo].[BPAAuditEvents] with (nolock)
  GROUP BY DATEPART(YEAR,[eventdatetime]),DATEPART(QUARTER,[eventdatetime]),DATEPART(MONTH,[eventdatetime])
  ORDER BY Year,Quarter,MONTH


  --select * FROM [dbo].[BPAAuditEvents] with (nolock)
  --where  DATEPART(YEAR,[eventdatetime]) = '2023' and DATEPART(MONTH,[eventdatetime]) = '8'

