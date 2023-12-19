DECLARE @LatestSessionDate datetime, @TargetSessionnum int, @RetentionDays int = -5
DECLARE @ProvidedStartDate datetime --= '2023-03-24'
DECLARE @logid BIGINT

if @ProvidedStartDate is not null
begin
select TOP 1 @LatestSessionDate= startdatetime, @TargetSessionnum = sessionnumber from dbo.BPASession WITH (NOLOCK)
where enddatetime is not null and startdatetime >= @ProvidedStartDate
order by startdatetime asc;
end
else
begin
select TOP 1 @LatestSessionDate= startdatetime, @TargetSessionnum = sessionnumber from dbo.BPASession WITH (NOLOCK)
where enddatetime is not null and startdatetime >= CONVERT(DATE,DATEADD(DD,@RetentionDays,GETDATE()))
order by startdatetime asc;
end

select top 1 @logid = logid FROM [dbo].[BPASessionLog_NonUnicode] with (nolock) where sessionnumber = @TargetSessionnum
order by logid 
select @LatestSessionDate'LatestSessionDate', @TargetSessionnum'TargetSessionnum', @logid'logid'


