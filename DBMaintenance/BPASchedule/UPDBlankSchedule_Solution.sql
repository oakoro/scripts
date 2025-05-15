  --declare @deletedname datetime = convert(varchar(20),getdate(),102)
  --declare @name nvarchar(256) =  '¬Deleted'+convert(varchar(20),getdate(),102)+''
  --select @name
  --update [BPASchedule] 
  --set [retired] = 1,
  --[name] = @name,
  --[deletedname] = NULL
  --where [deletedname] is NOT NULL AND [name] is NULL

  --select id,'¬Deleted'+convert(varchar(20),getdate(),102) as name,retired from [BPASchedule] 
  --where [deletedname] is NOT NULL AND [name] is NULL

  select * from [BPASchedule]  
  where [deletedname] is NOT NULL AND [name] is NULL and id in (1,4)

  select * from [BPASchedule]  
  where id in (1,4)

  --update [BPASchedule]
  --set name = 'Deleted20250425'
  --where [deletedname] is NOT NULL AND [name] is NULL and id in (1,4)
  --select '¬Deleted'+convert(varchar(20),getdate(),102)
  --select '¬Deleted'+cast(getdate() as date)

  --declare @str varchar(800)
  --set @str =   'update [BPASchedule] set [retired] = 1, [name] = ''¬Deleted'+convert(varchar(20),getdate(),102)+''''
  --print @str
  ----,
  ------[deletedname] = NULL
  ------where [deletedname] is NOT NULL AND [name] is NULL


  --sp_help'BPASchedule'

  select * from BPASchedule where name like '%Deleted%'
