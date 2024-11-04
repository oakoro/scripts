/****** Object:  StoredProcedure [BPC].[aasp_getCopyDatesDeltaSingle]    Script Date: 31/10/2024 13:41:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BPC].[aasp_getCopyDatesDeltaSingle] 
@maxCount INT, @tableName VARCHAR(100) = BPAWorkQueueItem
AS

DECLARE --@tablename VARCHAR(100) = 'BPAAuditEvents',
		@deltacol VARCHAR(100),@lastDateCopied DATETIME,
		@currCount INT, @maxDate DATETIME, @minDate DATETIME, @sql1 NVARCHAR(400),
		--@maxCount INT = 10, 
		@sql2 NVARCHAR(400),@sql3 NVARCHAR(400),@sql4 NVARCHAR(400)

DECLARE @hold TABLE (currCount INT,minDate DATETIME,maxDate DATETIME)
DECLARE @datehold TABLE (datehold DATETIME)
DECLARE @tblcurrCount TABLE (currCount INT)

SELECT @deltacol = deltacolumn, @lastDateCopied = last_processed_date FROM BPC.adf_watermark WHERE tablename = @tablename

SET @sql1 = 'SELECT COUNT(*),MIN('+@deltacol+'),MAX('+@deltacol+') FROM dbo.'+@tablename +' WITH (NOLOCK);' 

INSERT @hold(currCount,minDate,maxDate)
EXEC (@sql1)

SELECT @currCount = currCount , @minDate = DATEADD(SS,-30,minDate)  ,@maxDate = maxDate FROM @hold 

IF @lastDateCopied = '1900-01-01 00:00:00.000'
	BEGIN
	SET @sql2 = 'SELECT TOP('+CONVERT(NVARCHAR(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' IS NOT NULL ORDER BY '+@deltacol 
	
	INSERT @datehold
	EXEC (@sql2)

	SELECT @maxDate = max(datehold)  FROM @datehold
	SELECT ISNULL(@minDate,@lastDateCopied) AS 'minDate', ISNULL(@maxDate,@lastDateCopied) AS 'maxDate', @tablename AS 'tablename'

	END
	ELSE
	IF @lastDateCopied <> '1900-01-01 00:00:00.000'
	BEGIN
	SET @sql3 = 'SELECT COUNT(*) FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > ''' +convert(nvarchar(20),@lastDateCopied)+'''' +' AND '+@deltacol +' <= '''+convert(nvarchar(20),@maxDate)+''''

	INSERT @tblcurrCount
	EXEC (@sql3)

	select * from @tblcurrCount
		BEGIN
		IF (SELECT * FROM @tblcurrCount) > @maxCount
		BEGIN
		SET @sql4 = 'SELECT TOP('+convert(nvarchar(20),@maxCount) +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > '''+convert(nvarchar(20),@lastDateCopied) +''' ORDER BY '+@deltacol 
		
		INSERT @datehold
		EXEC (@sql4)

		select * from @datehold order by datehold desc
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



GO


