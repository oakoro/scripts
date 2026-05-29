select top 1* from [dbo].[BPAWorkQueueItem] order by ident desc

select top 1* from [dbo].[BPAWorkQueueItem_Old] order by ident desc

select top 1* from BPAWorkQueueItemRestore order by ident desc


--select count(*) from [dbo].[BPAWorkQueueItem] where ident > 817560

--select count(*) from [dbo].[BPAWorkQueueItem_Old] where ident > 817560

select count(ident)'Data Not Capture in Archive' from dbo.BPAWorkQueueItemRestore 
where ident not in (select ident from [dbo].[BPAWorkQueueItem])


select count(ident)'Data Not Capture in Former Live Table' from dbo.BPAWorkQueueItem_Old
where ident not in (select ident from [dbo].[BPAWorkQueueItem])