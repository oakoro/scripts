/****** Object:  Table [dbo].[BPASchedule]    Script Date: 04/06/2024 12:08:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BPASchedule](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](128) NULL,
	[description] [nvarchar](max) NULL,
	[initialtaskid] [int] NULL,
	[retired] [bit] NOT NULL,
	[versionno] [int] NOT NULL,
	[deletedname] [nvarchar](128) NULL,
 CONSTRAINT [PK_BPASchedule] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BPASchedule] ADD  CONSTRAINT [DEF_BPASchedule_retired]  DEFAULT ((0)) FOR [retired]
GO

