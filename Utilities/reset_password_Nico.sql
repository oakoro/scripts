UPDATE BPAPassword set
salt='bWBTNqWrvq6RbQnns5PpF+Kt7V1gVS97F6R5iZIxV6M=',
hash='9XkueyLzhbhRUMoKedsN3l7ChDmfS811IDymP8ZCEv8='
where userid=(select userid from BPAUser where username='admin')
and active=1; -- reset the admin password to 'admin'

--UPDATE BPAUser set passwordexpirydate=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)
--where username='operator'; -- reset the admin expiry date


--UPDATE BPAPassword set
--salt='bWBTNqWrvq6RbQnns5PpF+Kt7V1gVS97F6R5iZIxV6M=',
--hash='9XkueyLzhbhRUMoKedsN3l7ChDmfS811IDymP8ZCEv8='
--where userid=(select userid from BPAUser where username='admin')
--and active=1; -- reset the admin password to 'admin'

select *
from BPAPassword
where userid in (select userid from BPAUser where username in ('operator','admin'))
and active=1;
/*
Production
id	userid	active	type	salt	hash	lastuseddate
4	65D7203D-BAB5-49D0-AD8A-1561572F969A	1	1	WSOoUDwqTEZ529jCm32W/7Fa5V7WPaxW5iNX8lFwaGU=	+ehjXlSD2XDeEQdOyZBUR7QaRTBEtDdf0DWTyvQ3H2E=	NULL
5	0C5D1E51-83DD-4660-A92E-18393EDA9F0F	1	1	V7w0+tGycsNzoZNNZrX3NFgkPDvEo0UCQKlnx/Sgkb4=	JhQgZX46FS+RUWg6Hs/XACDy88lucQE1+23ofAhESfM=	NULL

Dev
id	userid	active	type	salt	hash	lastuseddate
4	65D7203D-BAB5-49D0-AD8A-1561572F969A	1	1	DQ7jYqPo1TBH63G2D/0eWFq/e1Jm74mSDtr0Xuy06Bg=	G5m0KBAiIGUB2gOcgNB+YlRHz247pzBmF855uKEiBbs=	NULL
5	0C5D1E51-83DD-4660-A92E-18393EDA9F0F	1	1	1U3UWohyX5eIWZza+auA8B8i0NIH7wTq6dnIiKtv/Tg=	9Aqg8igK48ay6rrcA0GwZvmCJs49VrAu5vF/2V6uOHs=	NULL
*/