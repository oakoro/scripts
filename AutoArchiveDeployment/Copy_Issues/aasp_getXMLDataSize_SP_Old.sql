-- =============================================
-- Description: Get total size of XML value to copy from session log table 
-- Script execution Example: [BPC].[aasp_getXMLDataSize] 2, 7
-- variable description: 
--	@minLogid - Minimum logid to copy, 
--  @maxLogid - Maximum logid to copy
-- ==============================================

ALTER PROCEDURE BPC.aasp_getXMLDataSize
@minLogid BIGINT, @maxLogid BIGINT

AS

DECLARE @sumDataSize BIGINT,@status BIT 

SET NOCOUNT ON
BEGIN
SELECT @sumDataSize =  SUM( 
ISNULL(DATALENGTH([result]), 1)+ISNULL(DATALENGTH([attributexml]), 1) )
FROM BPASessionLog_NonUnicode WITH (NOLOCK)
WHERE logid BETWEEN ISNULL(@minLogid,0) AND ISNULL(@maxLogid,0)
END
--SELECT 
--ISNULL(@sumDataSize,0) AS 'DateSize'
IF ISNULL(@sumDataSize,0) > 10 SET @status = 0 ELSE SET @status = 1
SELECT @status AS 'DataSizeStatus'


SET NOCOUNT OFF
