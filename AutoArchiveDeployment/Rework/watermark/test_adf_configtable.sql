/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [sourceschema]
      ,[sourcetable]
      ,[sinkfolder]
  FROM [BPC].[adf_configtable]

  --INSERT [BPC].[adf_configtable]
  --VALUES ('BPC','BPATest','BPATest')

  --DELETE [BPC].[adf_configtable]
  --WHERE [sourcetable] IN ('BPATag','BPAResource','BPAUser')