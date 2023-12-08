DECLARE @minLogid BIGINT = 21877548, 
		@maxLogid BIGINT = 41890155, 
		@sumDataSize BIGINT 

 
BEGIN
SELECT @sumDataSize =  SUM( 
ISNULL(DATALENGTH([result]), 1)+ISNULL(DATALENGTH([attributexml]), 1) )
FROM BPASessionLog_NonUnicode WITH (NOLOCK)
WHERE logid BETWEEN @minLogid AND @maxLogid
END
SELECT @sumDataSize AS 'DateSize'

