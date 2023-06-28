SELECT     coalesce(Obj.type_desc, class_desc) as Type, coalesce(Obj.name, db_name()) AS What, [Perm].state_desc, [Perm].permission_name, who.name AS who FROM         sys.database_permissions AS [Perm] INNER JOIN          sys.database_principals AS who ON [Perm].grantee_principal_id = who.principal_id LEFT OUTER JOIN                       sys.all_objects AS Obj ON [Perm].major_id = Obj.object_id WHERE     ([Perm].major_id >= 0) and (Obj.is_ms_shipped = 0 or class_desc = 'DATABASE') order by class, type, who.name