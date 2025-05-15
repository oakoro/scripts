--create table sessionCount (
--	[sessionnumber] int,
--	[startdatetime] datetime
--)



create trigger trigcaptureSessions 
on [dbo].[BPASession]
AFTER INSERT AS
begin
insert into dbo.sessionCount([sessionnumber],[startdatetime])
select i.[sessionnumber],i.[startdatetime] 
FROM INSERTED i

end


--select * from dbo.sessionCount