declare @maxCount int = 5000
declare @currCount int
declare @maxDate datetime
declare @minDate datetime

declare @lastDateCopied datetime = '2024-04-18 10:33:51.283' --'1900-01-01 00:00:00.000' 

select @lastDateCopied'@lastDateCopied'


select @currCount = count(*) , @minDate = min(eventdatetime)   ,@maxDate = max(eventdatetime) from dbo.BPAAuditEvents with (nolock) 

select @currCount'@currCount', @minDate'@minDate', @maxDate'@maxDate'

if @lastDateCopied = '1900-01-01 00:00:00.000'
	begin
	select 'FirstTimeCopy';
	with cte_maxdate
	as
	(
	select top(@maxCount) eventdatetime from  dbo.BPAAuditEvents with (nolock) order by eventdatetime 
	)
	select @maxDate = max(eventdatetime)  from cte_maxdate
	select @currCount'@currCount',@minDate'@minDate', @maxDate'@maxDate'
	select * from dbo.BPAAuditEvents with (nolock) where eventdatetime >= @minDate and eventdatetime <= @maxDate
	end
else
	if @lastDateCopied <> '1900-01-01 00:00:00.000'
	begin
	select 'SubsequentCopy'
	select @lastDateCopied'@lateDateCopied'
	select @currCount = count(*) from dbo.BPAAuditEvents with (nolock) where eventdatetime > @lastDateCopied and eventdatetime <= @maxDate
		begin
		if @currCount > @maxCount
		begin
		with cte_maxdate
		as
		(
		select top(@maxCount) eventdatetime from  dbo.BPAAuditEvents with (nolock) where eventdatetime > @lastDateCopied order by eventdatetime 
		)
		select @minDate = @lastDateCopied, @maxDate = max(eventdatetime)  from cte_maxdate
		 
		select @currCount'@currCount', @minDate'@minDate', @maxDate'@maxDate'
		select * from dbo.BPAAuditEvents with (nolock) where eventdatetime > @minDate and eventdatetime <= @maxDate
		end
		else
		begin
		select 'FinalCopy'
		set @minDate = @lastDateCopied
		select @currCount'@currCount', @minDate'@minDate', @maxDate'@maxDate'
		select * from dbo.BPAAuditEvents with (nolock) where eventdatetime > @minDate and eventdatetime <= @maxDate
		end
		end
		

		
		
		
	end

