/****** Script for SelectTopNRows command from SSMS  ******/
--SELECT TOP (1000) [sessionnumber]
--      ,[enddatetime]
--      ,[rowNumber]
--      ,[copyStatus]
--      ,[createdTS]
--  FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] order by rowNumber
--  --where copyStatus is null

--  update [bpc].[aa_ControlTable_BPASessionLog_NonUnicode]
--  set copyStatus = Null, createdTS = Null
--  where sessionnumber in (
--  105,
--112,
--211,
--236,
--242,
--417,
--419,
--517,
--518,
--593,
--617,
--696,
--1049,
--1051,
--1048,
--818,
--622,
--627,
--613,
--630,
--536,
--561,
--527,
--233,
--249,
--250,
--254,
--209,
--86,
--122,
--210,
--212,
--208,
--232,
--278,
--318,
--321,
--610,
--647,
--717,
--1045,
--1042,
--1043,
--908,
--930,
--654,
--628,
--576,
--595,
--578
--)

--if exists(select 1 from [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] where copyStatus is Null)
--begin
--select 'Run' as 'ControlTableStatus'
--end

/*Create CompletedSessionNumCache_BPASessionLog_NonUnicode Table in Maintenance DB*/
--CREATE TABLE [BPC].[CompletedSessionNumCache_BPASessionLog_NonUnicode](
--	[sessionnumber] [int] NULL
--) ON [PRIMARY]
--GO

--select sessionnumber from [BPC].[CompletedSessionNumCache_BPASessionLog_NonUnicode]

SELECT [sessionnumber]
      ,[enddatetime]
      ,[rowNumber]
      ,[copyStatus]
      ,[createdTS]
  FROM [bpc].[aa_ControlTable_BPASessionLog_NonUnicode] 
  where sessionnumber in (
  105,
112,
211,
236,
242,
417,
419,
517,
518,
593,
617,
696,
1049,
1051,
1048,
818,
622,
627,
613,
630,
536,
561,
527,
233,
249,
250,
254,
209,
86,
122,
210,
212,
208,
232,
278,
318,
321,
610,
647,
717,
1045,
1042,
1043,
908,
930,
654,
628,
576,
595,
578
)
