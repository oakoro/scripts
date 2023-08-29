/****** Object:  StoredProcedure [BPC].[adfsp_get_maxlogid]    Script Date: 16/08/2023 12:23:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==============================================================================
-- Description: Get maximum logid from BPASessionLog_NonUnicode table to copy SPs
-- ==============================================================================

--ALTER PROCEDURE [BPC].[adfsp_get_maxlogid1]
--(
--	 @minlogid bigint, @rowamt bigint
--)
--AS
--BEGIN
DECLARE @minlogid bigint = 110357872, @rowamt bigint = 10

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
SET NOCOUNT ON

declare @mxid bigint = (SELECT MAX(logid) FROM [dbo].[BPASessionLog_NonUnicodeCopy] with (nolock))
IF @mxid IS NOT NULL
BEGIN
declare @addrow bigint = (SELECT @minlogid + @rowamt)
SELECT @addrow '@addrow'
SELECT @mxid '@mxid'
if  (Select @mxid) >= (Select @addrow) 
--IF @mxid >= @addrow
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


