UPDATE BPAPassword set
salt='bWBTNqWrvq6RbQnns5PpF+Kt7V1gVS97F6R5iZIxV6M=',
hash='9XkueyLzhbhRUMoKedsN3l7ChDmfS811IDymP8ZCEv8='
where userid=(select userid from BPAUser where username='operator')
and active=1; -- reset the admin password to 'admin'

UPDATE BPAUser set passwordexpirydate=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)
where username='operator'; -- reset the admin expiry date