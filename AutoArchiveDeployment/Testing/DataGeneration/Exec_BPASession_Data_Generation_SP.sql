DECLARE @inc INT, @i INT = 0


WHILE @i < 5
BEGIN  
WAITFOR DELAY '00:01:00'; 
SELECT @inc = COUNT(*)+FLOOR(RAND()*100) FROM dbo.BPASession
EXEC generateSession @inc  
SET @i += 1
END;  