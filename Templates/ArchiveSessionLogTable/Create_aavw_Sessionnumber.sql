/****** Object:  View [BPC].[aavw_Sessionnumber]    Script Date: 27/03/2023 10:47:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [BPC].[aavw_Sessionnumber]  ******/
			CREATE   view [BPC].[aavw_Sessionnumber]
			with schemabinding
			as
			SELECT s.sessionnumber,COUNT_BIG(*) as 'rowNumber' FROM [dbo].[BPASessionLog_NonUnicode] as sl
			INNER JOIN [dbo].[BPASession]  as s
			ON s.sessionnumber = sl.sessionnumber
			WHERE s.enddatetime is not null 
			group by  s.sessionnumber

GO


