with cte_1
as
(
select  logid, 
isnull(datalength([result]), 1)[result] , 
isnull(datalength([attributexml]), 1) [attributexml], 
isnull(datalength([attributesize]), 1)[attributesize] from BPASessionLog_NonUnicode with (nolock)
where logid >= 709358741 and logid < 741613026
)
select AVG([result])'AVG_Result_Size',MIN([result])'MIN_Result_Size',MAX([result])'MAX_Result_Size',
AVG([attributexml])'AVG_attributexml_Size',MIN([attributexml])'MIN_attributexml_Size',MAX([attributexml])'MAX_attributexml_Size',
AVG([attributesize])'AVG_attributesize_Size',MIN([attributesize])'MIN_attributesize_Size',MAX([attributesize])'MAX_attributesize_Size'
from cte_1