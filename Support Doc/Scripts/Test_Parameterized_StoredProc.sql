---
DECLARE @SNo int,@recordlimit int = 100000;

EXECUTE BPC.[aasp_GetSessionNumToDeleteFlex_BPASessionLog_NonUnicode] 7,@recordlimit
     ,@sessionnumber = @SNo OUTPUT;


SELECT TOP (1) sessionnumber, recordCopied FROM
[olabode].[ActivityLogsBPASessionLog] WITH (NOLOCK)
WHERE status = 'Succeeded' AND deletedTS IS NULL AND DATEDIFF(DD,createdTS,GETDATE()) >= 7 
AND recordCopied > 100000