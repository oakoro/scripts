DECLARE

     @username  SYSNAME         = N'BPC-AZ-Automation'

    ,@cmd       NVARCHAR(MAX)



	
        

BEGIN TRY

        -- Allow execute Stored Procedure

        BEGIN

        SELECT @cmd = 'GRANT EXECUTE ON SCHEMA::[BPC] TO ' + QUOTENAME(@username) + ';'

        --EXEC(@cmd)
		print @cmd

        END

END TRY




BEGIN CATCH

   SELECT ERROR_MESSAGE() AS [Error Message]

         ,ERROR_LINE() AS ErrorLine

         ,ERROR_NUMBER() AS [Error Number]  

         ,ERROR_SEVERITY() AS [Error Severity]  

         ,ERROR_STATE() AS [Error State]  

END CATCH