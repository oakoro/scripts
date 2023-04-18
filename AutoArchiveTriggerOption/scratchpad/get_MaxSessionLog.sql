declare @copymaxlogid bigint, @minlogid bigint, @maxlogid bigint

--select * from [dbo].[BPASessionLog_NonUnicode]
--where logid between 1 and 1000
select @maxlogid = max(logid) from [dbo].[BPASessionLog_NonUnicode] with (nolock)

if (select 1 from bpc.adf_watermark_sessionlog where tablename = 'BPASessionLog_NonUnicode') is not null
begin
select @minlogid = logid from bpc.adf_watermark_sessionlog where tablename = 'BPASessionLog_NonUnicode'


	if @maxlogid < @minlogid + 5000000
	begin
	set @copymaxlogid = @maxlogid
	end
	else set @copymaxlogid = @minlogid + 5000000
end
else
begin
set @copymaxlogid = @maxlogid
end

select @copymaxlogid

