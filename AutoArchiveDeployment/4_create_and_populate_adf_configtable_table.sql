/****** Create and populate Table [BPC].[adf_configtable] ******/

IF (OBJECT_ID(N'[BPC].[adf_configtable]',N'U')) IS NULL
BEGIN
CREATE TABLE [BPC].[adf_configtable](
	[sourceschema] [varchar](50) NULL,
	[sourcetable] [varchar](50) NULL,
	[sinkfolder] [varchar](50) NULL
) ON [PRIMARY];


INSERT [BPC].[adf_configtable] ([sourceschema], [sourcetable], [sinkfolder]) 
VALUES 
(N'dbo', N'BPAWorkQueueItemTag', N'BPAWorkQueueItemTag'),
(N'dbo', N'BPATag', N'BPATag'),
(N'dbo', N'BPASession', N'BPASession'),
(N'dbo', N'BPAAuditEvents', N'BPAAuditEvents'),
(N'dbo', N'BPAProcess', N'BPAProcess'),
(N'dbo', N'BPAProcessEnvironmentVarDependency', N'BPAProcessEnvironmentVarDependency'),
(N'dbo', N'BPAEnvironmentVar', N'BPAEnvironmentVar'),
(N'dbo', N'BPARelease', N'BPARelease'),
(N'dbo', N'BPAResource', N'BPAResource'),
(N'dbo', N'BPAUser', N'BPAUser'),
(N'dbo', N'BPAWorkQueue', N'BPAWorkQueue');
END





