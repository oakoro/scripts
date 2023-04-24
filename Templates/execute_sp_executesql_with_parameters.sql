declare @toplogid int, @str nvarchar(400), @parameterdef nvarchar(400)

set @str = N'select top  1 @toplogidOut = logid from BPASessionLog_NonUnicode'
set @parameterdef = N'@toplogidOut int output';
execute sp_executesql @str, @parameterdef, @toplogidOut = @toplogid output
select @toplogid 'TopLogid'