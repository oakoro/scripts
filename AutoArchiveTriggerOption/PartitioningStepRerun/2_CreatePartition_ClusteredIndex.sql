CREATE UNIQUE CLUSTERED INDEX PK_BPASessionLog_NonUnicode_PartitionTest
    ON dbo.BPASessionLog_NonUnicode_PartitionTest (logid)
    WITH (DROP_EXISTING = ON)
    ON [pslogid] (logid)