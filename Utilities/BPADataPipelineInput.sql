select top 1000* from dbo.BPADataPipelineInput order by id desc
--Acts as a queue for events into the data pipeline.

/*eventdata content below

{"EventType":1,"EventData":{"SessionNumber":6327,"ResourceId":"34d4289b-8ad0-4fc7-9c00-c7cfb3537ad3",
"ResourceName":"GBAZFGPVW4","StageId":"bb3ac2d5-b59f-4a45-b4a3-91a1ba510a1b","StageName":"Is Policy Live",
"StageType":"Decision","Result":"True","ResultType":"flag","StartDate":"2024-08-09T17:11:45.3877283+01:00",
"Attributes":"","ProcessName":"Day 14 Invite Content Check V2","PageName":"GetFocusData",
"ObjectName":"","ActionName":""}}

*/


--sp_help 'dbo.BPASessionLog_NonUnicode'


--select * from dbo.BPASessionLog_NonUnicode with (nolock) where stagename = 'Is Policy Live' order by logid

--select * from dbo.BPAProcess where name like '%decision%'
--select * from dbo.BPASession where sessionnumber = 6327

--18292	1	{"EventType":1,"EventData":{"SessionNumber":24622,"ResourceId":"935564e1-3dc2-4283-8f18-b766d951d093","ResourceName":"GBAZFGPVW3","StageId":"f6878e25-301c-4540-a15d-7a83dfc57a75","StageName":"End","StageType":"End","Result":"","ResultType":"unknown","StartDate":"2025-02-06T14:30:35.4995178+00:00","Attributes":"","ProcessName":"","PageName":"","ObjectName":"Utility - Environment","ActionName":"Run Process Until Ended"}}	GBAZFGIO1	2025-02-06 14:30:35.507