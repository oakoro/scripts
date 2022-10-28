/****** Object:  View [BPC].[aavw_Get_Sessionnumber_BPASessionLog_NonUnicode]    Script Date: 07/09/2022 13:26:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   view [BPC].[aavw_Get_Sessionnumber_BPASessionLog_NonUnicode]

as
  SELECT s.sessionnumber,s.enddatetime,COUNT_BIG(*) as 'rowNumber' FROM [dbo].[BPASessionLog_NonUnicode] as sl
     INNER JOIN [dbo].[BPASession]  as s
     ON s.sessionnumber = sl.sessionnumber
     WHERE s.enddatetime is not null 
	 group by  s.sessionnumber,s.enddatetime
GO


