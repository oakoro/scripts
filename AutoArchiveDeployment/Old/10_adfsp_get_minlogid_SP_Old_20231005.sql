/****** Create [BPC].[adfsp_get_minlogid] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[adfsp_get_minlogid]',N'P')) IS NULL
BEGIN
DECLARE @adfsp_get_minlogid NVARCHAR(MAX) = '

-- ==============================================================================
-- Description: Get last copied logid from the watermark table 
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_get_minlogid]
(
	 @tableName varchar(255)
)
AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @sqlCommand nvarchar(1000),
	@ParmDefinition nvarchar(500),
	@logid bigint,
	@logidOUT bigint

set @sqlCommand = N''SELECT logid as ''''minlogid'''' FROM bpc.adf_watermark where tableName = '''''' + @tableName + '''''';''
set @ParmDefinition = N''@tableName varchar(255), @logidOUT bigint OUTPUT'';
Exec sp_executesql @sqlCommand, @ParmDefinition, @tableName = @tableName, @logidOUT = @logid OUTPUT;

END'

EXECUTE SP_EXECUTESQL @adfsp_get_minlogid
END