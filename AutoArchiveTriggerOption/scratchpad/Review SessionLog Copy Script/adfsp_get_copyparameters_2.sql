/****** Object:  StoredProcedure [BPC].[adfsp_get_copyparameters_1]    Script Date: 11/05/2023 15:04:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [BPC].[adfsp_get_copyparameters_2]
@rowamt bigint,@tableName varchar(255),@tableSchema varchar(10),
 @currentMaxlogidOut bigint output
AS

declare @minlogid bigint, @copiedMaxlogid bigint, @watermarklogid bigint,
 @currentMaxlogid bigint, @targetCopymaxid bigint, @strcommand nvarchar(400),
 @params NVARCHAR(255) = '@currentMaxlogid BIGINT OUTPUT'

 





 

select @copiedMaxlogid = logid FROM bpc.adf_watermark_sessionlog where tableName = @tableName
set @targetCopymaxid = @copiedMaxlogid + @rowamt
set @strcommand = 'select top 1 @currentMaxlogid = max(logid) from ' +@tableSchema +'.'+@tableName

EXEC sp_executeSQL @strcommand, @params, @currentMaxlogid = @currentMaxlogidout OUTPUT;
select @currentMaxlogidOut'currentMaxlogid',@copiedMaxlogid'copiedMaxlogid',
@rowamt'rowamt',@targetCopymaxid'targetCopymaxid'
/*
--execute sp_executesql @strcommand
--select @copiedMaxlogid'copiedMaxlogid', @currentMaxlogid'currentMaxlogid',
--@rowamt'rowamt',@targetCopymaxid'targetCopymaxid'

--ARCH.BPASessionLog_NonUnicodeOATest
GO

--DECLARE @Tablename NVARCHAR(255) = 'BPASessionLog_NonUnicodeOATest';
--DECLARE @tableSchema varchar(10) = 'ARCH'
--DECLARE @maxlogidout BIGINT;
--DECLARE @params1 NVARCHAR(255) = '@Maxlogid BIGINT OUTPUT'
--DECLARE @SQL1 NVARCHAR(4000) = 'select top 1 @maxlogid = max(logid) from ' +@tableSchema +'.'+@tableName

--declare @minlogid bigint, @copiedMaxlogid bigint, @watermarklogid bigint,
-- @currentMaxlogid bigint, @targetCopymaxid bigint, @strcommand nvarchar(400),@rowamt bigint
 
-- set @rowamt = 2 




 

--select @copiedMaxlogid = logid FROM bpc.adf_watermark_sessionlog where tableName = @tableName
--select @copiedMaxlogid
--set @targetCopymaxid = @copiedMaxlogid + @rowamt

--EXEC sp_executeSQL @SQL1, @params1, @maxlogid = @maxlogidout OUTPUT;
--select @maxlogidout'currentMaxlogid',@copiedMaxlogid'copiedMaxlogid',
--@rowamt'rowamt',@targetCopymaxid'targetCopymaxid'
*/