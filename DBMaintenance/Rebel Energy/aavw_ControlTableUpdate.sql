/****** Object:  View [BPC].[aavw_ControlTableUpdate]    Script Date: 05/06/2024 13:48:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [BPC].[aavw_ControlTableUpdate] ******/

			CREATE VIEW [BPC].[aavw_ControlTableUpdate]
			WITH SCHEMABINDING
			AS
			SELECT s.sessionnumber, COUNT_BIG(*) as rowNumber 
			FROM [dbo].[BPASession] as s
			INNER JOIN [dbo].[BPASessionLog_NonUnicode] as sl
			ON s.sessionnumber = sl.sessionnumber
			WHERE s.enddatetime is not null 
			GROUP BY s.sessionnumber

GO

/****** Object:  Index [aaix_vwSessionnumber]    Script Date: 05/06/2024 13:48:36 ******/
CREATE UNIQUE CLUSTERED INDEX [aaix_vwSessionnumber] ON [BPC].[aavw_ControlTableUpdate]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

