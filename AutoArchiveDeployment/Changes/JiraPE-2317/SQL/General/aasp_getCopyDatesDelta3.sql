/****** Object:  StoredProcedure [BPC].[aasp_getCopyDatesDelta]    Script Date: 31/10/2024 13:43:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [BPC].[aasp_getCopyDatesDelta3] 
@maxCount INT, @tablename VARCHAR(100)
AS

DECLARE 
		@deltacol VARCHAR(100),@lastDateCopied DATETIME,
		@initCount INT,@currCount INT, @maxDate DATETIME, @minDate DATETIME, @sql1 NVARCHAR(400),
		@sql2 NVARCHAR(400),@sql3 NVARCHAR(400),@sql4 NVARCHAR(400),
		@defaultdate DATETIME = '1900-01-01 00:00:00.000'

DECLARE @hold TABLE (initCount INT,minDate DATETIME,maxDate DATETIME)
DECLARE @datehold TABLE (datehold DATETIME)
DECLARE @tblcurrCount TABLE (currCount INT)
DECLARE @finaltable TABLE (minDate DATETIME, maxDate DATETIME, tableName VARCHAR(100),deltacol VARCHAR(100))

BEGIN

SELECT @lastDateCopied = last_processed_date, @deltacol = deltacolumn FROM BPC.adf_watermark WHERE tablename = @tablename

SET @sql1 = 'SELECT COUNT(*),MIN('+@deltacol+'),MAX('+@deltacol+') FROM dbo.'+@tablename +' WITH (NOLOCK);' 

INSERT @hold(initCount,minDate,maxDate)
EXEC (@sql1)

SELECT @initCount = initCount , @minDate = DATEADD(SS,-30,minDate)  ,@maxDate = maxDate FROM @hold 

IF @lastDateCopied = @defaultdate
	BEGIN
	SET @sql2 = 'SELECT TOP('+CONVERT(NVARCHAR(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' IS NOT NULL ORDER BY '+@deltacol 
	
	INSERT @datehold
	EXEC (@sql2)

	SELECT @maxDate = max(datehold)  FROM @datehold
	SET @minDate = @defaultdate
	
	SELECT @minDate AS minDate, ISNULL(@maxDate,@lastDateCopied) AS maxDate, @tablename AS tablename,@deltacol AS deltacol
	END
	ELSE
	IF @lastDateCopied <> @defaultdate
	BEGIN
	SET @sql3 = 'SELECT COUNT(*) FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > ''' +convert(nvarchar(50),@lastDateCopied,9)+'''' +' AND '+@deltacol +' <= '''+convert(nvarchar(50),@maxDate,9)+''''

	INSERT @tblcurrCount
	EXEC (@sql3)

	SELECT @currCount=currCount FROM @tblcurrCount


	
		BEGIN
		IF @currCount > @maxCount
		BEGIN
		
		SET @sql4 = 'SELECT TOP('+convert(nvarchar(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > '''+convert(nvarchar(50),@lastDateCopied,9) +''' ORDER BY '+@deltacol 
		

		PRINT (@sql4)
		INSERT @datehold
		EXEC (@sql4)

		SELECT @maxDate = max(datehold)  FROM @datehold
		SET @minDate = @lastDateCopied
		
		SELECT @minDate AS minDate, @maxDate AS maxDate, @tablename AS tablename,@deltacol AS deltacol
		END
		ELSE
		BEGIN
		SET @minDate = @lastDateCopied
		
		SELECT @minDate AS minDate, @maxDate AS maxDate, @tablename AS tablename,@deltacol AS deltacol
		END
		END
	END
	END

--Empty temporary tables
DELETE @datehold
DELETE @tblcurrCount



--[BPC].[aasp_getCopyDatesDelta3] 10, 'BPAWorkQueueItem'
