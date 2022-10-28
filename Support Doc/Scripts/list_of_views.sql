select schema_name(v.schema_id) as schema_name,
       v.name as view_name,
       i.name as index_name,
       m.definition
from sys.views v
join sys.indexes i
     on i.object_id = v.object_id
     and i.index_id = 1
     and i.ignore_dup_key = 0
join sys.sql_modules m
     on m.object_id = v.object_id
order by schema_name,
         view_name;

		 select * from sys.views
		 order by create_date desc