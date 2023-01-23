CREATE PROC dbo.SlideRangeRightWindow_datetime

        @RetentionDays int,

        @RunDate datetime = NULL

/*      This proc maintains a RANGE RIGHT daily sliding window

      based on the specified @RetentionDays.  It is intended to

      be scheduled daily shortly after midnight. In addition to

      purging old data, the partition function is adjusted to

      account for scheduling issues or changes in @RetentionDays.

 

      Partitions are split and merged so that the first partition

      boundary is the oldest retained data date and the last

      boundary is the next day.  Other partitions contain current 

      and historical data for the specifiednumber of @RetentionDays.  

 

      After successful execution, (at least) the following

      partitions will exist: 

      - partition 1 = data older than retained date (empty)

      - other partitions = hitorical data (@RunDate - 1 and earlier)

      - second from last partition = current data (@RunDate)

      - last partition = future data (@RunDate + 1) (empty)      

 

*/

 

AS

 

SET NOCOUNT, XACT_ABORT ON;

 

DECLARE

        @Error int,

        @RowCount bigint,

        @ErrorLine int,

        @Message varchar(255),

        @OldestRetainedDate datetime,

        @PartitionBoundaryDate datetime;

 

SET @Error = 0;

 

BEGIN TRY

 

      IF @RunDate IS NULL

      BEGIN

            /*use current date (midnight) if no date specified*/

            SET @RunDate =  DATEADD(day, 0, DATEDIFF(day, '', GETDATE()));

      END

      ELSE

      BEGIN

            /*set time to midnight of specified date*/

            SET @RunDate = DATEADD(day, 0, DATEDIFF(day, '', @RunDate));

      END

      

      /*calculate oldest retention date based on @RetentionDays and @RunDate*/

      SET @OldestRetainedDate = DATEADD(day, @RetentionDays * -1, @RunDate);

 

      SET @Message = 

            'Run date = ' +

            + CONVERT(varchar(23), @RunDate, 121)

            + ', Retention days = '

            + CAST(@RetentionDays AS varchar(10))

            + ', Oldest retained data date = '

            + CONVERT(varchar(23), @OldestRetainedDate, 121);

 

      RAISERROR (@Message, 0, 1) WITH NOWAIT;

 

      BEGIN TRAN;

 

      /*acquire exclusive table lock to prevent deadlocking with concurrent activity.*/

      SELECT TOP 1 @error = 0

      FROM dbo.MyPartitionedTable WITH (TABLOCKX, HOLDLOCK);

 

      /*make sure we have a boundary for oldest retained period*/

      IF NOT EXISTS(

            SELECT prv.value

            FROM sys.partition_functions AS pf

            JOIN sys.partition_range_values AS prv ON

                  prv.function_id = pf.function_id

            WHERE

                  pf.name = 'PF_MyPartitionFunction'

                  AND CAST(prv.value AS datetime) = @OldestRetainedDate

            )

      BEGIN

            ALTER PARTITION SCHEME PS_MyPartitionScheme

                    NEXT USED [PRIMARY];

            ALTER PARTITION FUNCTION PF_MyPartitionFunction()

                    SPLIT RANGE(@OldestRetainedDate);

            SET @Message = 

                    'Created boundary for oldest retained data ('

                    + CONVERT(varchar(30), @OldestRetainedDate, 121) + ')';

 

            RAISERROR(@Message, 0, 1) WITH NOWAIT;

      END

      ELSE

      BEGIN

            SET @Message = 

                    'Oldest retained data boundary already exists ('

                    + CONVERT(varchar(30), @OldestRetainedDate, 121) + ')';

 

            RAISERROR(@Message, 0, 1) WITH NOWAIT;

      END

        

      /*get earliest expired boundary*/

      SET @PartitionBoundaryDate = NULL;

      SELECT

            @PartitionBoundaryDate = 

                    MIN(CAST(prv.value AS datetime))

      FROM sys.partition_functions AS pf

      JOIN sys.partition_range_values AS prv ON

            prv.function_id = pf.function_id

      WHERE

            pf.name = 'PF_MyPartitionFunction'

            AND CAST(prv.value AS datetime) < @OldestRetainedDate;

 

      /*get rowcount of first partition*/

      SELECT @RowCount = rows

      FROM sys.partitions

      WHERE

            object_id = OBJECT_ID(N'dbo.MyPartitionedTable') 

            AND partition_number = 1

            AND index_id IN(0, 1);

 

      /*purge data from first partition if not empty*/

      IF @RowCount > 0

      BEGIN

            TRUNCATE TABLE dbo.MyPartitionedTable_Staging;

            ALTER TABLE dbo.MyPartitionedTable SWITCH PARTITION 1

                    TO dbo.MyPartitionedTable_Staging PARTITION 1;

            TRUNCATE TABLE dbo.MyPartitionedTable_Staging;

            SET @Message = 

                    'Purged data older than '

                    + CONVERT(varchar(23), @PartitionBoundaryDate, 121)

                    + ' (' + CAST(@RowCount as varchar(20)) + ' rows)';

            RAISERROR(@Message, 0, 1) WITH NOWAIT;

      END

      ELSE

      BEGIN

            SET @Message = 

                    'First partition is empty.  No data older than '

                    + CONVERT(varchar(23), @OldestRetainedDate, 121); 

            RAISERROR(@Message, 0, 1) WITH NOWAIT;    

      END

 

      /*Switch and merge expired data partitions, starting with the earliest*/

      WHILE @PartitionBoundaryDate < @OldestRetainedDate

      BEGIN

      

            /*get count of rows to be purged*/

            SELECT @RowCount = rows

            FROM sys.partitions

            WHERE

                    object_id = OBJECT_ID(N'MyPartitionedTable') 

                    AND partition_number = $PARTITION.PF_MyPartitionFunction(@PartitionBoundaryDate)

                    AND index_id IN(0, 1);      

 

            /*purge data, if needed*/

            IF @RowCount > 0

            BEGIN

                  /*move data to staging table*/

                  TRUNCATE TABLE dbo.MyPartitionedTable_Staging;

                  ALTER TABLE dbo.MyPartitionedTable SWITCH PARTITION $PARTITION.PF_MyPartitionFunction(@PartitionBoundaryDate)

                          TO dbo.MyPartitionedTable_Staging PARTITION $PARTITION.PF_MyPartitionFunction(@PartitionBoundaryDate);

                          

                    

                  /*purge data from staging table*/

                  TRUNCATE TABLE dbo.MyPartitionedTable_Staging;

                  SET @Message = 

                          'Purged data for boundary '

                          + CONVERT(varchar(23), @PartitionBoundaryDate, 121) 

                          + ' (' + CAST(@RowCount as varchar(20)) + ' rows)';

                  RAISERROR(@Message, 0, 1) WITH NOWAIT;

            END

            ELSE

            BEGIN

                  SET @Message = 

                          'Partition for boundary '

                          + CONVERT(varchar(23), @PartitionBoundaryDate, 121)

                          + ' is empty';

                  RAISERROR(@Message, 0, 1) WITH NOWAIT;          

            END

          

            /*remove purged partition*/

            ALTER PARTITION FUNCTION PF_MyPartitionFunction() 

                  MERGE RANGE(@PartitionBoundaryDate);

            SET @Message = 

                  'Removed boundary '

                  + CONVERT(varchar(30), @PartitionBoundaryDate, 121);

 

            RAISERROR(@Message, 0, 1) WITH NOWAIT;

 

            /*get earliest boundary before retention date for next iteration*/

            SET @PartitionBoundaryDate = NULL;

            SELECT

                  @PartitionBoundaryDate = 

                          MIN(CAST(prv.value AS datetime))

            FROM sys.partition_functions AS pf

            JOIN sys.partition_range_values AS prv ON

                  prv.function_id = pf.function_id

            WHERE

                  pf.name = 'PF_MyPartitionFunction'

                  AND CAST(prv.value AS datetime) < @OldestRetainedDate;

      END;

 

      /*Make sure we have an empty partition for tomorrow*/

      SET @PartitionBoundaryDate = DATEADD(day, 1, @RunDate);

      IF NOT EXISTS

              (

              SELECT prv.value

              FROM sys.partition_functions AS pf

              JOIN sys.partition_range_values AS prv ON

                        prv.function_id = pf.function_id

              WHERE

                        pf.name = 'PF_MyPartitionFunction'

                        AND CAST(prv.value AS datetime) = @PartitionBoundaryDate

              )

      BEGIN

              ALTER PARTITION SCHEME PS_MyPartitionScheme

                        NEXT USED [PRIMARY];

              ALTER PARTITION FUNCTION PF_MyPartitionFunction()

                        SPLIT RANGE(@PartitionBoundaryDate);

              SET @Message = 

                        'Created boundary future data '

                        + CONVERT(varchar(30), @PartitionBoundaryDate, 121);

 

              RAISERROR(@Message, 0, 1) WITH NOWAIT;

      END

      ELSE

      BEGIN

              SET @Message =

                        'Partition already exists for future boundary '

                        + CONVERT(varchar(30), @PartitionBoundaryDate, 121);

              RAISERROR(@Message, 0, 1) WITH NOWAIT;

      END;

 

      COMMIT;

 

END TRY

BEGIN CATCH

 

      SELECT

            @Error = ERROR_NUMBER(),

            @Message = ERROR_MESSAGE(),

            @ErrorLine = ERROR_LINE();

 

      RAISERROR('Partition maintenenace failed with error %d at line %d: %s', 16, 1, @Error, @ErrorLine, @Message) WITH NOWAIT;

 

      IF @@TRANCOUNT > 0

      BEGIN

            ROLLBACK;

      END;

 

END CATCH;

 

RETURN @Error;

GO

 