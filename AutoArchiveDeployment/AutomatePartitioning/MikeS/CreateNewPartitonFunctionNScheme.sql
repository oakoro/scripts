--/****** Object:  PartitionScheme [PS_Dynamic_NU_AutoPT1]    Script Date: 04/10/2023 18:25:38 ******/
--CREATE PARTITION SCHEME [PS_Dynamic_NU_AutoPT1] AS PARTITION [PF_Dynamic_NU_AutoPT1] TO ([PRIMARY], [PRIMARY], [PRIMARY])
--GO


--/****** Object:  PartitionFunction [PF_Dynamic_NU_AutoPT1]    Script Date: 04/10/2023 18:26:04 ******/
--CREATE PARTITION FUNCTION [PF_Dynamic_NU_AutoPT1](bigint) AS RANGE RIGHT FOR VALUES (0)
--GO

