 


WHILE 1=1
BEGIN

    WAITFOR DELAY '00:00:02'

    
    DELETE top(1000) FROM dbo.BPASessionLog_NonUnicode
    WHERE sessionnumber in (8474,8476)

    IF @@ROWCOUNT = 0 
        Break
END