select top 1000 * from bpatag order by ID desc


SELECT t.id
, t.tag
, it.queueitemident
, it.tagid
FROM BPATag t
LEFT JOIN BPAWorkQueueItemTag it on t.id = it.tagid
WHERE it.tagid IS NULL

/*
delete t
from BPATag t
left join BPAWorkQueueItemTag it on t.id = it.tagid
where it.tagid is null;*/

--drop table BPATagBkp

--delete top (10000) from t
--from BPATag t with (nolock)
--left join BPAWorkQueueItemTag it with (nolock) on t.id = it.tagid
--where it.tagid is null;

/*
select t.id,it.tagid,it.queueitemident,t.tag
from BPATag t with (nolock)
 join BPAWorkQueueItemTag it with (nolock) on t.id = it.tagid
 order by id
*/