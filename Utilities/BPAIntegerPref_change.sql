select value from dbo.BPAIntegerPref
where prefid in (

select id from dbo.BPAPref where name = 'resourceconnection.tokentimeout')


select * from dbo.BPAIntegerPref  i join  dbo.BPAPref p on i.prefid = p.id
where p.name = 'resourceconnection.tokentimeout'

--update i
--set i.value = 60
--from dbo.BPAIntegerPref  i join  dbo.BPAPref p on i.prefid = p.id
--where p.name = 'resourceconnection.tokentimeout'
 




