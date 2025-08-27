select  
DATEPART(year,inserttime)'Year', 
DATEPART(MONTH,inserttime)'Month',
DATEPART(WEEK,inserttime)'Week',
count(*) from dbo.BPADataPipelineInput
group by 
DATEPART(year,inserttime),
DATEPART(MONTH,inserttime),
DATEPART(WEEK,inserttime)
order by 
DATEPART(year,inserttime),
DATEPART(MONTH,inserttime),
DATEPART(WEEK,inserttime)