SELECT * 
FROM sys.views 
WHERE OBJECTPROPERTY(object_id, 'IsSchemaBound') = 1