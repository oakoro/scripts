--select top 1* into FactProductInventoryTest from FactProductInventory

declare @tbl table (StartProductkey int)
declare @endTransactionID int, @currentTransactionID int
select top 1 @endTransactionID = TransactionID from [Production].[TransactionHistory]
order by [TransactionID] desc
if exists (select 1 from [Production].[TransactionHistoryArchive])
begin
select top 1 @currentTransactionID = [TransactionID] from [Production].[TransactionHistoryArchive]
order by TransactionID desc 
end
else set @currentTransactionID = 0
select @endTransactionID'endkey',@currentTransactionID'currentTransactionID'

while @currentTransactionID < 100099--@endProductkey
begin
--set identity_insert FactProductInventoryTest ON
INSERT INTO [Production].[TransactionHistoryArchive]
           ([TransactionID]
           ,[ProductID]
           ,[ReferenceOrderID]
           ,[ReferenceOrderLineID]
           ,[TransactionDate]
           ,[TransactionType]
           ,[Quantity]
           ,[ActualCost]
           ,[ModifiedDate])
select top 10 [TransactionID]
           ,[ProductID]
           ,[ReferenceOrderID]
           ,[ReferenceOrderLineID]
           ,[TransactionDate]
           ,[TransactionType]
           ,[Quantity]
           ,[ActualCost]
           ,[ModifiedDate] from [Production].[TransactionHistory]
		   where [TransactionID] > @currentTransactionID
		   order by [TransactionID] 
--set identity_insert FactProductInventoryTest OFF
select top 1 @currentTransactionID = [TransactionID] from [Production].[TransactionHistoryArchive]
order by TransactionID desc 
end

