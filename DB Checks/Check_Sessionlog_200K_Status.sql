IF EXISTS(SELECT 1 FROM [BPC].[aa_ControlTable_BPASessionLog_NonUnicode]
WHERE rowNumber >= 200000)
BEGIN
SELECT @@SERVERNAME AS 'SQLServer', 'Has_Over_200K' AS 'VolumeStatus'
END
ELSE SELECT @@SERVERNAME AS 'SQLServer', 'All_Below_200K' AS 'VolumeStatus'


--SELECT * --INTO [BPC].[aa_ControlTable_BPASessionLog_NonUnicodecOPY]
--FROM [BPC].[aa_ControlTable_BPASessionLog_NonUnicode]
--ORDER BY rowNumber

--DELETE [BPC].[aa_ControlTable_BPASessionLog_NonUnicode]
--WHERE rowNumber >= 200000

INSERT [BPC].[aa_ControlTable_BPASessionLog_NonUnicode]
SELECT * FROM [BPC].[aa_ControlTable_BPASessionLog_NonUnicodecOPY]
WHERE rowNumber >= 200000