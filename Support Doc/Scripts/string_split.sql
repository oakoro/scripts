declare @tbl table (col1 varchar(10));
insert @tbl
select value from STRING_SPLIT('apple,banana,lemon,kiwi,orange,coconut',',') where value like '%co%';

select * from @tbl;

declare @test varchar(max)
select @test = Sessionnumbers
  FROM [bpc].[ActivityLogsBPASessionLogOkeTest3]

  select value from string_split(@test,',')


  declare @sessionnumber varchar(max)
select @sessionnumber = [Sessionnumbers]
  FROM [bpc].[aatbl_ActivityLogs_Smalldataset_BPASessionLog_NonUnicode]
  where recordCopied = 0 and executionEndtime = '2022-06-28 11:18:00.000'

 
  --update [bpc].[aa_ControlTable_BPASessionLog_NonUnicode]
  --set copyStatus = Null, createdTS = Null
  --where sessionnumber in  (select value from string_split(@sessionnumber,','))