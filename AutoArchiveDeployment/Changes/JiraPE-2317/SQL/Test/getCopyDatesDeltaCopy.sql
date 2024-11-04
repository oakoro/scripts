--select * from BPC.adf_watermark

declare @tablename varchar(100),@deltacol varchar(100),@lastDateCopied DATETIME,
		@currCount INT, @maxDate DATETIME, @minDate DATETIME, @sql nvarchar(400),
		@maxCount INT = 500, @sql2 nvarchar(400),@sql3 nvarchar(400)

DECLARE @hold TABLE (currCount INT,minDate DATETIME,maxDate DATETIME)
DECLARE @datehold TABLE (datehold DATETIME)
DECLARE @tblcurrCount TABLE (currCount INT)

declare deltatable cursor
for
select tablename, deltacolumn from BPC.adf_watermark where tablename not in ('BPASessionLog_NonUnicode','BPASessionLog_Unicode')

open deltatable

fetch next from deltatable into @tablename, @deltacol

while @@FETCH_STATUS = 0

begin

SELECT @lastDateCopied = last_processed_date FROM BPC.adf_watermark WHERE deltacolumn = @deltacol AND tablename = @tablename

--SET @sql = 'SELECT '+convert(varchar(100),@currCount) +'= COUNT(*) , '+convert(varchar(100),@minDate) +'= MIN('+@deltacol+')  ,'+convert(varchar(100),@maxDate) +'= MAX('+@deltacol+') FROM dbo.'+@tablename +' WITH (NOLOCK);' 
SET @sql = 'SELECT COUNT(*),MIN('+@deltacol+'),MAX('+@deltacol+') FROM dbo.'+@tablename +' WITH (NOLOCK);' 

INSERT @hold(currCount,minDate,maxDate)
EXEC (@sql)

IF @lastDateCopied = '1900-01-01 00:00:00.000'
	BEGIN
	SET @sql2 = 'SELECT TOP('+@maxCount +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK)  ORDER BY '+@deltacol 
	
	INSERT @datehold
	EXEC (@sql2)

	SELECT @maxDate = max(datehold)  FROM @datehold
	SELECT @minDate AS 'minDate', @maxDate AS 'maxDate'
	END
	ELSE
	IF @lastDateCopied <> '1900-01-01 00:00:00.000'
	BEGIN
	SET @sql3 = 'SELECT COUNT(*) FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > '+@lastDateCopied +' AND '+@deltacol +' <= '+@maxDate 
	--SELECT @currCount = COUNT(*) FROM dbo.BPAScheduleLogEntry WITH (NOLOCK) WHERE entrytime > @lastDateCopied and entrytime <= @maxDate
	INSERT @tblcurrCount
	EXEC (@sql3)


		BEGIN
		IF (SELECT * FROM @tblcurrCount) > @maxCount
		BEGIN
		SET @sql2 = 'SELECT TOP('+@maxCount +') '+@deltacol+ ' FROM dbo.'+@tablename +' WITH (NOLOCK) WHERE '+@deltacol +' > '+@lastDateCopied +' ORDER BY '+@deltacol 
		--SELECT TOP(@maxCount) entrytime FROM  dbo.BPAScheduleLogEntry WITH (NOLOCK) WHERE entrytime > @lastDateCopied ORDER BY entrytime 
		
		INSERT @datehold
		EXEC (@sql2)

		SELECT @maxDate = max(datehold)  FROM @datehold
		SET @minDate = @lastDateCopied
		--SELECT @minDate = @lastDateCopied, @maxDate = MAX(entrytime)  FROM cte_maxdate
		SELECT @minDate AS 'minDate', @maxDate AS 'maxDate'
		END
		ELSE
		BEGIN
		SET @minDate = @lastDateCopied
		SELECT @minDate AS 'minDate', @maxDate AS 'maxDate'
		END
		END
	END

--PRINT (@sql)

--select @currCount = currCount,@minDate=minDate,@maxDate=maxDate FROM @hold;
select @tablename , @deltacol,@lastDateCopied,@currCount,@minDate,@maxDate



fetch next from deltatable into @tablename, @deltacol
end

close deltatable
deallocate deltatable