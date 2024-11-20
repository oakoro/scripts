select * from dbo.BPAWorkQueueItem i join dbo.BPAWorkQueue q on i.queueid = q.id
where q.name = 'Web Enquiries - UpdateEntries - Work Queue' and completed is not null
order by completed
--select * from dbo.BPAWorkQueue
--where name in ('BPC - Regular Valuations')
