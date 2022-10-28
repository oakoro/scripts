select * from sys.all_objects
where type in ('P','U') and name in ('aa_SessionNumLessThan200KCache_BPASessionLog_NonUnicode',
'aasp_CopySessionNumLessThan200K_BPASessionLog_NonUnicode')--like 'aa%'
order by create_date desc