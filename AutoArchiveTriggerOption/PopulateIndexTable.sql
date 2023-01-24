

INSERT INTO [dbo].[bpsessionlogPartitionTest]
           ([sessionnumber]
           --,[stageid]
           ,[stagename]
           ,[stagetype]
           ,[processname]
           ,[pagename]
           ,[objectname]
           ,[actionname]
           ,[result]
           ,[resulttype]
           ,[startdatetime]
           ,[attributexml]
           ,[automateworkingset]
           ,[targetappname]
           ,[targetappworkingset]
           ,[starttimezoneoffset]
          -- ,[endtimezoneoffset]
		  )

SELECT top 200 [sessionnumber]
      --,[stageid]
      ,[stagename]
      ,[stagetype]
      ,[processname]
      ,[pagename]
      ,[objectname]
      ,[actionname]
      ,[result]
      ,[resulttype]
      ,[startdatetime]
      ,[attributexml]
      ,[automateworkingset]
      ,[targetappname]
      ,[targetappworkingset]
      ,[starttimezoneoffset]
      --,nullif([endtimezoneoffset],0)
  FROM [dbo].[sessionlog_partitioned]




