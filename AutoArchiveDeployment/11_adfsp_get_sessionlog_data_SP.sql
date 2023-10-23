/****** Object:  StoredProcedure [BPC].[adfsp_get_sessionlog_data]    Script Date: 23/10/2023 19:24:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==============================================================================
-- Description: Copy data from session log data to ADLS
-- ==============================================================================

CREATE OR ALTER PROCEDURE [BPC].[adfsp_get_sessionlog_data]
(
	@minlogid BIGINT, @maxlogid BIGINT
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	DECLARE @sqlCommand NVARCHAR(1000),	@ParmDefinition NVARCHAR(500),
			@LoggingType BIT,@sessionlogtable NVARCHAR(50)

	SELECT @LoggingType = unicodeLogging FROM BPASysConfig
	
	IF @LoggingType = 0
	SET @sessionlogtable = 'BPASessionLog_NonUnicode'
	ELSE SET @sessionlogtable = 'BPASessionLog_Unicode'

SET @sqlCommand = N'select logid, sessionnumber, stageid, stagename, stagetype, processname, pagename, objectname, actionname, result, resulttype, startdatetime, enddatetime, attributexml, automateworkingset ,targetappname, targetappworkingset, starttimezoneoffset, endtimezoneoffset, attributesize from dbo.' + @sessionlogtable + ' with (nolock) where logid > ' + CONVERT(nvarchar,@minlogid) + ' and  logid <= ' + CONVERT(nvarchar,@maxlogid) + ' order by logid;';
SET @ParmDefinition = N'@sessionlogtable nvarchar(255), @minlogid bigint, @maxlogid bigint';
EXEC sp_executesql @sqlCommand, @ParmDefinition, @sessionlogtable = @sessionlogtable, @minlogid = @minlogid, @maxlogid = @maxlogid

END
GO


