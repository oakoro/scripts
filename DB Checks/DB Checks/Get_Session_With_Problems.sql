declare @SessionnumMultitbl table ([sessionnumber] bigint)
declare @SessionnumAlltbl table ([sessionnumber] bigint)
declare @SessionnumbersCombined varchar(max), @runid varchar(500)
declare copy_verification cursor
for
select runid from  [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode] where  [sessionnumber] is null and [SessionnumbersCombined] is not null
open copy_verification
fetch next from copy_verification into @runid
while @@fetch_status = 0
begin 

--select SessionnumbersCombined FROM [bpc].aa_ActivityLogs_BPASessionLog_NonUnicode where runid = @runid
select @SessionnumbersCombined = SessionnumbersCombined FROM [bpc].aa_ActivityLogs_BPASessionLog_NonUnicode where runid = @runid
--print @SessionnumbersCombined
insert @SessionnumMultitbl
select value from string_split (@SessionnumbersCombined,',')
fetch next from copy_verification into @runid
end
close copy_verification
deallocate copy_verification;

with cte_SessionnumMultitbl
as
(
select * from @SessionnumMultitbl
)
--select * from cte_SessionnumMultitbl
,cte_SessionnumSingletbl
as
(
select [sessionnumber] from  [BPC].[aa_ActivityLogs_BPASessionLog_NonUnicode] where  [sessionnumber] is not null and [SessionnumbersCombined] is null
)
,cte_mergeTbl
as
(
select * from cte_SessionnumMultitbl
union
select * from cte_SessionnumSingletbl
)
select * from [BPC].[aa_ControlTable_BPASessionLog_NonUnicode] where sessionnumber not in (select sessionnumber from cte_mergeTbl) and copystatus is not null
--select * from [BPC].[aa_ControlTable_BPASessionLog_NonUnicode] ct left join cte_mergeTbl cte on ct.[sessionnumber] = cte.[sessionnumber]
--where copystatus is not null

--select * from cte_mergeTbl
--select [sessionnumber] from @SessionnumAlltbl
--select [sessionnumber], count(1) from @SessionnumAlltbl group by [sessionnumber] having count(1) > 1
