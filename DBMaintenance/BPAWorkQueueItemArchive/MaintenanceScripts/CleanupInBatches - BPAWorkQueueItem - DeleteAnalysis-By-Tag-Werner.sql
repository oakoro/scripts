--select top 1* from [dbo].[BPAWorkQueueItem]
--select top 1* from [dbo].[BPAWorkQueue] 
--select top 1* from [dbo].[BPAWorkQueueItemTag]
--select * from [dbo].[BPATag] where tag like '%Trip%' -- is neither entering arrival radius nor departing departure radius'
/*
AS400 Delivery
FRTLIN + INTTRK + TESLAC Departures
Home Depot Departures
TSC Departures
Walmart Departures
select * from [dbo].[BPAWorkQueue] where name like '%Walmart%'
select * from [dbo].[BPAWorkQueue] where name = 'FRTLIN+INTTRK+TESLAC Departures'
*/
--sp_updatestats
--select wqit.queueitemident, t.tag, wq.name  
--from 
--[dbo].[BPAWorkQueueItemTag] wqit join [dbo].[BPATag] t on wqit.tagid = t.id
--join [dbo].[BPAWorkQueue] wq on wq.ident = wqit.queueitemident
--where t.id = 16361

;with cte_1
as
(
select wqi.id, wq.name,t.tag
from
[dbo].[BPAWorkQueueItem] wqi with (nolock) join [dbo].[BPAWorkQueue] wq with (nolock) on wqi.queueid = wq.id
join  [dbo].[BPAWorkQueueItemTag] wqit with (nolock) on wqit.[queueitemident] = wqi.[ident]
join [dbo].[BPATag] t with (nolock) on t.id = wqit.tagid 
where  t.id = 16361
and
wq.name in ('AS400 Delivery','FRTLIN+INTTRK+TESLAC Departures',
'Home Depot Departures','TSC Departures','Walmart Departures')  
)
select name, count(*)'RecordCount'  from cte_1 group by name

/*
name						RecordCount
Home Depot Departures		55978
FRTLIN+INTTRK+TESLAC Departures	60879
TSC Departures				162266
Walmart Departures			736730
AS400 Delivery				712134

14/07
name	RecordCount
AS400 Delivery	538474
FRTLIN+INTTRK+TESLAC Departures	22524
Home Depot Departures	24811
TSC Departures	68709
Walmart Departures	219578
*/