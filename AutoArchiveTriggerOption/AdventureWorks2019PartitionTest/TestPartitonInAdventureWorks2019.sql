/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT top 2 --distinct datepart(year,TransactionDate),
--TransactionDate
    
--  FROM [AdventureWorks2019].[Production].[TransactionHistory]




--CREATE TABLE [Production].[TransactionHistoryOke](
--	[TransactionID] [int]  NOT NULL,
--	[ProductID] [int] NOT NULL,
--	[ReferenceOrderID] [int] NOT NULL,
--	[ReferenceOrderLineID] [int] NOT NULL,
--	[TransactionDate] [datetime] NOT NULL,
--	[TransactionType] [nchar](1) NOT NULL,
--	[Quantity] [int] NOT NULL,
--	[ActualCost] [money] NOT NULL,
--	[ModifiedDate] [datetime] NOT NULL,
-- ) on PS_TransactionHistory(TransactionDate)

--CREATE TABLE [Production].[TransactionHistoryOkeLeft](
--	[TransactionID] [int]  NOT NULL,
--	[ProductID] [int] NOT NULL,
--	[ReferenceOrderID] [int] NOT NULL,
--	[ReferenceOrderLineID] [int] NOT NULL,
--	[TransactionDate] [datetime] NOT NULL,
--	[TransactionType] [nchar](1) NOT NULL,
--	[Quantity] [int] NOT NULL,
--	[ActualCost] [money] NOT NULL,
--	[ModifiedDate] [datetime] NOT NULL,
-- ) on PS_TransactionHistoryLeft(TransactionDate)

--create partition function PF_TransactionHistory(datetime)
--as range right for values('2013-12-31','2014-12-31','2022-12-31')
--create partition function PF_TransactionHistoryLeft(datetime)
--as range left for values('2013-12-31','2014-12-31','2022-12-31')


--create partition scheme PS_TransactionHistory
--as partition PF_TransactionHistory all to ([primary])
--create partition scheme PS_TransactionHistoryLeft
--as partition PF_TransactionHistoryLeft all to ([primary])

--insert [Production].[TransactionHistoryOke]
--select * from [Production].[TransactionHistory]

--insert [Production].[TransactionHistoryOkeLeft]
--select * from [Production].[TransactionHistory]

--select datepart(year,TransactionDate), count(*)
--from [Production].[TransactionHistoryOke]
--group by datepart(year,TransactionDate)

--alter partition function PF_TransactionHistory()
--merge range('2015-12-31')