/****** Create [BPC].[adfsp_get_sessionlog_data] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[adfsp_get_sessionlog_data]',N'P')) IS NULL
BEGIN
DECLARE @adfsp_get_sessionlog_data NVARCHAR(MAX) = '

-- ==============================================================================
-- Description: Copy data from BPASessionLog_NonUnicode table to ADLS
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_get_sessionlog_data]
(
	@tableName nvarchar(30), @minlogid bigint, @maxlogid bigint
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @sqlCommand nvarchar(1000),
	@ParmDefinition nvarchar(500)

set @sqlCommand = N''select logid, sessionnumber, stageid, stagename, stagetype, processname, pagename, objectname, actionname, result, resulttype, startdatetime, enddatetime, attributexml, automateworkingset ,targetappname, targetappworkingset, starttimezoneoffset, endtimezoneoffset, attributesize from dbo.'' + @tableName + '' with (nolock) where logid > '' + CONVERT(nvarchar,@minlogid) + '' and  logid <= '' + CONVERT(nvarchar,@maxlogid) + '' order by logid;'';
set @ParmDefinition = N''@tableName nvarchar(255), @minlogid bigint, @maxlogid bigint'';
Exec sp_executesql @sqlCommand, @ParmDefinition, @tableName = @tableName, @minlogid = @minlogid, @maxlogid = @maxlogid

END'

EXECUTE SP_EXECUTESQL @adfsp_get_sessionlog_data
END