declare @tbl table (s_num int)
declare @num int = 5, @int int, @s_num int

insert @tbl
select top 10 sessionnumber from BPASession
set @int = 0
--select * from @tbl where s_num < @num
while (@int <= @num)
begin
select top 1 @s_num = s_num from @tbl where s_num = @int
print 'I am '+convert(varchar(10),@s_num)
set @int = @int + 1
end
