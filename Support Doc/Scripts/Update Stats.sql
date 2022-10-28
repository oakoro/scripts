dbcc show_statistics ('dbo.BPASessionLog_NonUnicode',[Index_BPASessionLog_NonUnicode_enddatetime_oke]) --with histogram
dbcc show_statistics ('dbo.BPASessionLog_NonUnicode',[PK_BPASessionLog_NonUnicode]) --with histogram
dbcc show_statistics ('dbo.BPASessionLog_NonUnicode',[Index_BPASessionLog_NonUnicode_enddatetime]) 

UPDATE STATISTICS [dbo].[BPASessionLog_NonUnicode] with all