/****** Script for SelectTopNRows command from SSMS  ******/
while (
SELECT count(*)
  FROM [dbo].[BPASessionLog_NonUnicodeOke]) < 1000000
begin
insert [dbo].[BPASessionLog_NonUnicodeOke](
[sessionnumber]
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
      --,[attributesize]
	  )
SELECT TOP 100000 [sessionnumber]
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
      --,[attributesize]
  FROM [dbo].[BPASessionLog_NonUnicodeOke]
  ORDER BY NEWID()
end

