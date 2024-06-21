select * from sys.partitions
where OBJECT_NAME(object_id) = 'BPAAuditEvents'--18478

SELECT [eventdatetime]
      ,[eventid]
      ,isnull(datalength([comments]),0) [comments]
      ,isnull(datalength([EditSummary]),0) [EditSummary]
      ,isnull(datalength([oldXML]),0) [oldXML]
      ,isnull(datalength([newXML]),0) [newXML]
  FROM [dbo].[BPAAuditEvents] 