DECLARE
	 @username	SYSNAME			= N'__sqlUserMI__'
	,@createuser		NVARCHAR(300), @grantaccess NVARCHAR(300)

BEGIN TRY
		-- Grant Managed Identity access to Production Database
		BEGIN
		SELECT @createuser = 'CREATE USER ' + QUOTENAME(@username) + ' FROM EXTERNAL PROVIDER;'
		SELECT @grantaccess = 'GRANT EXECUTE,INSERT,SELECT,UPDATE ON SCHEMA::[BPC] TO ' + QUOTENAME(@username) + ';'
		EXEC (@createuser)
		EXEC (@grantaccess)
		END
END TRY

BEGIN CATCH
   SELECT ERROR_MESSAGE() AS [Error Message]
         ,ERROR_LINE() AS ErrorLine
         ,ERROR_NUMBER() AS [Error Number]  
         ,ERROR_SEVERITY() AS [Error Severity]  
         ,ERROR_STATE() AS [Error State]  
END CATCH
			
BEGIN TRY
		-- Deny access to the License Table
		BEGIN
		SELECT @grantaccess = 'DENY ALTER, SELECT, INSERT, UPDATE, DELETE, TAKE OWNERSHIP ON OBJECT::dbo.BPALicense TO ' + QUOTENAME(@username) + ';'
		EXEC (@grantaccess)
		END
END TRY

BEGIN CATCH
   SELECT ERROR_MESSAGE() AS [Error Message]
         ,ERROR_LINE() AS ErrorLine
         ,ERROR_NUMBER() AS [Error Number]  
         ,ERROR_SEVERITY() AS [Error Severity]  
         ,ERROR_STATE() AS [Error State]  
END CATCH

BEGIN TRY
		-- Deny access to LicenseKey Column within the the License Table
		BEGIN
		SELECT @grantaccess = 'DENY ALTER, SELECT, UPDATE (licensekey) ON OBJECT::dbo.BPALicense TO ' + QUOTENAME(@username) + ';'   
		EXEC (@grantaccess)
		END

END TRY

BEGIN CATCH
   SELECT ERROR_MESSAGE() AS [Error Message]
         ,ERROR_LINE() AS ErrorLine
         ,ERROR_NUMBER() AS [Error Number]  
         ,ERROR_SEVERITY() AS [Error Severity]  
         ,ERROR_STATE() AS [Error State]  
END CATCH

		-- Grant select and delete access to sessionlog tables
BEGIN TRY		
	DECLARE @tblName SYSNAME
	DECLARE tbl_cur CURSOR FOR
		SELECT name
		FROM sys.tables
		WHERE name IN ('BPAProcess'
						,'BPAResource'
						,'BPASession'
						,'BPASessionLog_NonUnicode'
						,'BPASessionLog_Unicode'
						,'BPAWorkQueue'
						,'BPAWorkQueueItem'
						,'BPAWorkQueueItemTag'
						,'BPATag'
						,'BPAAuditEvents'
						,'BPAEnvironmentVar'
						,'BPAProcessEnvironmentVarDependency'
						,'BPARelease'
						,'BPAUser'
		)

	OPEN tbl_cur
	FETCH NEXT FROM tbl_cur INTO @tblName

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		SELECT @grantaccess = 'GRANT SELECT ON ' + QUOTENAME(@tblName) + ' TO ' + QUOTENAME(@username) + ';' 
		EXEC(@grantaccess)
		FETCH NEXT FROM tbl_cur INTO @tblName
	END

	DEALLOCATE tbl_cur

END TRY

BEGIN CATCH
   SELECT ERROR_MESSAGE() AS [Error Message]
         ,ERROR_LINE() AS ErrorLine
         ,ERROR_NUMBER() AS [Error Number]  
         ,ERROR_SEVERITY() AS [Error Severity]  
         ,ERROR_STATE() AS [Error State]  
END CATCH