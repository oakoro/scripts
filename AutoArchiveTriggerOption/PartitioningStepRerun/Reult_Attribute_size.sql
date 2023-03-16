select logid,[sessionnumber],
isnull(datalength(attributexml),0)'attributesize',
isnull(datalength(result),0)'resultsize'
--[attributesize]  AS (isnull(datalength([attributexml]),(0)),
--[resultsize]  AS (isnull(datalength([result]),(0)))
from BPASessionLog_NonUnicode