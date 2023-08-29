/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000) [tablename]
--      ,[deltacolumn]
--      ,[last_processed_date]
--      ,[logid]
--  FROM [BPC].[adf_watermark] --320000000

/****** Object:  StoredProcedure [BPC].[adfsp_get_minlogid]    Script Date: 29/08/2023 12:40:04 ******/



--select count(*)
--from
--dbo.BPASessionLog_NonUnicode with (nolock)
--where logid between 310000000 and 320000000


-- ==============================================================================
-- Description: Get last copied logid from the watermark table 
-- ==============================================================================

--CREATE PROCEDURE [BPC].[adfsp_get_minlogid]
--(
--	 @tableName varchar(255)
--)
--AS
declare  @tableName varchar(255) = 'BPASessionLog_NonUnicode'
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	declare @sqlCommand nvarchar(1000),
	@ParmDefinition nvarchar(500),
	@logid bigint,
	@logidOUT bigint

set @sqlCommand = N'SELECT logid as ''minlogid'' FROM bpc.adf_watermark where tableName = ''' + @tableName + ''';'
set @ParmDefinition = N'@tableName varchar(255), @logidOUT bigint OUTPUT';
Exec sp_executesql @sqlCommand, @ParmDefinition, @tableName = @tableName, @logidOUT = @logid OUTPUT;

END


/****** Object:  StoredProcedure [BPC].[adfsp_get_maxlogid]    Script Date: 29/08/2023 12:43:07 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO



-- ==============================================================================
-- Description: Get maximum logid to copy from BPASessionLog_NonUnicode table
-- ==============================================================================

--CREATE PROCEDURE [BPC].[adfsp_get_maxlogid]
--(
--	 @minlogid bigint, @rowamt bigint
--)
--AS
declare @minlogid bigint, @rowamt bigint
set @minlogid = 320000000
set @rowamt = 10000000
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
SET NOCOUNT ON

declare @mxid bigint = (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))
declare @addrow bigint = (SELECT @minlogid + @rowamt)

if  (Select @mxid) >= (Select @addrow) 
begin

Select @addrow  as 'MaxLogid'
end
else 
begin

Select @mxid as 'MaxLogid'
end

END
GO

select top 1 logid 'ActualMaxLogid' 
from
dbo.BPASessionLog_NonUnicode with (nolock) order by logid desc

--select top 1 logid 'ActualMinLogid' 
--from
--dbo.BPASessionLog_NonUnicode with (nolock) 
----where kogid > 
--order by logid 


