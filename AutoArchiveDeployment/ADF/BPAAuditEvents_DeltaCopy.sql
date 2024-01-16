SELECT * FROM [dbo].[BPAAuditEvents] 
WHERE DATEPART(DAY,[eventdatetime]) =  DATEPART(DAY,GETDATE()-1) 