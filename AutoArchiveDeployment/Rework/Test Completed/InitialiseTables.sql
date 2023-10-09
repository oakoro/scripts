INSERT [dbo].[BPAProcess] ([processid], [ProcessType], [name], [description], [version], [createdate], [createdby], [lastmodifieddate], [lastmodifiedby], [AttributeID], [compressedxml], [processxml], [wspublishname], [runmode], [sharedObject], [forceLiteralForm], [useLegacyNamespace]) 
VALUES (N'740feb4a-58b8-4376-931b-0197f16920c3', N'P', N'Login', N'Logs into the target resource using the credential for the machine as specified in the environment variable "Login Format String"', N'1.0', CAST(N'2020-05-21T18:30:16.373' AS DateTime), N'f4e80d39-38c8-49bf-8a34-e7442fa64993', CAST(N'2020-11-23T15:56:55.207' AS DateTime), N'192cd5e3-d451-42e5-8dc9-a333fdbc86a6', 2, NULL, NULL, NULL, 1, 0, 0, 1)
GO
INSERT [dbo].[BPAResource] ([resourceid], [name], [processesrunning], [actionsrunning], [unitsallocated], [lastupdated], [AttributeID], [pool], [controller], [diagnostics], [logtoeventlog], [FQDN], [ssl], [userID], [statusid], [currentculture]) 
VALUES (N'15b22d86-2054-4923-b552-65cf32ae59e8', N'SOAZCGDVW1', 0, 0, 0, CAST(N'2023-08-10T14:02:17.403' AS DateTime), 0, NULL, NULL, 4, 1, N'SOAZCGDVW1.', 0, NULL, 1, N'English (South Africa)')
GO
INSERT [dbo].[BPAResource] ([resourceid], [name], [processesrunning], [actionsrunning], [unitsallocated], [lastupdated], [AttributeID], [pool], [controller], [diagnostics], [logtoeventlog], [FQDN], [ssl], [userID], [statusid], [currentculture]) 
VALUES (N'5a4b2f74-b3f3-4751-9747-74258a8b961b', N'SOAZCGDVW2', 0, 0, 0, CAST(N'2023-08-10T14:02:20.570' AS DateTime), 0, NULL, NULL, 4, 1, N'SOAZCGDVW2.', 0, NULL, 1, N'English (South Africa)')
GO
SET IDENTITY_INSERT [dbo].[BPASession] ON 
GO
INSERT [dbo].[BPASession] ([sessionid], [sessionnumber], [startdatetime], [enddatetime], [processid], [starterresourceid], [starteruserid], [runningresourceid], [runningosusername], [statusid], [startparamsxml], [logginglevelsxml], [sessionstatexml], [queueid], [stoprequested], [stoprequestack], [lastupdated], [laststage], [warningthreshold], [starttimezoneoffset], [endtimezoneoffset], [lastupdatedtimezoneoffset]) 
VALUES (N'103e6c10-b75b-45f1-a3f2-85e0b12f1384', 2, CAST(N'2020-10-02T19:10:43.587' AS DateTime), CAST(N'2020-10-02T19:10:45.553' AS DateTime), N'740feb4a-58b8-4376-931b-0197f16920c3', N'5a4b2f74-b3f3-4751-9747-74258a8b961b', N'f4e80d39-38c8-49bf-8a34-e7442fa64993', N'15b22d86-2054-4923-b552-65cf32ae59e8', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2020-10-02T19:10:44.147' AS DateTime), N'Start', 300, 3600, 3600, 3600)
GO
INSERT [dbo].[BPASession] ([sessionid], [sessionnumber], [startdatetime], [enddatetime], [processid], [starterresourceid], [starteruserid], [runningresourceid], [runningosusername], [statusid], [startparamsxml], [logginglevelsxml], [sessionstatexml], [queueid], [stoprequested], [stoprequestack], [lastupdated], [laststage], [warningthreshold], [starttimezoneoffset], [endtimezoneoffset], [lastupdatedtimezoneoffset]) 
VALUES (N'979dc05b-d5d6-4755-810f-860588afe20a', 1, CAST(N'2020-10-02T20:10:32.810' AS DateTime), CAST(N'2020-10-02T20:10:34.723' AS DateTime), N'740feb4a-58b8-4376-931b-0197f16920c3', N'15b22d86-2054-4923-b552-65cf32ae59e8', N'f4e80d39-38c8-49bf-8a34-e7442fa64993', N'15b22d86-2054-4923-b552-65cf32ae59e8', NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, CAST(N'2020-10-02T20:10:33.273' AS DateTime), N'Start', 300, 7200, 7200, 7200)
GO
SET IDENTITY_INSERT [dbo].[BPASession] OFF
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (0, N'RUN', N'Pending')
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (1, N'RUN', N'Running')
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (2, N'RUN', N'Terminated')
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (3, N'RUN', N'Stopped')
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (4, N'RUN', N'Completed')
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (5, N'RUN', N'Debugging')
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (6, N'RUN', N'Archived')
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (7, N'RUN', N'Stopping')
GO
INSERT [dbo].[BPAStatus] ([statusid], [type], [description]) 
VALUES (8, N'RUN', N'Warning')
GO
INSERT [dbo].[BPASysConfig] ([id], [maxnumconcproc], [populateusernameusing], [autosaveinterval], [EnforceEditSummaries], [ArchiveInProgress], [PassWordExpiryWarningInterval], [ActiveDirectoryProvider], [CompressProcessXML], [showusernamesonlogin], [maxloginattempts], [ArchivingMode], [ArchivingLastAuto], [ArchivingFolder], [ArchivingAge], [ArchivingDelete], [ArchivingResource], [DependencyState], [unicodeLogging], [defaultencryptid], [ResourceRegistrationMode], [PreventResourceRegistration], [RequireSecuredResourceConnections], [DatabaseInstallerOptions], [EnvironmentId], [authenticationgatewayurl], [EnableMappedActiveDirectoryAuth], [EnableExternalAuth], [enableofflinehelp], [offlinehelpbaseurl], [UpgradeCurrentVersion], [UpgradeTargetVersion]) 
VALUES (1, NULL, 0, NULL, 1, NULL, NULL, N'', 1, 0, NULL, 0, NULL, N'', N'6m', 0, NULL, 2, 0, NULL, 0, 0, 0, NULL, N'd92a8b7c-35cc-48b3-9e41-1f4828b0cb5a', NULL, 0, 0, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[BPAUser] ([userid], [username], [validfromdate], [validtodate], [passwordexpirydate], [useremail], [isdeleted], [UseEditSummaries], [preferredStatisticsInterval], [SaveToolStripPositions], [PasswordDurationWeeks], [AlertEventTypes], [AlertNotificationTypes], [LogViewerHiddenColumns], [systemusername], [loginattempts], [lastsignedin], [authtype]) 
VALUES (N'f4e80d39-38c8-49bf-8a34-e7442fa64993', N'admin', CAST(N'2020-05-21T18:13:20.080' AS DateTime), CAST(N'2099-12-31T00:00:00.000' AS DateTime), CAST(N'2099-06-18T00:00:00.000' AS DateTime), NULL, 0, 1, NULL, NULL, 4, 0, 0, 1043947, NULL, 0, CAST(N'2023-02-07T11:44:00.900' AS DateTime), 1)
GO
