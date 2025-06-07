    declare @i int = 0
	while @i < 50 
	begin
	DELETE TOP (50000) T
    FROM BPATag AS T
    LEFT JOIN BPAWorkQueueItemTag AS IT
        ON T.id = IT.tagid
    WHERE IT.tagid IS NULL;
	set @i = @i + 1
	WAITFOR DELAY '00:00:01'
	end

	--


