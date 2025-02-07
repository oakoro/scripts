SELECT     coalesce(Obj.type_desc, class_desc) as Type, coalesce(Obj.name, db_name()) AS What, [Perm].state_desc, 
[Perm].permission_name, who.name AS who FROM         sys.database_permissions AS [Perm] INNER JOIN          
sys.database_principals AS who ON [Perm].grantee_principal_id = who.principal_id LEFT OUTER JOIN                       
sys.all_objects AS Obj ON [Perm].major_id = Obj.object_id 
WHERE     ([Perm].major_id >= 0) and (Obj.is_ms_shipped = 0 or class_desc = 'DATABASE') order by  what,who.name




Select P.name As Principal,
	class_desc As PermissionLevel,
	permission_name As PermissionGranted,
	ObjectName = Case class When 0 Then DB_NAME()
		When 1 Then OBJECT_SCHEMA_NAME(major_id) + N'.' + OBJECT_NAME(major_id)
		End
From sys.database_permissions As DP
Inner Join sys.database_principals As P On P.principal_id = DP.grantee_principal_id
Where permission_name In ('insert', 'update', 'delete', 'control', 'alter')
And state = 'G';


Select P1.name As Principal,
	P2.name As DBRole
From sys.database_principals As P1
Inner join sys.database_role_members As RM On RM.member_principal_id = P1.principal_id
Inner join sys.database_principals As P2 On P2.principal_id = RM.role_principal_id