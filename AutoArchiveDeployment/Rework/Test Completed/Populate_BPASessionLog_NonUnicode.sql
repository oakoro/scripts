while (select count(*) from [dbo].[BPASessionLog_NonUnicode]) < 100
begin
declare @sNum int, @stagename nvarchar(200)
select top 1 @sNum = sessionnumber from [dbo].[BPASession] order by NEWID()
  SELECT @stagename = CHOOSE ( FLOOR(RAND()*3)+1, 'Add Missing Hyperlink Exception', 'Add row to temp data', 'Add to AD Group', 'Add to power app/shareforms' );

select @sNum, @stagename
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
end




