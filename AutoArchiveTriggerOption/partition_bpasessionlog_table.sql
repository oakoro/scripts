/****** Object:  Index [PK_BPASessionLog_NonUnicode]    Script Date: 10/02/2023 14:43:56 ******/



ALTER TABLE [dbo].[BPASessionLog_NonUnicode] DROP CONSTRAINT [PK_BPASessionLog_NonUnicode] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [PK_BPASessionLog_NonUnicode]    Script Date: 10/02/2023 14:43:56 ******/
ALTER TABLE [dbo].[BPASessionLog_NonUnicode] ADD  CONSTRAINT [PK_BPASessionLog_NonUnicode] PRIMARY KEY CLUSTERED 
(
	[logid] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [pslogid]
GO

--/****** Object:  Index [PK_BPASessionLog_NonUnicode]    Script Date: 10/02/2023 15:02:24 ******/
--ALTER TABLE [dbo].[BPASessionLog_NonUnicode] ADD  CONSTRAINT [PK_BPASessionLog_NonUnicode] PRIMARY KEY CLUSTERED 
--(
--	[logid] ASC
--)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

CREATE UNIQUE CLUSTERED INDEX PK_BPASessionLog_NonUnicode
    ON dbo.BPASessionLog_NonUnicode (logid)
    WITH (DROP_EXISTING = ON)
    ON [pslogid] (logid)
