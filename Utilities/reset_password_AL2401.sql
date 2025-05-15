--UPDATE BPAPassword set
--salt='bWBTNqWrvq6RbQnns5PpF+Kt7V1gVS97F6R5iZIxV6M=',
--hash='9XkueyLzhbhRUMoKedsN3l7ChDmfS811IDymP8ZCEv8='
--where userid=(select userid from BPAUser where username='operator')
--and active=1; -- reset the admin password to 'admin'

--UPDATE BPAUser set passwordexpirydate=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)
--where username='operator'; -- reset the admin expiry date



select * from BPAPassword where userid = 'ED865FD9-1C6A-4272-97FF-791F2C2A232E'
/*
id	userid	active	type	salt	hash	lastuseddate
5	ED865FD9-1C6A-4272-97FF-791F2C2A232E	1	1	Wock7zIYRphpu9bN3Eokj09ajX/TkHhr5tdLb7Uf4Co=	tJgMFe6dKry8cD8MQ/lLqop8uHf6fMdG4FbiNHGtojk=	NULL
*/
select DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0),* from BPAUser
