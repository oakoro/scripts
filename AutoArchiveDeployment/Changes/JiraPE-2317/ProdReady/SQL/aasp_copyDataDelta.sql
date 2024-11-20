/****** Object:  StoredProcedure [BPC].[aasp_copyBPAAuditEventsDelta]    Script Date: 11/11/2024 14:53:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =====================================================================================
-- @version 24.5.03
-- Description: BPC table delta copy
-- Script execution Example: EXEC [BPC].[aasp_copyDataDelta] '1900-01-01T00:00:00Z','2021-07-16T21:21:25.78Z','BPAAuditEvents','eventdatetime'
-- =======================================================================================

ALTER PROCEDURE [BPC].[aasp_copyDataDelta]
@minDate DATETIME, @maxDate DATETIME,
@tableName NVARCHAR(50),@deltacol NVARCHAR(50)

AS

DECLARE @str NVARCHAR(400)

SET @str = 'SELECT * FROM DBO.'+@tableName +' WITH (NOLOCK) WHERE '+@deltacol +' > ''' +CONVERT(NVARCHAR(50),@minDate,9) +''' AND ' +@deltacol +' <= '''+CONVERT(NVARCHAR(50),@maxDate,9) +''';'
EXECUTE sp_executesql @str

GO


