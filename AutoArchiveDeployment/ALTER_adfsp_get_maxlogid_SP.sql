/****** Object:  StoredProcedure [BPC].[adfsp_get_maxlogid]    Script Date: 16/08/2023 12:55:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==============================================================================
-- Description: Get maximum logid from BPASessionLog_NonUnicode table to copy SPs
-- ==============================================================================

ALTER PROCEDURE [BPC].[adfsp_get_maxlogid]
(
	 @minlogid bigint, @rowamt bigint
)
AS


    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
SET NOCOUNT ON

declare @mxid bigint = (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicode] with (nolock))
IF @mxid IS NOT NULL
BEGIN
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
ELSE
BEGIN
SET @mxid = 0
Select @mxid as 'MaxLogid'
END


