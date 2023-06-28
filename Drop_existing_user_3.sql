declare @user sysname = 'testme'


execute ('if exists (select user_id('''+@user+''''+'))
drop user ['+@user+']')

