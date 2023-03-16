/*** Partitioning left over - we are not using filegroups and must repoint the partition to the Primary filegroup ***/
ALTER PARTITION SCHEME pslogid 
NEXT USED [PRIMARY];

/*** Return the maximum logid ***/
DECLARE @MAXID bigint = (select MAX(logid) from [dbo].[BPASessionLog_NonUnicode_PartitionTest] WITH (NOLOCK))
select @MAXID
/*** Add 1 to the maximum logid to get the begining of the latest 7th range right partition ***/
ALTER PARTITION FUNCTION pflogid ()  
SPLIT RANGE (@MAXID + 1); 