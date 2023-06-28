--create login testme with password = 'wr%K2ytts'
--create user testme from login testme

--select * from sys.sysusers where name = 'testme'

declare @user sysname = 'testme'
declare @sql nvarchar(200)

set @sql =
'if exists (select user_id('+''''+ @user+'''))
begin
drop user '+ quotename(@user)+'
end'
print (@sql)
exec (@sql)

