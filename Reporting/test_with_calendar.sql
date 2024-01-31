--select DATEPART(hh,TimeStamp) , count(*) from [dbo].[PartitionAuditLog]
--group by DATEPART(hh,TimeStamp) 

--select * from [dbo].[PartitionAuditLog]


declare @PartitionAuditLog TABLE(
   stepNo int,    
   ActionPerformed NVARCHAR(2000),
   TimeStamp     DATETIME
   )
insert @PartitionAuditLog
select * from [dbo].[PartitionAuditLog]
--exec sp_ReadErrorLog 0, 1, 'deadlock' --try this to see deadlocks per hour 
--exec sp_ReadErrorLog 0, 1, 'error'  --try this to see errors per hour

--Inspect the Results
select * from @PartitionAuditLog

--Results with missing dates
SELECT DateAdd(Hour,DateDiff(Hour,'19000101',e.TimeStamp),'19000101') as [TimeStamp], 
   COUNT(e.TimeStamp) as [Occurrences]
FROM @PartitionAuditLog e 
GROUP BY DateAdd(Hour,DateDiff(Hour,'19000101',e.TimeStamp),'19000101')
ORDER BY [TimeStamp]


SELECT t.Datelist, COUNT(e.TimeStamp) as [Occurrences]
FROM dbo.Get_DateList_uft('Hour','2019-05-28 00:00:00',NULL) t
   LEFT JOIN @PartitionAuditLog e 
      ON t.Datelist = DateAdd(Hour,DateDiff(Hour,'19000101',e.TimeStamp),'19000101')
GROUP BY t.Datelist
ORDER BY t.Datelist 
GO