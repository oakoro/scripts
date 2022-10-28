--delete top (10) from [HumanResources].[EmployeePayHistory] 
--output deleted.*
--into [HumanResources].[EmployeePayHistory1]

DECLARE @int int, @count int, @dategroup varchar(20)
DECLARE @table1 TABLE (BusinessEntityID int, [ModifiedDate] datetime)
DECLARE @table2 TABLE (DateGroup varchar(20),RecordCount int)
declare @minDate datetime, @cutTime datetime
select  @minDate = MIN([ModifiedDate]), @cutTime = (DATEADD(hh,3,@minDate)) from [HumanResources].EmployeePayHistory1 
--select @minDate, @cutTime
INSERT @table1
select BusinessEntityID,[ModifiedDate] from [HumanResources].EmployeePayHistory1 
where ModifiedDate BETWEEN @minDate AND @cutTime
INSERT @table2
SELECT CONVERT(VARCHAR(20),[ModifiedDate],103),COUNT(*) FROM  @table1
GROUP BY CONVERT(VARCHAR(20),[ModifiedDate],103)
SELECT @count = COUNT(*) FROM @table2
SET @int = 0
WHILE @int <= @count
BEGIN
SELECT TOP 1 @dategroup = DateGroup FROM @table2
delete from [HumanResources].[EmployeePayHistory1]
output deleted.*
into [HumanResources].[EmployeePayHistory]
 WHERE CONVERT(VARCHAR(20),[ModifiedDate],103) = @dategroup
DELETE @table2 WHERE DateGroup = @dategroup
WAITFOR DELAY '00:02:00';
SET @int = @int +1
END