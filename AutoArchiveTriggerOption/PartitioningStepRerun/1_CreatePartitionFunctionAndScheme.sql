/****** Object:  PartitionFunction [pflogid]    Script Date: 21/02/2023 12:45:50 ******/
CREATE PARTITION FUNCTION [pflogid](bigint) AS RANGE RIGHT FOR VALUES (1, 2, 4, 5, 6, 7, 2147483647)
GO


/****** Object:  PartitionScheme [pslogid]    Script Date: 21/02/2023 12:46:20 ******/
CREATE PARTITION SCHEME [pslogid] AS PARTITION [pflogid] ALL TO ([PRIMARY])
GO

