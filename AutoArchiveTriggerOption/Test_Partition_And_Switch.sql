--Demo scripts:

--–day 1: create initial 4 partitions

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-01T01:00:00');

EXEC dbo.SlideRangeRightWindow_datetime @RetentionDays = 1, @RunDate = '2008-09-01T00:00:00';

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-01T02:00:00');

 

--–day 2: purge data and create partition for future data (rolling 4 partitions)

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-02T01:00:00');

EXEC dbo.SlideRangeRightWindow_datetime @RetentionDays = 1, @RunDate = '2008-09-02T00:00:00';

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-02T02:00:00');

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-02T03:00:00');

 

--–day 3: purge data and create partition for future data (rolling 4 partitions)

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-03T01:00:00');

EXEC dbo.SlideRangeRightWindow_datetime @RetentionDays = 1, @RunDate = '2008-09-03T00:00:00';

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-03T02:00:00');

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-03T03:00:00');

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-03T04:00:00');

 

--–day 5: catch-up after missed day 4

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-04T01:00:00');

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-04T02:00:00');

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-04T03:00:00');

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-04T04:00:00');

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-04T05:00:00');

INSERT INTO dbo.MyPartitionedTable VALUES('2008-09-05T01:00:00');

EXEC dbo.SlideRangeRightWindow_datetime @RetentionDays = 1, @RunDate = '2008-09-05T00:00:00';