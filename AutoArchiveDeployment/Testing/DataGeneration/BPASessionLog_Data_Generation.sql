IF (SELECT @@SERVERNAME) = 'bpc-sql-x2hpo4kjv2qaa'
WHILE (SELECT COUNT(*) FROM [dbo].[BPASessionLog_NonUnicode]) < 1000
BEGIN
DECLARE @sNum int, @stagename NVARCHAR(200), @processname NVARCHAR(50)
SELECT TOP 1 @sNum = sessionnumber FROM [dbo].[BPASession] ORDER BY NEWID()
SELECT @stagename = CHOOSE ( FLOOR(RAND()*3)+1, 'Acquire Lock', 'Activate', 'Add Column: Publication Date', 'Add Unsuccessful to Queue',
						'Add To Queue','Add Winners to Queue','Append Index Column','Append Rows to Collection Final Results');
SELECT @processname = name FROM [dbo].[BPAProcess] p JOIN [dbo].[BPASession] s ON p.processid = s.processid WHERE s.sessionnumber = @sNum

--select @sNum, @stagename
INSERT INTO [dbo].[BPASessionLog_NonUnicode]
           ([sessionnumber]
           ,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[enddatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
           ,[endtimezoneoffset])
     VALUES
           (@sNum
           ,NEWID()
           ,@stagename
           ,NULL
           ,@processname
           ,'Main'
           ,'Page2'
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,getdate()
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,3600
           ,0)
END




