DECLARE @ManagedID Sysname = 'BPC-DataFactory-ligfd66ykhhtq'
SELECT --DISTINCT pr.principal_id, pr.name AS [UserName], pr.type_desc AS [User_or_Role], pr.authentication_type_desc AS [Auth_Type], 
    o.[name] AS 'Object',o.type_desc, pe.class_desc,pe.permission_name,pe.state_desc
    FROM sys.database_principals AS pr 
    JOIN sys.database_permissions AS pe ON pe.grantee_principal_id = pr.principal_id
    LEFT JOIN sys.objects AS o on (o.object_id = pe.major_id)
	WHERE pr.type_desc = 'EXTERNAL_USER' AND o.[name] IS NOT NULL AND pr.name = @ManagedID
	ORDER BY o.[name]--,pe.permission_name


	--select * from sys.objects