CREATE LOGIN perf_reviewer 
	WITH PASSWORD = 'Pa55word' 
GO

CREATE USER perf_reviewer
	FOR LOGIN perf_reviewer

GO
grant view database state to [perf_reviewer]