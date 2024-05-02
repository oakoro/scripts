select * from [BPC].[adf_watermark]
--DELETE [BPC].[adf_watermark] WHERE [tablename] = 'BPAAuditEvents'
--DROP TABLE  [BPC].[adf_watermark]
--create table dbo.BPAAuditEvents (
--eventdatetime datetime,
--eventid int,
--sCode nvarchar,
--sNarrative nvarchar,
--gSrcUserID uniqueidentifier,
--gTgtUserID uniqueidentifier,
--gTgtProcID uniqueidentifier,
--gTgtResourceID uniqueidentifier,
--comments nvarchar,
--EditSummary nvarchar,
--oldXML nvarchar,
--newXML nvarchar
--)

--UPDATE [BPC].[adf_watermark] 
--SET [logid] = NULL
--WHERE [tablename] IN ('BPASessionLog_Unicode')--,'BPASessionLog_Unicode') 

--UPDATE [BPC].[adf_watermark] 
--SET [last_processed_date] = GETDATE(), [logid]  = 12
--WHERE [tablename] IN ('BPASessionLog_Unicode')

