/****** Object:  StoredProcedure [BPC].[adfsp_get_sessionlog_data_OkeReview]    Script Date: 10/05/2023 18:58:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/*
[BPC].[adfsp_update_watermark_sessionlog] 'BPASessionLog_NonUnicodeOATest',2320,2011
*/

CREATE OR ALTER   PROCEDURE [BPC].[adfsp_update_watermark_sessionlog]
@tableName nvarchar(50),
@currentMaxlogid bigint,
@targetCopymaxid bigint

AS


 
	declare @sqlCommand nvarchar(1000),
	@watermarklogid bigint

if @targetCopymaxid is not null and @targetCopymaxid < @currentMaxlogid
begin
set @watermarklogid = @targetCopymaxid

set @sqlCommand ='
update bpc.adf_watermark_sessionlog 
set logid = '+convert(nvarchar(50),@watermarklogid)+',copiedDate = GETDATE(),capturedDate = GETDATE() where tablename = '
+''''+@tableName+''''
--print @sqlCommand
execute sp_executesql @sqlCommand
select 1

end
if @targetCopymaxid is not null and @targetCopymaxid >= @currentMaxlogid
begin
set @watermarklogid = @currentMaxlogid

set @sqlCommand ='
update bpc.adf_watermark_sessionlog 
set logid = '+convert(nvarchar(50),@watermarklogid)+',copiedDate = GETDATE(),capturedDate = GETDATE() where tablename = '
+''''+@tableName+''''
--print @sqlCommand
execute sp_executesql @sqlCommand
select 1
end
GO


