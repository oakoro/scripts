/*** Declare Variables ***/
DECLARE 
@TotSessionsCopied bigint  = (SELECT COUNT([sessionnumber]) as 'Total_Sessionnumbers_Copied' FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] WITH (NOLOCK) WHERE [copyStatus] = 'COMPLETED'), 
@TotSessions bigint = (SELECT COUNT([sessionnumber]) as 'Total_Sessionnumbers_Counted' FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] WITH (NOLOCK) ),
@PercentageSessionsCopied decimal(5,2),
@TotCpyTime int = (SELECT  SUM(copyDuration) as 'Total_Copy_Duration (Seconds)' FROM [bpc].[aa_ActivityLogs_BPASessionLog_NonUnicode] WITH (NOLOCK) WHERE [executionStatus] IN ('Succeeded','Pass')),
@TotalRowsCopied bigint = (SELECT SUM([rowNumber]) as 'Total_Rows_Copied' FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] WITH (NOLOCK) WHERE [copyStatus] = 'COMPLETED'),
@TotalRows bigint = (SELECT SUM([rowNumber]) FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] WITH (NOLOCK)),
@PercentageRowsCopied decimal(5,2),
@MinCpyTime int = (SELECT  MIN(copyDuration) FROM [bpc].[aa_ActivityLogs_BPASessionLog_NonUnicode] WITH (NOLOCK) WHERE [executionStatus] IN ('Succeeded','Pass')),
@MaxCpyTime int = (SELECT  MAX(copyDuration) FROM [bpc].[aa_ActivityLogs_BPASessionLog_NonUnicode] WITH (NOLOCK) WHERE [executionStatus] IN ('Succeeded','Pass')),
@MinCpyDate date = (SELECT  MIN(CONVERT(DATE, createdTS)) as 'Lowest_Copy_Time (Seconds)' FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] WITH (NOLOCK) WHERE [copyStatus] = 'COMPLETED'),
@MaxCpyDate date = (SELECT  MAX(CONVERT(DATE, createdTS)) as 'Highest_Copy_Time (Seconds)' FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] WITH (NOLOCK) WHERE [copyStatus] = 'COMPLETED'),
@TotCopyDays int,
@AvgCpyTime int,
@AvgLogRowsCpy int

/*** Set Mathmatical Variables ***/
SET @PercentageSessionsCopied = (SELECT CAST((@TotSessionsCopied / CAST(@TotSessions AS DECIMAL(10, 2))) * 100 AS DECIMAL(5, 2))) 
SET @PercentageRowsCopied = (SELECT convert(float,@TotalRowsCopied) / convert(float,@TotalRows) * 100 )
SET @AvgCpyTime  = (SELECT @TotCpyTime/@TotSessionsCopied)
SET @TotCopyDays = (SELECT DISTINCT DATEDIFF(DAY, @MinCpyDate, @MaxCpyDate ) as 'Number_of_Copy_Days' FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] WITH (NOLOCK) WHERE [copyStatus] = 'COMPLETED')
SET @AvgLogRowsCpy = (SELECT @TotalRowsCopied/@TotCopyDays as 'Average_Daily_Log_Rows_Copied')

/*** Run Report Results ***/
SELECT DISTINCT @@SERVERNAME as 'Servername'
	  ,@TotSessions as 'Total_Sessionnumbers_Counted'
	  ,@TotSessionsCopied as 'Total_Sessionnumbers_Copied'
	  ,@PercentageSessionsCopied as 'Percentage_Sessionnumbers_Copied'
	  ,@TotalRows  as 'Total_Log_Rows_Counted'
	  ,@TotalRowsCopied  as 'Total_Log_Rows_Copied'
	  ,@PercentageRowsCopied as 'Percentage_Log_Rows_Copied'
	  ,@TotCpyTime as 'Total_Copy_Duration (Seconds)'
      ,@AvgCpyTime as 'Average_Log_Rows_Copy_Time (Seconds)'
      ,@MinCpyTime as 'Lowest_Log_Rows_Copy_Time (Seconds)'
	  ,@MinCpyDate as 'Lowest_Log_Rows_Copy_Date'
	  ,@MaxCpyDate as 'Highest_Log_Rows_Copy_Date'
	  ,@TotCopyDays as 'Number_of_Log_Rows_Copy_Days'
	  ,@AvgLogRowsCpy as 'Average_Daily_Log_Rows_Copied'