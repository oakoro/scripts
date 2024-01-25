SELECT count(*) 
FROM BPAWorkQueueItem
WHERE finished is not null 
	  AND finished between --'@{activity('Lookup_Last_Processed_Date').output.firstRow.last_processed_date}'

	  (SELECT last_processed_date FROM [BPC].[adf_watermark]
WHERE tablename = 'BPAWorkQueueItem') 
and getdate()

--(SELECT dateadd(d,30,last_processed_date) FROM [BPC].[adf_watermark]
--WHERE tablename = 'BPAWorkQueueItem')

SELECT count(*) 
FROM BPAWorkQueueItem
WHERE finished is not null 
	  AND finished > --'@{activity('Lookup_Last_Processed_Date').output.firstRow.last_processed_date}'

	  (SELECT last_processed_date FROM [BPC].[adf_watermark]
WHERE tablename = 'BPAWorkQueueItem')


select dateadd(D,30,'2024-01-07 08:31:19.300')

SELECT dateadd(d,30,last_processed_date) AS 'last_processed_date' FROM [BPC].[adf_watermark]
WHERE tablename = 'BPAWorkQueueItem'

/*
SELECT * FROM [BPC].[adf_watermark]
WHERE tablename = 'BPAWorkQueueItem'
2023-09-09 08:31:19.300
2023-10-09 08:31:19.300
2023-11-08 08:31:19.300
2023-12-08 08:31:19.300
2024-01-07 08:31:19.300
*/
--update [BPC].[adf_watermark]
--set last_processed_date = '2024-01-07 08:31:19.300'
--where tablename = 'BPAWorkQueueItem'