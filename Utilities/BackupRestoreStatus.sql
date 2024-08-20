Select * from sys.dm_operation_status 
where operation like '%Restore%' 
order by Start_Time Desc;