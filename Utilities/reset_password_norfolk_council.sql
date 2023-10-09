--UPDATE BPAPassword set
--salt='bWBTNqWrvq6RbQnns5PpF+Kt7V1gVS97F6R5iZIxV6M=',
--hash='9XkueyLzhbhRUMoKedsN3l7ChDmfS811IDymP8ZCEv8='
--where userid=(select userid from BPAUser where username='admin')
--and active=1; -- reset the admin password to 'admin'

--UPDATE BPAUser set passwordexpirydate=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1)
--where username='admin'; -- reset the admin expiry date

--select salt,hash from BPAPassword where userid=(select userid from BPAUser where username='admin')  and active=1;
--salt	hash
--QPSVOIhBeZfmz+BaJYZYGMDH2CLyTX7vfWpzrUb+JaQ=	SRy4dNqS9r7/7cUnqVX9ne4ehQbhjMIZKRNMCw12yKM=
--select * from BPAUser where username= 'admin'