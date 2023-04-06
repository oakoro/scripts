select 'Test'+substring(convert(varchar(255),NEWID()),1,4)

--select * from [dbo].[customers]

declare @count int, @int int
select @count = count(*) from [dbo].[customers]


while @count < 50000
begin
insert [dbo].[customers](name)
select 'Test'+substring(convert(varchar(255),NEWID()),1,4) 
select @count = count(*) from [dbo].[customers] 
end