declare @DBDestinationFolder nvarchar(max) = 'C:\SQLTest\TestRestore\'
declare @BackupPath table (Backuppath varchar(100) )

declare @DBName table (DBName varchar(100))

declare @DBNametemp table (DBName varchar(100))

declare @DBLogicalPhysical table
(
DatabaseName varchar(100),
LogicalName sysname null,
PhysicalName sysname null,
BackupPath varchar(100)
)

declare @BackupFileList table
(
LogicalName sysname null,
PhysicalName sysname null,
Type sysname null,
FileGroupName sysname null,
Size sysname null,
MaxSize sysname null,
FileID sysname null,
CreateLSN sysname null,
DropLSN sysname null,
UniqueID sysname null,
ReadOnlyLSN sysname null,
ReadWriteLSN sysname null,
BackupSizeInBytes sysname null,
SourceBlockSize sysname null,
FileGroupID sysname null,
LogGroupGUID sysname null,
DifferentialBaseLSN sysname null,
DifferentialBaseGUID sysname null,
IsReadOnly sysname null,
IsPresent sysname null,
TDEThumbprint sysname null,
Snapshot sysname null
)

Declare @BackupHeader Table (
   BackupName sysname null,
   BackupDescription sysname null,
   BackupType sysname null,
   ExpirationDate sysname null,
   Compressed sysname null,
   Position sysname null,
   DeviceType sysname null,
   UserName sysname null,
   ServerName sysname null,
   DatabaseName sysname null,
   DatabaseVersion sysname null,
   DatabaseCreationDate sysname null,
   BackupSize sysname null,
   FirstLSN sysname null,
   LastLSN sysname null,
   CheckpointLSN sysname null,
   DatabaseBackupLSN sysname null,
   BackupStartDate sysname null,
   BackupFinishDate sysname null,
   SortOrder sysname null,
   CodePage sysname null,
   UnicodeLocaleId sysname null,
   UnicodeComparisonStyle sysname null,
   CompatibilityLevel sysname null,
   SoftwareVendorId sysname null,
   SoftwareVersionMajor sysname null,
   SoftwareVersionMinor sysname null,
   SoftwareVersionBuild sysname null,
   MachineName sysname null,
   Flags sysname null,
   BindingID sysname null,
   RecoveryForkID sysname null,
   Collation sysname null,
   FamilyGUID sysname null,
   HasBulkLoggedData sysname null,
   IsSnapshot sysname null,
   IsReadOnly sysname null,
   IsSingleUser sysname null,
   HasBackupChecksums sysname null,
   IsDamaged sysname null,
   BeginsLogChain sysname null,
   HasIncompleteMetaData sysname null,
   IsForceOffline sysname null,
   IsCopyOnly sysname null,
   FirstRecoveryForkID sysname null,
   ForkPointLSN sysname null,
   RecoveryModel sysname null,
   DifferentialBaseLSN sysname null,
   DifferentialBaseGUID sysname null,
   BackupTypeDescription sysname null,
   BackupSetGUID sysname null,
   CompressedBackupSize sysname null,
   containment sysname null,
   KeyAlgorithm sysname null,
   EncryptorThumbprint sysname null,
   EncryptorType sysname null
   --LastValidRestoreTime sysname null,
   --TimeZone sysname null,
   --CompressionAlgorithm sysname null
   )

   INSERT @BackupPath
   SELECT [column1]+'\'+[column2]+'\'+[column3]
  FROM [$DB].[dbo].[backup]

  --SELECT * FROM @BackupPath

/*** Extract backup information ***/
  Declare @filepath varchar(100), @filecount int,@logicalName varchar(100), @physicalPath varchar(100), @database varchar(100),
		  @reversePhysicalPath varchar(100), @indexPosition int, @logicalnameCount int, @physicalName varchar(100)

  Select @filecount	 = count(*) from @BackupPath

  while @filecount > 0
  begin
  delete from @BackupHeader

  select top 1 @filepath = Backuppath from @BackupPath
  --select @filepath
  insert @BackupHeader
  exec ('restore headeronly from disk = '+''''+@filepath+'''');

  insert @BackupFileList
  exec ('restore filelistonly from disk = ' +''''+@filepath +'''');

  --insert @DBLogicalPhysical(DatabaseName)
  select distinct @database = DatabaseName from @BackupHeader

  
  select @logicalnameCount = count(*) from @BackupFileList
		while @logicalnameCount > 0
		begin
		select top 1 @LogicalName = logicalName, @PhysicalPath = PhysicalName from @BackupFileList

		select @ReversePhysicalPath = REVERSE(@physicalpath)
		select @indexPosition = CHARINDEX('\',@ReversePhysicalPath)
		select @physicalName = REVERSE(substring(@ReversePhysicalPath,1,@indexPosition - 1))
		--select @PhysicalPath = REVERSE(@PhysicalPath)

		insert @DBLogicalPhysical(DatabaseName,LogicalName,PhysicalName,BackupPath)
		values(@database,@logicalName, @physicalName,@filepath)
		delete @BackupFileList where LogicalName = @logicalName and PhysicalName = @physicalPath
		set @logicalnameCount = @logicalnameCount - 1
		end

  --select  @LogicalName = logicalName, @PhysicalPath = PhysicalName from @BackupFileList
  --select @database = DatabaseName from @BackupHeader
  
  delete from @BackupPath where Backuppath = @filepath
  set @filecount = @filecount - 1
  end

  /** Restore Script **/
  declare @db varchar(100), @dbcount int,@dbfilecount int,@pfile varchar(100),@lfile varchar(100),
		@concat1 varchar(max),@concat2 varchar(max) = '',@concat3 varchar(max),@concat4 varchar(max),
		@backupfile varchar(400)

		declare @DBtemp2 table (DBName varchar(100))
		declare @tblRestoreString table (DB varchar(100),RestoreStr varchar(400))
		declare @DBtemp2Count int,@DB2 varchar(100)

		insert @DBtemp2
		select distinct DatabaseName from @DBLogicalPhysical

		select @DBtemp2Count = count(*) from @DBtemp2
		while @DBtemp2Count > 0
		begin
		select top 1 @DB2 = DBName from @DBtemp2
		--select @DB2
		select distinct @backupfile = BackupPath from @DBLogicalPhysical where DatabaseName = @DB2
		--select @backupfile
		set @concat1 = 'RESTORE DATABASE '+ QUOTENAME(@DB2) + ' FROM Disk = '''+@backupfile +''''

		insert @tblRestoreString(DB,RestoreStr)
		values(@DB2, @concat1)
		delete @DBtemp2 where DBName = @DB2
		set @DBtemp2Count = @DBtemp2Count - 1
		end

--- Move

declare @DBtemp3 table (DBName varchar(100),LogicalName sysname null,PhysicalName sysname null)
		--declare @tblRestoreString table (DB varchar(100),RestoreStr varchar(400))
		declare @DBtemp3Count int,@DB3 varchar(100),@DB3L varchar(100)

		insert @DBtemp3(DBName,LogicalName,PhysicalName)
		select  DatabaseName,LogicalName,PhysicalName from @DBLogicalPhysical

		select @DBtemp3Count = count(*) from @DBtemp3
		while @DBtemp3Count > 0
		
		
		begin
		select top 1 @DB3 = DBName, @lfile = LogicalName,@pfile = PhysicalName  from @DBtemp3 order by DBName
		--select @backupfile
		set @concat2 = ' WITH Move '''+@lfile+''' TO ''' +@DBDestinationFolder+''+@pfile+''''
		select @concat2
		delete @DBtemp3 where DBName = @DB3 and LogicalName = @lfile
		set @DBtemp3Count = @DBtemp3Count - 1
		end

	 --select @dbcount = COUNT(*) from @DBLogicalPhysical
  --while @dbcount > 0
  --begin
  --select top 1  @db = DatabaseName,@backupfile = BackupPath,@pfile = PhysicalName, @lfile = LogicalName  from @DBLogicalPhysical
  --select @db
  --set @concat1 = 'RESTORE DATABASE '+ QUOTENAME(@db) + 'FROM Disk = '+@backupfile  

				--select @dbfilecount = count(*) from @DBLogicalPhysical
				--while @dbfilecount > 0
				--begin
				--select top 1  @backupfile = BackupPath,@pfile = PhysicalName, @lfile = LogicalName  from @DBLogicalPhysical where DatabaseName = @db 
				----set @concat1 = 'RESTORE DATABASE '+ QUOTENAME(@db) + 'FROM Disk = '+@backupfile +' WITH Move ' 
				--set @concat2 = @concat2+'WITH Move '+@lfile +' TO '+@DBDestinationFolder+'\'+@pfile
				
				--delete @DBLogicalPhysical where PhysicalName = @pfile and DatabaseName = @db
				--if @dbfilecount = @dbfilecount
				--set @concat3 = @concat2
				--set @dbfilecount = @dbfilecount - 1
				--end
--select @concat1

--delete @DBLogicalPhysical where DatabaseName = @db
-- set @dbcount = @dbcount - 1
-- end
  /*
  RESTORE DATABASE [AdventureWorks2019] 
  FROM Disk ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\adw_1.bak',
  Disk ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\adw_2.bak',
  Disk ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\adw_3.bak' 
  WITH Move 'AdventureWorks2017' TO 'C:\SQLTest\TestRestore\AdventureWorks2019.mdf',
  Move 'AdventureWorks2017_log' TO 'C:\SQLTest\TestRestore\AdventureWorks2019_log.ldf';

  */




  select * from @DBLogicalPhysical
  select * from @BackupPath
  select * from @tblRestoreString
  --insert @DBName
  --select distinct DatabaseName from @BackupHeader;


/*** Get Logical and Physical Data Names ***/

  --Declare @logicalName varchar(100), @physicalPath varchar(100), @namecount int,
		--  @reversePhysicalPath varchar(100), @indexPosition int

--select @namecount = count(*) from @DBFileList

--while @Loop1 <= @Count1
--begin
--select top 1 @LogicalName = logicalName, @PhysicalPath = PhysicalName from @DBFileList


--select @ReversePhysicalPath = REVERSE(@physicalpath)
--select @CharIndex1 = CHARINDEX('\',@ReversePhysicalPath)
--select @PhysicalName = substring(@ReversePhysicalPath,1,@CharIndex1 - 1)
--select @PhysicalName = REVERSE(@PhysicalName)

--insert @DBLogicalPhysical
--select @LogicalName, @PhysicalName

--delete @DBFileList where LogicalName = @LogicalName and PhysicalName = @PhysicalPath

--set @Loop1 = @Loop1 + 1
--end

  --select * from @BackupHeader
  --select * from @BackupFileList
  --select * from @DBName
  ----select * from @BackupPath
  -- --insert @DBHeader
  -- --exec ('restore headeronly from disk = ''C:\temp\AdventureWorks2019.bak''')

  -- --select * from @DBHeader

   --restore headeronly from disk = 'C:\temp\AdventureWorks2019.bak'
   --restore filelistonly from disk = 'C:\temp\AdventureWorks2019.bak'
   --restore labelonly from disk = 'C:\temp\AdventureWorks2019.bak'


