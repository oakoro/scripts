/*STEP 1 - IDENTIFY STARTING LOGID BASED ON RETENTION DATE*/
DECLARE @LatestSessionDate datetime, @RetainDate datetime, @RetentionDays int = -30
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
select @logid 'StartingLogid' -- 159453612


/*
LatestSessionDate
2023-02-07 09:54:33.187
RetainDate
2023-01-08 09:54:33.187
StartingLogid 
159453612
select count(*) from BPASessionLog_NonUnicode with (nolock)
where logid > 159453611 --1776951
*/