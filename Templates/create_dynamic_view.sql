declare @viewname varchar(400), @viewstr nvarchar(max)
set @viewname = 'viewtest'
set @viewstr = '
create or alter view [dbo].[viewtest]
as
SELECT getdate() as ''DateNow''
  '
if not exists (select name from sys.views where name = @viewname)
begin
EXECUTE sp_executesql @viewstr
end

