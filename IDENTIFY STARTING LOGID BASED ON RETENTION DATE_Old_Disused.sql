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



/*STEP 2 - RUN COPY SCRIPT IN SQL SERVER EXPORT TASK*/
--  SELECT 
--			 [logid]
--		   ,[sessionnumber]
--           ,[stageid]
--           ,[stagename]
--           ,[stagetype]
--           ,[processname]
--           ,[pagename]
--           ,[objectname]
--           ,[actionname]
--           ,[result]
--           ,[resulttype]
--           ,[startdatetime]
--           ,[enddatetime]
--           ,[attributexml]
--           ,[automateworkingset]
--           ,[targetappname]
--           ,[targetappworkingset]
--           ,[starttimezoneoffset]
--           ,[endtimezoneoffset]
--FROM [dbo].[BPASessionLog_NonUnicodeReplica] with (forceseek)
--WHERE logid >= 12428063 
--startdatetime >= @RetainDate;

--select * FROM [dbo].[BPASessionLog_NonUnicodeReplica] with (forceseek)
--WHERE logid >= 12428063





/****Verification*****
select top 5* FROM [dbo].[BPASessionLog_NonUnicode] with (nolock) where logid <= 285703420
order by logid desc

select top 5* FROM [dbo].[BPASessionLog_NonUnicode] with (nolock) where logid >= 285703420
order by logid
select count(*) from [dbo].[BPASessionLog_NonUnicode] with (nolock) where logid < 12520741 
select count(*) from [dbo].[BPASessionLog_NonUnicode] with (nolock) where logid >= 285703420 
*/


--alter table [dbo].[BPASessionLog_NonUnicode1] switch to [dbo].[BPASessionLog_NonUnicodeReplica]

/*
Date: 2021-11-01 00:30:24.207
Start logid: 205623897
Volume: 108142090 rows
*******************
90 days of Data
Start date: 2022-04-13 14:00:48.380
Start logid: 285703420
volume: 28140569
*/


