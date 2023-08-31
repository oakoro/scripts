	--EXEC [BPC].[adfsp_get_minlogid] 'BPASessionLog_NonUnicode'
	--SELECT TOP 1 logid as 'ActualMaxLogid' from dbo.BPASessionLog_NonUnicode order by logid desc
	--EXEC [BPC].[adfsp_get_maxlogidNEW] @minlogid = 5
	[BPC].[adfsp_get_maxlogidNEWv2] @minlogid = 25

	DECLARE @minlogid BIGINT = 25, @rowamt BIGINT-- = 6
	DECLARE @addrow BIGINT
	DECLARE @mxid BIGINT =  (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))
	DECLARE @maxLogid BIGINT

	IF @rowamt IS NOT NULL --OR @rowamt <> 0 
		BEGIN
		SET @addrow = @minlogid + @rowamt
		END
		ELSE SET @addrow = 0

	SELECT @addrow '@addrow'
	SELECT @mxid '@mxid'

	--IF @mxid IS NOT NULL AND @minlogid = @addrow
	IF @mxid IS NOT NULL AND @addrow = 0
		BEGIN
			--IF  @minlogid = @addrow
			--BEGIN
			SET @maxLogid = @mxid
			SELECT @maxLogid  as 'MaxLogid'
			END
			else
	IF @mxid IS NOT NULL AND @addrow <> 0
		BEGIN
		IF @mxid >= @addrow
			BEGIN
			SET @maxLogid = @addrow
			SELECT @maxLogid  as 'MaxLogid'
			END
		END
			--ELSE 
			--IF @mxid IS NOT NULL AND @mxid <= @addrow
			--BEGIN
			--SET @maxLogid = @mxid
			--SELECT @maxLogid  as 'MaxLogid'
			--END
			--ELSE
			--BEGIN
			--SET @maxLogid = @addrow
			--SELECT @maxLogid as 'MaxLogid'
			--END
		--END
		else
IF @mxid IS NULL
		 
		BEGIN
		SET @maxLogid = @minlogid
		SELECT @maxLogid as 'MaxLogid'
		END

		SELECT @rowamt '@rowamt', @addrow '@addrow', @minlogid '@minlogid', @maxLogid '@maxLogid',@mxid'@mxid'

--110,357,872
--10,000,000