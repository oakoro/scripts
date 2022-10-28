/*Check BPC-Maintenance database creation */
if exists(
select * from sys.sysdatabases
where name = 'BPC-Maintenance')
begin
select 'BPC-Maintenance created successfully on '+@@SERVERNAME
end
else
select 'BPC-Maintenance NOT created on '+@@SERVERNAME