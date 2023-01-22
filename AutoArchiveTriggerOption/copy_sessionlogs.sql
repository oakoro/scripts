
SET NOCOUNT ON
DECLARE @high INT
DECLARE @tbl1 TABLE ([sessionnumber] INT,[rowNumber] INT);


/*Session numbers collected in order of enddatetime*/
IF EXISTS (SELECT 1 FROM tblBPASessionUpdateTracking WHERE copystatus IS NULL)
BEGIN
TRUNCATE TABLE tblSessionReadyToCopy; 		
INSERT @tbl1([sessionnumber],[rowNumber])
SELECT sessionnumber, COUNT(*) AS 'RecordCount' FROM [dbo].[BPASessionLog_NonUnicode] WITH (NOLOCK)
WHERE sessionnumber in (SELECT top (50) sessionnumber FROM tblBPASessionUpdateTracking WHERE copystatus IS NULL)
GROUP BY sessionnumber

  
 /*Combines session numbers based on size*/
 SET @high = 
 (SELECT TOP (1)  [rowNumber] FROM @tbl1 ORDER BY [rowNumber] DESC) ;
 
 IF @high BETWEEN 1 AND 20000
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 ELSE
 IF @high BETWEEN 20001 AND 50000
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT TOP (20) [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 ELSE
 IF @high BETWEEN 50001 AND 100000
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT TOP (10) [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 ELSE
 IF @high BETWEEN 100001 AND 125000
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT TOP (8) [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 ELSE
 IF @high BETWEEN 125001 AND 200000
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT TOP (5) [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 ELSE
 IF @high BETWEEN 200001 AND 250000
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT TOP (4) [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 ELSE
 IF @high BETWEEN 250001 AND 300000
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT TOP (3) [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 ELSE
 IF @high BETWEEN 300001 AND 500000
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT TOP (2) [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 ELSE
 BEGIN
 INSERT tblSessionReadyToCopy([sessionnumber])
 SELECT TOP (1) [sessionnumber] FROM @tbl1 ORDER BY [rowNumber] DESC 
 END
 SELECT * FROM [dbo].[BPASessionLog_NonUnicode] 
WHERE [sessionnumber] IN (SELECT [sessionnumber] FROM tblSessionReadyToCopy);
 SET NOCOUNT OFF
END


/*
update OkeTriggerTableTest 
set status = 1
WHERE [sessionnumber] = 51
*/