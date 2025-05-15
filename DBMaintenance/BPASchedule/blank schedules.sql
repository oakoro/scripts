select top 2* from [dbo].[BPAScheduleLog]
select top 2* from BPASchedule

select s.id,s.name,l.instancetime,l.servername,s.deletedname from dbo.BPASchedule s join [dbo].[BPAScheduleLog] l on s.id = l.scheduleid
where s.name is null
order by l.instancetime desc