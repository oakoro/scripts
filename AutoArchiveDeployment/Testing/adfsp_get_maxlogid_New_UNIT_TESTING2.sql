
declare
 @minlogid BIGINT = 574533291, @rowamt BIGINT = 10000000



	
	DECLARE @addrow BIGINT, @maxLogid BIGINT
	DECLARE @mxid BIGINT =  (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))
	

	IF @rowamt IS NOT NULL
		BEGIN
		SET @addrow = @minlogid + @rowamt
		END
		ELSE SET @addrow = 0

select @addrow'@addrow',@mxid'@mxid'

	IF @mxid IS NOT NULL AND @addrow = 0
		BEGIN
			SET @maxLogid = @mxid
		END
		ELSE IF @mxid IS NOT NULL AND @addrow <> 0
		BEGIN
			IF @mxid >= @addrow
			BEGIN
			SET @maxLogid = @addrow
			END
			ELSE SET @maxLogid = @mxid
		END 
		ELSE IF @mxid IS NULL
		SET @maxLogid = @minlogid
		
SELECT @maxLogid as 'MaxLogid'		


