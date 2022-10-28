--if exists(select 1 from [bpc].[aatbl_trStatus] where trstatus = 0)
--begin
--update [bpc].[aatbl_trStatus] 
--set trstatus = 1
--end

--select trstatus from [bpc].[aatbl_trStatus]


----update [bpc].[aatbl_trStatus] 
----set trstatus = 1


--if exists(select 1 from [bpc].[aatbl_trStatus] where trstatus = 1)
--begin
--update [bpc].[aatbl_trStatus] 
--set trstatus = 0
--end

--create table [bpc].test (
--status char(1)
--)

--insert [bpc].test
--values('Y')

--select * from [bpc].test

--select 'Yes' AS 'Yes'


--update [bpc].test (
--set staus = 

--select 1 from [bpc].[aatbl_trStatus]


if exists(select 1 from [bpc].[aatbl_trStatus] where trstatus = 0)
begin
update [bpc].[aatbl_trStatus] 
set trstatus = 1
end
else
begin
update [bpc].[aatbl_trStatus] 
set trstatus = 0
end
;
select trstatus from [bpc].[aatbl_trStatus] ;