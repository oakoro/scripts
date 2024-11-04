--SELECT * FROM BPC.deltaHold

DECLARE @minDate datetime, @maxDate datetime, @tableName varchar(100) = 'BPAAuditEvents',@deltacol VARCHAR(100),
		@str nvarchar(400)


SELECT @minDate = minDate, @maxDate = maxDate, @tableName = tableName, @deltacol = deltacol FROM BPC.deltaHold WHERE tableName = @tableName

SELECT @minDate, @maxDate, @tableName, @deltacol

SET @str = 'SELECT * FROM DBO.'+@tableName +' 
WHERE '+CONVERT(NVARCHAR(20),@deltacol) +' > '''+CONVERT(NVARCHAR(20),@minDate) +'''' +' AND '
+CONVERT(NVARCHAR(20),@deltacol) +' <= '''+CONVERT(NVARCHAR(20),@maxDate)+''''
PRINT (@str)
EXEC (@str)

