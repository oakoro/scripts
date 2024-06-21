select --rp.userroleid,rp.permid,
p.name'Permission',--p.treeid,--p.requiredFeature,
r.name 'UserRoleName', --r.ssogroup,ra.userid,
u.username,u.validfromdate,u.validtodate,u.isdeleted,u.lastsignedin,
pg.name 'PermissionGoup'
from 
dbo.BPAUserRolePerm rp join dbo.BPAPerm p on rp.permid = p.id
join dbo.BPAUserRole r on r.id = rp.userroleid
join dbo.BPAUserRoleAssignment ra on ra.userroleid = r.id
join dbo.BPAUser u on u.userid = ra.userid
join dbo.BPAPermGroupMember pgm on pgm.permid = p.id
join dbo.BPAPermGroup pg on pg.id = pgm.permgroupid
select top 1* from dbo.BPAUserRolePerm rp 
select top 1* from dbo.BPAPerm p 
select top 1* from dbo.BPAUserRole r 
select top 1* from dbo.BPAUserRoleAssignment ra
select top 1* from dbo.BPAUser u
select top 1* from dbo.BPAPermGroupMember pgm
select top 1* from dbo.BPAPermGroup pg