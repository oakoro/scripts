/****** Create [BPC].[adfsp_get_maxlogid] Stored Procedure ******/

IF (OBJECT_ID(N'[BPC].[adfsp_get_maxlogid]',N'P')) IS NULL
BEGIN
DECLARE @adfsp_get_maxlogid NVARCHAR(MAX) = '

-- ==============================================================================
-- Description: Get maximum logid to copy from BPASessionLog_NonUnicode table
-- ==============================================================================

CREATE PROCEDURE [BPC].[adfsp_get_maxlogid]
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

Select @addrow  as ''MaxLogid''
end
else 
begin

Select @mxid as ''MaxLogid''
end

END
ELSE
BEGIN
SET @mxid = 0
Select @mxid as ''MaxLogid''
END

'

EXECUTE SP_EXECUTESQL @adfsp_get_maxlogid

END
ELSE
BEGIN
DECLARE @alter_adfsp_get_maxlogid NVARCHAR(MAX) = '

-- ==============================================================================
-- Description: Get maximum logid to copy from BPASessionLog_NonUnicode table
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

Select @addrow  as ''MaxLogid''
end
else 
begin

Select @mxid as ''MaxLogid''
end

END
ELSE
BEGIN
SET @mxid = 0
Select @mxid as ''MaxLogid''
END
'
EXECUTE SP_EXECUTESQL @alter_adfsp_get_maxlogid

END