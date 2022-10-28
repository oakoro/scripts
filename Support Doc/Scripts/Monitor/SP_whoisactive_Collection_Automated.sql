SET NOCOUNT ON;
DECLARE @Count INT = 0
WHILE @Count < 5
BEGIN
DECLARE @destination_table VARCHAR(500) = 'mon_WhoIsActive',
        @schema VARCHAR(MAX),
        @SQL NVARCHAR(4000),
        @parameters NVARCHAR(500),
        @exists BIT;
 
SET @destination_table = @destination_table;
 
--create the logging table
IF OBJECT_ID(@destination_table) IS NULL
    BEGIN;
        EXEC dbo.sp_WhoIsActive @get_transaction_info = 1,
                                @get_outer_command = 1,
                                @get_plans = 1,
                                @return_schema = 1,
                                @schema = @schema OUTPUT;
        SET @schema = REPLACE(@schema, '<table_name>', @destination_table);
        EXEC ( @schema );
    END;

--collect activity into logging table
EXEC dbo.sp_WhoIsActive @get_transaction_info = 1,
                        @get_outer_command = 1,
                        @get_plans = 1,
                        @destination_table = @destination_table;

WAITFOR DELAY '00:00:05' -- Alter as applicable 
SET @Count = @Count + 1
END