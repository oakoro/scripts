declare @table nvarchar(128)
    declare @idcol nvarchar(128)
    declare @sql nvarchar(max)
    
    --initialize those two values
    set @table = 'BPASessionLog_NonUnicode'
    set @idcol = 'logid'
    
    set @sql = 'select ' + @idcol +' , (0'
    
    select @sql = @sql + ' + isnull(datalength([' + name + ']), 1)' 
            from sys.columns where object_id = object_id(@table)
    set @sql = @sql + ') as rowsize from ' + @table + ' order by rowsize         desc'
    
    PRINT @sql
    
    exec (@sql)