SELECT TOP (1000) [id]
      ,[writesessionlogstodatabase]
      ,[emitsessionlogstodatagateways]
      ,[monitoringfrequency]
      ,[sendpublisheddashboardstodatagateways]
      ,[sendworkqueueanalysistodatagateways]
      ,[serverPort]
      ,[databaseusercredentialname]
      ,[useIntegratedSecurity]
  FROM [dbo].[BPADataPipelineSettings]


  --update [dbo].[BPADataPipelineSettings]
  --set emitsessionlogstodatagateways = 0
