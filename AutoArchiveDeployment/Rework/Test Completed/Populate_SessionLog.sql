USE [okedbtest]
GO

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
           (1
           ,'DC8E4FAA-326C-461D-89B2-9D965B7DD09A'
           ,'TESTINGEND12'
           ,1025
           ,'Login'
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
GO


select top 1* from [dbo].[BPASessionLog_NonUnicode] order by logid desc