select * from [BPC].[adf_watermark]

--update [BPC].[adf_watermark]
--set last_processed_date = '2025-07-08 12:33:23.953'
--where tablename = 'BPAWorkQueueItem'

select 
ident, finished  
from dbo.BPAWorkQueueItem with (nolock) --9877
WHERE finished is not null 
	  AND finished > '2025-07-08 12:33:23.953' and ident > 80593
order by ident

/*
'2025-07-07 23:12:07.433'
2025-07-08 08:26:11.550
2025-07-08 08:35:37.983
2025-07-08 08:46:35.860
2025-07-08 09:00:31.820
2025-07-08 11:03:44.287
2025-07-08 12:33:23.953

*/

