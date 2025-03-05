select distinct TABLE_CATALOG, TABLE_SCHEMA,TABLE_NAME,rows
from (
SELECT TABLE_CATALOG,TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,rows
FROM INFORMATION_SCHEMA.COLUMNS c join SYS.PArtitions p on c.TABLE_NAME = object_name(p.object_id)
WHERE data_type IN ('datetime','datetime2','time','timestamp')
)a

