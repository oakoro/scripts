declare @user sysname = 'testme'
declare @sql nvarchar(200)

--set @sql = 'if exists (select user_id('''+@user+''''+'))
--drop user '+quotename(@user)
--print @sql

execute ('if exists (select user_id('''+@user+''''+'))
drop user ['+@user+']')

