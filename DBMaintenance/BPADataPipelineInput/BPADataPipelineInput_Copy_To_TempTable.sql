set IDENTITY_INSERT dbo.[BPADataPipelineInput_Temp] on;
insert into [dbo].[BPADataPipelineInput_Temp](
[id],[eventtype],[eventdata],[publisher],[inserttime]
)
select * from [dbo].[BPADataPipelineInput]
where 
DATEPART(year,inserttime) = 2025 AND
DATEPART(MONTH,inserttime) = 7 AND
DATEPART(WEEK,inserttime) = 31