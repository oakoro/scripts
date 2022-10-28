/****** Object:  ExternalDataSource [Archive]    Script Date: 30/03/2022 11:37:40 ******/
--create database scoped credential [oketest]
--with identity = 'SHARED ACCESS SIGNATURE',  
--SECRET = 'sp=rle&st=2022-03-30T12:05:25Z&se=2022-03-30T20:05:25Z&spr=https&sv=2020-08-04&sr=c&sig=Dads0wsMcpsbUzyeJwyTn6EVRRbQs2Q%2BAUArMvoKOOM%3D'
--GO
--CREATE EXTERNAL DATA SOURCE [ArchiveOkeTest]
--WITH (
--LOCATION = N'https://bpcarchiveligfd66ykhhtq.blob.core.windows.net/rpa-autoarchive-olabode/', 
--CREDENTIAL = oketest
--)
--GO
--create login oketest with password = 'Pa55word1234'
--create user oketest for login oketest
--grant administer database bulk operations to oketest
----rpa-autoarchive-olabode/BPASessionLog_NonUnicode/BPASessionLog_NonUnicode_100.parquet

--execute as login = 'oketest'
select * from
openrowset (
bulk 'BPASessionLog_NonUnicode/BPASessionLog_NonUnicode_*.parquet',
data_source = 'ArchiveOkeTest',
format = 'parquet'
) 
--with (
--logid int,
--sessionnumber bigint,
--[stageid] uniqueidentifier,
--[stagename] varchar(128),
--[stagetype] int,
--[processname] varchar(128),
--[pagename] varchar(128),
--[objectname] varchar(128),
--[actionname] varchar(128),
--[result] varchar(max),
--[resulttype] int,
--startdatetime datetime,
--[enddatetime] datetime
--)
as a
where enddatetime is not null and enddatetime between '2020-06-22' and '2020-06-23'
order by sessionnumber


--select * from sys.database_scoped_credentials

