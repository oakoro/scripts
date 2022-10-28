/*STEP 1 - IDENTIFY STARTING LOGID BASED ON RETENTION DATE*/
DECLARE @LatestSessionDate datetime, @RetainDate datetime, @RetentionDays int = -5
DECLARE @ProvidedStartDate datetime --= '2021-11-01'
DECLARE @logid BIGINT


if @ProvidedStartDate is not null
begin
select TOP 1 @LatestSessionDate= startdatetime from dbo.BPASession WITH (NOLOCK)
where enddatetime is not null and startdatetime >= @ProvidedStartDate
order by startdatetime asc;
set @RetainDate = @LatestSessionDate
end
else
begin
select TOP 1 @LatestSessionDate= startdatetime from dbo.BPASession WITH (NOLOCK)
where enddatetime is not null
order by startdatetime DESC;
SELECT @RetainDate = DATEADD(DD,@RetentionDays,@LatestSessionDate);
end

SELECT @LatestSessionDate as 'LatestSessionDate';

SELECT @RetainDate as 'RetainDate';

select top 1 @logid= logid FROM [dbo].[BPASessionLog_NonUnicode] with (nolock) where startdatetime >= @RetainDate
order by logid 
select @logid

/*
LatestSessionDate
2022-09-30 07:23:29.993
RetainDate
2022-09-25 07:23:29.993
logid
27748863

*/