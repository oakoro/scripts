/****** Object:  View [BPC].[aavw_ControlTableUpdate]    Script Date: 27/03/2023 10:46:33 ******/
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


SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

/****** Object:  Index [aaix_vwSessionnumber]    Script Date: 27/03/2023 10:46:50 ******/
CREATE UNIQUE CLUSTERED INDEX [aaix_vwSessionnumber] ON [BPC].[aavw_ControlTableUpdate]
(
	[sessionnumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

