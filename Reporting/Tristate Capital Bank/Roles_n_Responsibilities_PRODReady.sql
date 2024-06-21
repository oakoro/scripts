CREATE VIEW BPC.vw_GenerateRolesReport
AS
SELECT 
u.username 'UserName',
p.name'Permission',
r.name 'UserRole', 
pg.name 'PermissionGoup',
CASE WHEN u.isdeleted = 0 THEN 'Active' ELSE 'Not Active' END 'UserStatus'
FROM 
dbo.BPAUserRolePerm rp join dbo.BPAPerm p on rp.permid = p.id
JOIN dbo.BPAUserRole r on r.id = rp.userroleid
JOIN dbo.BPAUserRoleAssignment ra on ra.userroleid = r.id
JOIN dbo.BPAUser u on u.userid = ra.userid
JOIN dbo.BPAPermGroupMember pgm on pgm.permid = p.id
JOIN dbo.BPAPermGroup pg on pg.id = pgm.permgroupid
WHERE u.username IS NOT NULL

