--CREATE PARTITION FUNCTION pf_primarykey (bigint) AS RANGE RIGHT FOR VALUES(0, 100, 200)
--GO
--CREATE PARTITION SCHEME ps_primarykey AS PARTITION pf_primarykey ALL TO ([PRIMARY])
--GO
--CREATE UNIQUE CLUSTERED INDEX PK_bpsessionlogPartitionTest
--    ON [dbo].[bpsessionlogPartitionTest] (logid)
--    WITH (DROP_EXISTING = ON)
--    ON ps_primarykey(logid)
--GO