

/*
SET IDENTITY_INSERT [dbo].[BPAAuditEvents] ON

INSERT INTO [dbo].[BPAAuditEvents]
           ([eventdatetime]
		   ,[eventid]
           ,[sCode]
           ,[sNarrative]
           ,[gSrcUserID]
           ,[gTgtUserID]
           ,[gTgtProcID]
           ,[gTgtResourceID]
           ,[comments]
           ,[EditSummary]
           ,[oldXML])
SELECT [eventdatetime]
		   ,[eventid]
           ,[sCode]
           ,[sNarrative]
           ,[gSrcUserID]
           ,[gTgtUserID]
           ,[gTgtProcID]
           ,[gTgtResourceID]
           ,[comments]
           ,[EditSummary]
           ,[oldXML]
FROM [dbo].[BPAAuditEvents20240703] S
WHERE NOT EXISTS (SELECT * FROM [dbo].[BPAAuditEvents] T WITH (NOLOCK) WHERE S.eventid = T.eventid)
SET IDENTITY_INSERT [dbo].[BPAAuditEvents] OFF
*/

