select distinct object_name(object_id)'Tblname',rows from sys.partitions 
where object_name(object_id) in ('BPAWorkQueueItem_Old','BPAWorkQueueItemRetain','BPAWorkQueueItem','BPAWorkQueueItemRestore')

/*
Before
Tblname	rows
BPAWorkQueueItem	37475
BPAWorkQueueItemCopy	611270


After
Tblname	rows
BPAWorkQueueItem	611276
BPAWorkQueueItem_Old	37475
*/

