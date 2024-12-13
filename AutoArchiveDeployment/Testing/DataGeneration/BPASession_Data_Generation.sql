IF (SELECT @@SERVERNAME) = 'bpc-sql-x2hpo4kjv2qaa'
BEGIN
WHILE (SELECT COUNT(*) FROM [dbo].[BPASession]) < 10
BEGIN
DECLARE @starterresourceid NVARCHAR(50),@processid NVARCHAR(50), @starteruserid NVARCHAR(50),
		@statusid TINYINT, @laststage NVARCHAR(50)
SELECT TOP 1 @starterresourceid = [resourceid] FROM [dbo].[BPAResource] ORDER BY NEWID()
SELECT TOP 1 @processid = [processid] FROM [dbo].[BPAProcess] ORDER BY NEWID()
SELECT TOP 1 @starteruserid = [userid] FROM [dbo].[BPAUser] ORDER BY NEWID()
SELECT TOP 1 @statusid = [statusid] FROM [dbo].[BPAStatus] ORDER BY NEWID()
SELECT @laststage = CHOOSE ( FLOOR(RAND()*3)+1, 'Acquire Lock', 'Activate', 'Add Column: Publication Date', 'Add Unsuccessful to Queue',
						'Add To Queue','Add Winners to Queue','Append Index Column','Append Rows to Collection Final Results');
--select @starterresourceid,@processid,@starteruserid,@statusid,@laststage
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
           ,@processid
           ,@starterresourceid
           ,@starteruserid
           ,@starterresourceid
           ,Null
           ,@statusid
           ,Null
           ,Null
           ,Null
           ,Null
           ,Null
           ,Null
           ,GETDATE()
           ,@laststage
           ,300
           ,3600
           ,3600
           ,3600)
END

END