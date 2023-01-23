SELECT $PARTITION.PF_MyPartitionFunction(PartitionColumnDateTime) AS PartitionNumber, *
FROM [dbo].MyPartitionedTable