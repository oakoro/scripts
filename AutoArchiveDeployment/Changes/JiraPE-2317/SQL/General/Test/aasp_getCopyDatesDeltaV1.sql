/****** Object:  StoredProcedure [BPC].[aasp_getCopyDatesDelta]    Script Date: 31/10/2024 13:43:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BPC].[aasp_getCopyDatesDelta] 
@maxCount INT
AS

DECLARE @tablename VARCHAR(100),@deltacol VARCHAR(100),@lastDateCopied DATETIME,
		@currCount INT, @maxDate DATETIME, @minDate DATETIME, @sql1 NVARCHAR(400),
		--@maxCount INT = 10, 
		@sql2 NVARCHAR(400),@sql3 NVARCHAR(400),@sql4 NVARCHAR(400)

DECLARE @hold TABLE (currCount INT,minDate DATETIME,maxDate DATETIME)
DECLARE @datehold TABLE (datehold DATETIME)
DECLARE @tblcurrCount TABLE (currCount INT)
DECLARE @finaltable TABLE (minDate DATETIME, maxDate DATETIME, tableName VARCHAR(100))

DECLARE deltatable CURSOR
FOR
SELECT tablename, deltacolumn FROM BPC.adf_watermark WHERE tablename NOT IN ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')

OPEN deltatable

FETCH NEXT FROM deltatable INTO @tablename, @deltacol

WHILE @@FETCH_STATUS = 0

BEGIN

SELECT @lastDateCopied = last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = @deltacol AND tablename = @tablename

SET @sql1 = 'SELECT COUNT(*),MIN('+@deltacol+'),MAX('+@deltacol+') FROM dbo.'+@tablename +' WITH (NOLOCK);' 

INSERT @hold(currCount,minDate,maxDate)
EXEC (@sql1)

SELECT @currCount = currCount , @minDate = DATEADD(SS,-30,minDate)  ,@maxDate = maxDate FROM @hold 

IF @lastDateCopied = '1900-01-01 00:00:00.000'
	BEGIN
	SET @sql2 = 'SELECT TOP('+CONVERT(NVARCHAR(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' IS NOT NULL ORDER BY '+@deltacol 
	
	--print (@sql2)

	INSERT @datehold
	EXEC (@sql2)

	SELECT @maxDate = max(datehold)  FROM @datehold
	--SELECT ISNULL(@minDate,@lastDateCopied) AS 'minDate', ISNULL(@maxDate,@lastDateCopied) AS 'maxDate', @tablename AS 'tablename'
	INSERT @finaltable --VALUES(@minDate,@maxDate,@tablename)
	SELECT ISNULL(@minDate,@lastDateCopied), ISNULL(@maxDate,@lastDateCopied), @tablename
	END
	ELSE
	IF @lastDateCopied <> '1900-01-01 00:00:00.000'
	BEGIN
	SET @sql3 = 'SELECT COUNT(*) FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > ''' +convert(nvarchar(20),@lastDateCopied)+'''' +' AND '+@deltacol +' <= '''+convert(nvarchar(20),@maxDate)+''''

	INSERT @tblcurrCount
	EXEC (@sql3)

	--SELECT * FROM @tblcurrCount

		BEGIN
		IF (SELECT * FROM @tblcurrCount) > @maxCount
		BEGIN
		SET @sql4 = 'SELECT TOP('+convert(nvarchar(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > '''+convert(nvarchar(20),@lastDateCopied) +''' ORDER BY '+@deltacol 
		--PRINT (@sql4)
		INSERT @datehold
		EXEC (@sql4)

		SELECT @maxDate = max(datehold)  FROM @datehold
		SET @minDate = @lastDateCopied
		
		--SELECT @minDate AS 'minDate', @maxDate AS 'maxDate', @tablename AS 'tablename'
		INSERT @finaltable --VALUES(@minDate,@maxDate,@tablename)
		SELECT ISNULL(@minDate,@lastDateCopied), ISNULL(@maxDate,@lastDateCopied), @tablename
		END
		ELSE
		BEGIN
		SET @minDate = @lastDateCopied
		--SELECT @minDate AS 'minDate', @maxDate AS 'maxDate', @tablename AS 'tablename'
		INSERT @finaltable --VALUES(@minDate,@maxDate,@tablename)
		SELECT ISNULL(@minDate,@lastDateCopied), ISNULL(@maxDate,@lastDateCopied), @tablename
		END
		END
	END
--INSERT @finaltable VALUES(@minDate,@maxDate,@tablename)

--Empty temporary tables
DELETE @datehold
DELETE @tblcurrCount

--Populate finaltable


FETCH NEXT FROM deltatable INTO @tablename, @deltacol
END

CLOSE deltatable
DEALLOCATE deltatable

SELECT minDate,maxDate,tableName 
FROM @finaltable
GO

