declare @logid bigint,@chunksize bigint --= 1000 --0,1000,1000000000
SELECT @logid = [logid]  FROM [BPC].[adf_watermark] where [tablename] = 'BPASessionLog_NonUnicode'
select @logid 'MinLogid'
--/*Test for when chunksize is larger than actual max logid e.g. 1000000000
--Maxlogid defaults to ActualMaxLogid*/
--set @chunksize = 1000000000
--select @logid + @chunksize 'Expected Copy Volume';
--exec [BPC].[adfsp_get_maxlogidTestOA] @logid,@chunksize;
--exec [BPC].[adfsp_get_maxlogid] @logid,@chunksize;
--select max(logid)'ActualMaxLogid' from dbo.BPASessionLog_NonUnicode 



/*Test for when chunksize is not specified --Maxlogid defaults to ActualMaxLogid */
--select @logid  'Expected Copy Volume';
--exec [BPC].[adfsp_get_maxlogidTestOA] @logid;
--exec [BPC].[adfsp_get_maxlogid] @logid; -- This fails as it expects chunksize
--select max(logid)'ActualMaxLogid' from dbo.BPASessionLog_NonUnicode ;


/*Test for when chunksize equals 0 --Maxlogid defaults to MinLogid and not copy */
--set @chunksize = 0
--select @logid + @chunksize 'Expected Copy Volume';
--exec [BPC].[adfsp_get_maxlogidTestOA] @logid,@chunksize; --Chunksize has to be a value larger than 0
--exec [BPC].[adfsp_get_maxlogid] @logid,@chunksize; --Chunksize has to be a value larger than 0
--select max(logid)'ActualMaxLogid' from dbo.BPASessionLog_NonUnicode; 


/*Test for when chunksize less than actual max logid but larger than 0 e.g. 1000 */
set @chunksize = 1000
select @logid + @chunksize 'Expected Copy Volume'
exec [BPC].[adfsp_get_maxlogidTestOA] @logid,@chunksize  
exec [BPC].[adfsp_get_maxlogid] @logid,@chunksize 
select max(logid)'ActualMaxLogid' from dbo.BPASessionLog_NonUnicode 


