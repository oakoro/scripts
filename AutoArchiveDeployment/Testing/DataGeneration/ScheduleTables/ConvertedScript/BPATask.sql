/****** Script for SelectTopNRows command from SSMS  ******/

set identity_insert [dbo].[BPATask] on
insert [dbo].[BPATask] ([id]
      ,[scheduleid]
      ,[name]
      ,[description]
      ,[onsuccess]
      ,[onfailure]
      ,[failfastonerror]
      ,[delayafterend])
SELECT TOP (1000) convert(int,[id])
      ,convert(int,[scheduleid])
      ,[name]
      ,[description]
      ,convert(int,replace([onsuccess],'NULL','0'))--[onsuccess]
      ,convert(int,replace([onfailure],'NULL','0'))--[onfailure]
      ,convert(bit,[failfastonerror])
      ,convert(int,[delayafterend])
  FROM [dbo].[bpataskNew]

  set identity_insert [dbo].[BPATask] off  