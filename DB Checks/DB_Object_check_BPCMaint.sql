select * from sys.all_objects
where type in ('P','U') and 
name in ('aasp_RefreshControlTable_BPASessionLog_NonUnicode',
'aasp_GetSessionNumLessThan200K_Copy_BPASessionLog_NonUnicode')--like 'aa%'
order by create_date desc