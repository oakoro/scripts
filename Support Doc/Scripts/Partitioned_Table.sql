/****** Script for SelectTopNRows command from SSMS  ******/


  --SELECT distinct
  --    (substring(format([ModifiedDate],'yyyyMMdd'),1,6)+'01')
  --FROM [HumanResources].[EmployeeDepartmentHistoryPTest]


--create partition function pf_date (datetime)
--as range right for values ('20060601','20070101','20071101','20071201',
--'20080101','20080201'
--,'20080301'
--,'20081101'
--,'20081201'
--,'20090101'
--,'20090201'
--,'20090301'
--,'20090501'
--,'20090701'
--,'20091201'
--,'20100101'
--,'20100201'
--,'20100301'
--,'20100501');

--select * from sys.partition_functions

--create partition scheme ps_date
--as partition pf_date
--all to ([PRIMARY])

--select * from sys.partition_schemes

  --alter partition function pf_date ()
  --  split range ('20090401')

--  CREATE TABLE [HumanResources].[EmployeeDepartmentHistoryPTest](
--	[BusinessEntityID] [int] NOT NULL,
--	[DepartmentID] [smallint] NOT NULL,
--	[ShiftID] [tinyint] NOT NULL,
--	[StartDate] [date] NOT NULL,
--	[EndDate] [date] NULL,
--	[ModifiedDate] [datetime] NOT NULL,
--) ON ps_date (ModifiedDate)
--GO

--alter table [HumanResources].[EmployeeDepartmentHistory]
--switch to [HumanResources].[EmployeeDepartmentHistoryPTest]

--alter table [HumanResources].[EmployeeDepartmentHistoryPTest]
--switch partition 10 to [HumanResources].[EmployeeDepartmentHistorySwitched]

--delete [HumanResources].[EmployeeDepartmentHistorySwitched]
--select count(*) from [HumanResources].[EmployeeDepartmentHistory]
--select count(*) from [HumanResources].[EmployeeDepartmentHistoryPTest]
--select * from [HumanResources].[EmployeeDepartmentHistoryPTest]

  SELECT distinct
      (substring(format([ModifiedDate],'yyyyMMdd'),1,6)+'01')
  FROM [HumanResources].[EmployeeDepartmentHistory]

--insert [HumanResources].[EmployeeDepartmentHistoryPTest]
--select * from [HumanResources].[EmployeeDepartmentHistory]
--where (substring(format([ModifiedDate],'yyyyMMdd'),1,6)+'01') in (SELECT distinct
--      (substring(format([ModifiedDate],'yyyyMMdd'),1,6)+'01')
--  FROM [HumanResources].[EmployeeDepartmentHistory])

SELECT
Partition_Number AS [Partition Number], Row_Count AS NumberofRows
FROM sys.dm_db_partition_stats
WHERE object_id = object_id('[HumanResources].[EmployeeDepartmentHistoryPTest]');

SELECT
Partition_Number AS [Partition Number], Row_Count AS NumberofRows
FROM sys.dm_db_partition_stats
WHERE object_id = object_id('[HumanResources].[EmployeeDepartmentHistory]');

--select * from [HumanResources].[EmployeeDepartmentHistoryPTest]
--where $PARTITION.pf_date(StartDate) = 3


select * from [HumanResources].[EmployeeDepartmentHistorySwitched]

  --alter partition function pf_date ()
  --  merge range ('20090401')