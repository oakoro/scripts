--select * from [BPC].[adf_watermark_sessionlog]
declare @min bigint, @max bigint, @targetmax bigint, @copymax bigint
if (select 1 from [BPC].[adf_watermark_sessionlog]) is null
begin
select top 1 @min =  id from [dbo].[sessionlog_partitionedFresh] order by id 
select top 1 @max =  id from [dbo].[sessionlog_partitionedFresh] order by id desc
select @min 'startlogid'
select @max 
select @targetmax = @min + 5000
select @targetmax
if @targetmax < @max
begin
set @copymax = @targetmax
end
else set @copymax = @max
end
select @copymax 'endlogid'

--select top 1* from [dbo].[sessionlog_partitionedFresh] order by id desc

