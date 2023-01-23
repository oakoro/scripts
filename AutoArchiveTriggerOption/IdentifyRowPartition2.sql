

            SELECT prv.value, *

            FROM sys.partition_functions AS pf

            JOIN sys.partition_range_values AS prv ON

                  prv.function_id = pf.function_id

            WHERE

                  pf.name = 'PF_MyPartitionFunction'
				 