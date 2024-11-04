DECLARE @tablename VARCHAR(100),@deltacol VARCHAR(100),@lastDateCopied DATETIME,
		@currCount INT, @maxDate DATETIME, @minDate DATETIME, @sql NVARCHAR(400),
		@maxCount INT = 500, @sql2 NVARCHAR(400),@sql3 NVARCHAR(400)

DECLARE @hold TABLE (currCount INT,minDate DATETIME,maxDate DATETIME)
DECLARE @datehold TABLE (datehold DATETIME)
DECLARE @tblcurrCount TABLE (currCount INT)

DECLARE deltatable CURSOR
FOR
SELECT tablename, deltacolumn FROM BPC.adf_watermark WHERE tablename NOT IN ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')

OPEN deltatable

FETCH NEXT FROM deltatable INTO @tablename, @deltacol

WHILE @@FETCH_STATUS = 0

BEGIN

SELECT @lastDateCopied = last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = @deltacol AND tablename = @tablename

SET @sql = 'SELECT COUNT(*),MIN('+@deltacol+'),MAX('+@deltacol+') FROM dbo.'+@tablename +' WITH (NOLOCK);' 

INSERT @hold(currCount,minDate,maxDate)
EXEC (@sql)

SELECT @currCount = currCount , @minDate = minDate  ,@maxDate = maxDate FROM @hold 

IF @lastDateCopied = '1900-01-01 00:00:00.000'
	BEGIN
	SET @sql2 = 'SELECT TOP('+CONVERT(NVARCHAR(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' IS NOT NULL ORDER BY '+@deltacol 
	
	print (@sql2)

	INSERT @datehold
	EXEC (@sql2)

	SELECT @maxDate = max(datehold)  FROM @datehold
	SELECT @minDate AS 'minDate', @maxDate AS 'maxDate', @tablename AS 'tablename'
	END
	ELSE
	IF @lastDateCopied <> '1900-01-01 00:00:00.000'
	BEGIN
	SET @sql3 = 'SELECT COUNT(*) FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > ''' +convert(nvarchar(20),@lastDateCopied)+'''' +' AND '+@deltacol +' <= '''+convert(nvarchar(20),@maxDate)+''''

	INSERT @tblcurrCount
	EXEC (@sql3)


		BEGIN
		IF (SELECT * FROM @tblcurrCount) > @maxCount
		BEGIN
		SET @sql2 = 'SELECT TOP('+convert(nvarchar(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > '''+convert(nvarchar(20),@lastDateCopied) +''' ORDER BY '+@deltacol 
		PRINT (@sql2)
		INSERT @datehold
		EXEC (@sql2)

		SELECT @maxDate = max(datehold)  FROM @datehold
		SET @minDate = @lastDateCopied
		
		SELECT @minDate AS 'minDate', @maxDate AS 'maxDate', @tablename AS 'tablename'
		END
		ELSE
		BEGIN
		SET @minDate = @lastDateCopied
		SELECT @minDate AS 'minDate', @maxDate AS 'maxDate', @tablename AS 'tablename'
		END
		END
	END

FETCH NEXT FROM deltatable INTO @tablename, @deltacol
END

CLOSE deltatable
DEALLOCATE deltatable