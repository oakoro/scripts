/****** Object:  View [BPC].[aavw_Get_Sessionnumber_BPASessionLog_NonUnicode]    Script Date: 08/09/2022 11:22:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [BPC].[aavw_Get_Sessionnumber_BPASessionLog_NonUnicode]

/*
enddatetime count added to view
*/

AS
  SELECT s.sessionnumber,s.enddatetime,COUNT_BIG(*) as 'rowNumber' FROM [dbo].[BPASessionLog_NonUnicode] as sl
     INNER JOIN [dbo].[BPASession]  as s
     ON s.sessionnumber = sl.sessionnumber
     WHERE s.enddatetime is not null 
	 group by  s.sessionnumber,s.enddatetime
GO


