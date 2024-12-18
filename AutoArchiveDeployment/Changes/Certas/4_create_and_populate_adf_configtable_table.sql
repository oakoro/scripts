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

/*
Populate or update table [BPC].[adf_configtable]
*/
INSERT @configtable ([sourceschema], [sourcetable], [sinkfolder]) 
VALUES 
(N'dbo', N'BPAWorkQueueItemTag', N'BPAWorkQueueItemTag'),
(N'dbo', N'BPATag', N'BPATag'),
(N'dbo', N'BPACaseLock', N'BPACaseLock'),
(N'dbo', N'BPAProcess', N'BPAProcess'),
(N'dbo', N'BPAProcessEnvironmentVarDependency', N'BPAProcessEnvironmentVarDependency'),
(N'dbo', N'BPAEnvironmentVar', N'BPAEnvironmentVar'),
(N'dbo', N'BPARelease', N'BPARelease'),
(N'dbo', N'BPAResource', N'BPAResource'),
(N'dbo', N'BPAGroupResource', N'BPAGroupResource'),
(N'dbo', N'BPAGroup', N'BPAGroup'),
(N'dbo', N'BPAUser', N'BPAUser'),
(N'dbo', N'BPAWorkQueue', N'BPAWorkQueue'),
(N'dbo', N'BPAReleaseEntry', N'BPAReleaseEntry'),
(N'dbo', N'BPATask', N'BPATask'),
(N'dbo', N'BPATasksession', N'BPATasksession'),
(N'dbo', N'BPAScheduleTrigger', N'BPAScheduleTrigger'),
(N'dbo', N'BPASchedule', N'BPASchedule'),
(N'dbo', N'BPAWorkQueueLog', N'BPAWorkQueueLog'),
(N'dbo', N'BPMIProductivityMonthly', N'BPMIProductivityMonthly'),
(N'dbo', N'BPMIQueueInterimSnapshot', N'BPMIQueueInterimSnapshot'),
(N'dbo', N'BPMIQueueSnapshot', N'BPMIQueueSnapshot'),
(N'dbo', N'BPMIQueueTrend', N'BPMIQueueTrend'),
(N'dbo', N'BPMISnapshotTrigger', N'BPMISnapshotTrigger'),
(N'dbo', N'BPMIUtilisationDaily', N'BPMIUtilisationDaily'),
(N'dbo', N'BPMIUtilisationMonthly', N'BPMIUtilisationMonthly'),
(N'dbo', N'BPMIUtilisationShadow', N'BPMIUtilisationShadow')
;

INSERT [BPC].[adf_configtable] ([sourceschema], [sourcetable], [sinkfolder]) 
SELECT c.[sourceschema], c.[sourcetable], c.[sinkfolder]
FROM @configtable c INNER JOIN sys.tables t ON c.sourcetable = t.name AND c.sourceschema = SCHEMA_NAME(t.schema_id)
LEFT JOIN [BPC].[adf_configtable] b ON b.[sourcetable] = c.[sourcetable]
WHERE b.sourcetable IS NULL;




SET NOCOUNT OFF


