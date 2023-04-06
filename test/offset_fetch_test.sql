declare @page int, @pagesize int
set @page = 0
set @pagesize = 10
--select id,name,ROW_NUMBER() over (order by name) as RowNum  from [dbo].[customers]
--order by RowNum
--offset @page rows fetch first @pagesize rows only

select id,name  from [dbo].[customers]
order by name
offset @page rows fetch first @pagesize rows only
