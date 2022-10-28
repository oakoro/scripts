DECLARE @ManagedID Sysname 

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE type = 'E' and name like '%DataFactory%')
	BEGIN
	SELECT TOP 1 @ManagedID =  name FROM sys.database_principals WHERE type = 'E' AND name LIKE '%DataFactory%'
	SELECT 
    @@servername'ServerName',DB_NAME()'DatabaseName',@ManagedID'UserName',o.[name] AS 'Object',o.type_desc, pe.class_desc,pe.permission_name,pe.state_desc
    FROM sys.database_principals AS pr 
    JOIN sys.database_permissions AS pe ON pe.grantee_principal_id = pr.principal_id
    LEFT JOIN sys.objects AS o on (o.object_id = pe.major_id)
	WHERE --pr.type_desc = 'EXTERNAL_USER' AND o.[name] IS NOT NULL AND 
	pr.name = @ManagedID AND  o.[name] IS NOT NULL
	ORDER BY o.[name]--,pe.permission_name
	END
	ELSE
	SELECT 'Datafactory Managed Identity does not exist'

	

	
