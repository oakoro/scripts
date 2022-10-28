declare @avg int, @high int, @low int
declare @tbl1 table ([ProductID] int,[TotalQuantity] int);
declare @tbl2 table ([ProductID] int,[TotalQuantity] int);
declare @tbl3 table ([ProductID] int,[TotalQuantity] int);
  insert @tbl1([ProductID],[TotalQuantity])
  SELECT 
      [ProductID]
     
      ,sum([Quantity])'TotalQty'
      
  FROM [Production].[TransactionHistoryCopyTest]
  group by [ProductID];
 insert @tbl2
 select top 50* from @tbl1 --where [TotalQuantity] > 50000 
 order by [TotalQuantity] 

  --select top 1 [TotalQuantity] from @tbl2 order by [TotalQuantity]
  --select * from @tbl2 order by [TotalQuantity] desc
  --select max([TotalQuantity]),min([TotalQuantity]),avg([TotalQuantity]) from @tbl2
   
  set @high = 
  (select top (1)  [TotalQuantity] from @tbl2 order by [TotalQuantity] desc) 
  select @high
  if @high <= 10000
  begin
  insert @tbl3
  select top 50* from @tbl2 
  end
  if @high between 10000 and 20000
   begin
     insert @tbl3
  select top 25* from @tbl2
  end
if @high between 20000 and 50000
   begin
     insert @tbl3
  select top 10* from @tbl2
  end
  if @high between 50000 and 100000
   begin
     insert @tbl3
  select top 4* from @tbl2
  end
  if @high > 100000
   begin
     insert @tbl3
  select top 2* from @tbl2 
  end
  select * from @tbl3;
  --delete [Production].[TransactionHistoryCopyTest]
  --where productid in (select productid from @tbl3 ) ;
 

  


