with sessionlog_size
as
(select  logid, 
isnull(datalength([result]), 1)[result] , 
isnull(datalength([attributexml]), 1) [attributexml]
 from BPASessionLog_NonUnicode with (nolock)
where logid between 142234590 and 142734590
)
select sum([result])'result',sum([attributexml])'attributexml' from sessionlog_size --order by 3 
--select top 53980* from sessionlog_size order by 1
/*
result	attributexml
3553750	28738092
1089943	55725958
1479673	804356179--Failed
1031415	325050902
298212	460871831
225373	29659503
5464457	2954504257
--53,977
*/