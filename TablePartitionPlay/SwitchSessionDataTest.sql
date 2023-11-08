USE [okedbtest]
GO

INSERT INTO [dbo].[BPASessionLog_NonUnicodeSwitchTest]
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
           ,[endtimezoneoffset]
           ,[attributesize])
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
           ,'2023-11-08 16:58:04.400'
           ,NULL
           ,NULL
           ,NULL
           ,0
           ,3600
           ,0
           ,0)
GO

select * from [dbo].[BPASessionLog_NonUnicodeRetain]

alter table [dbo].[BPASessionLog_NonUnicodeRetain] switch to [dbo].[BPASessionLog_NonUnicode] partition 1

--alter table [dbo].[BPASessionLog_NonUnicodeRetain]
--add constraint cslogid check (logid >= 2 and logid < 9) 
