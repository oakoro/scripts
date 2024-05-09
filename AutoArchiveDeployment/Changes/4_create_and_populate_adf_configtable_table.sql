/****** Create and populate Table [BPC].[adf_configtable] ******/

SET NOCOUNT ON
IF (OBJECT_ID(N'[BPC].[adf_configtable]',N'U')) IS NULL
BEGIN
CREATE TABLE [BPC].[adf_configtable](
	[sourceschema] [varchar](50) NULL,
	[sourcetable] [varchar](50) NULL,
	[sinkfolder] [varchar](50) NULL
) ON [PRIMARY];
END

DECLARE @configtable TABLE (
[sourceschema] [varchar](50), 
[sourcetable] [varchar](50), 
[sinkfolder] [varchar](50)
)

--Populate or update table 
INSERT @configtable ([sourceschema], [sourcetable], [sinkfolder]) 
VALUES 
(N'dbo', N'BPAWorkQueueItemTag', N'BPAWorkQueueItemTag'),
(N'dbo', N'BPATag', N'BPATag'),
(N'dbo', N'BPASession', N'BPASession'),
(N'dbo', N'BPAProcess', N'BPAProcess'),
(N'dbo', N'BPAProcessEnvironmentVarDependency', N'BPAProcessEnvironmentVarDependency'),
(N'dbo', N'BPAEnvironmentVar', N'BPAEnvironmentVar'),
(N'dbo', N'BPARelease', N'BPARelease'),
(N'dbo', N'BPAResource', N'BPAResource'),
(N'dbo', N'BPAUser', N'BPAUser'),
(N'dbo', N'BPAWorkQueue', N'BPAWorkQueue');

INSERT [BPC].[adf_configtable] ([sourceschema], [sourcetable], [sinkfolder]) 
SELECT [sourceschema], [sourcetable], [sinkfolder]
FROM @configtable a
WHERE NOT EXISTS (SELECT [sourcetable] FROM [BPC].[adf_configtable] b WHERE b.[sourcetable] = a.[sourcetable]);

--Remove BPAAuditEvents from [BPC].[adf_configtable]
IF EXISTS(SELECT 1 FROM [BPC].[adf_configtable] WHERE [sourcetable] = 'BPAAuditEvents')
BEGIN
DELETE [BPC].[adf_configtable] WHERE [sourcetable] = 'BPAAuditEvents'
END


SET NOCOUNT OFF


