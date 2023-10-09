while (select count(*) from [dbo].[BPASession]) < 100
begin
declare @starterresourceid nvarchar(100)  
SELECT TOP 1 @starterresourceid = [resourceid] FROM [rpa-database].[dbo].[BPAResource] ORDER BY NEWID()
select @starterresourceid
INSERT INTO [dbo].[BPASession]
           ([sessionid]
           ,[startdatetime]
           ,[enddatetime]
           ,[processid]
           ,[starterresourceid]
           ,[starteruserid]
           ,[runningresourceid]
           ,[runningosusername]
           ,[statusid]
           ,[startparamsxml]
           ,[logginglevelsxml]
           ,[sessionstatexml]
           ,[queueid]
           ,[stoprequested]
           ,[stoprequestack]
           ,[lastupdated]
           ,[laststage]
           ,[warningthreshold]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset]
           ,[lastupdatedtimezoneoffset])
     VALUES
           (NEWID()
           ,GETDATE()
           ,Null
           ,'740FEB4A-58B8-4376-931B-0197F16920C3'
           ,@starterresourceid
           ,'F4E80D39-38C8-49BF-8A34-E7442FA64993'
           ,'15B22D86-2054-4923-B552-65CF32AE59E8'
           ,Null
           ,4
           ,Null
           ,Null
           ,Null
           ,Null
           ,Null
           ,Null
           ,GETDATE()
           ,'Start'
           ,300
           ,3600
           ,3600
           ,3600)
end


