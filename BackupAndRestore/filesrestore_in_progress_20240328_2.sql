declare @DBDestinationFolder nvarchar(max) = 'C:\SQLTest\TestRestore\',@DBDestName varchar(100),
		@RestoreString nvarchar(max)

declare @DBLogicalPhysical table
(
LogicalName sysname null,
PhysicalName sysname null
)

declare @Loop2 int, @Count2 int, @BackupFile nvarchar(100), @Concat nvarchar(max)

declare @BackupFileStr table
(
BackupFileStr nvarchar(max)
)

declare @BackupPath table (Backuppath varchar(100) )

declare @DBName table (DBName varchar(100))

declare @DBNametemp table (DBName varchar(100))



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

   declare @DBLogicalPhysical1 table
(
LogicalName sysname null,
PhysicalName sysname null
)

   INSERT @BackupPath
   SELECT [column1]+'\'+[column2]+'\'+[column3]
  FROM [$DB].[dbo].[backup]

-- SELECT * FROM @BackupPath

/*********************************************************************************
**********************************************************************************/





/*** Extract backup information ***/
  Declare @filepath varchar(100), @filecount int,@logicalName varchar(100), @physicalPath varchar(100), @database varchar(100),
		  @reversePhysicalPath varchar(100), @indexPosition int, @logicalnameCount int, @physicalName varchar(100)

		  /*********************************************************************************
**********************************************************************************/

------------------------------------------------
SELECT @filecount = COUNT(*) FROM @BackupPath

WHILE @filecount > 0

BEGIN

---------------------------------------------------

 select top 1 @filepath = Backuppath from @BackupPath
 select @filepath

 insert @BackupHeader
  exec ('restore headeronly from disk = '+''''+@filepath+'''');

  insert @BackupFileList
  exec ('restore filelistonly from disk = ' +''''+@filepath +'''');

  select @DBDestName = databaseName from @BackupHeader

  if exists (select 1 from sys.databases where name = @DBDestName)
  begin
  set @DBDestName = @DBDestName+'_New'
  end

  declare @Loop1 int, @Count1 int, @Len1 int, @CharIndex1 int

set @Loop1 = 1

select @Count1 = count(*) from @BackupFileList

while @Loop1 <= @Count1
begin
select top 1 @LogicalName = logicalName, @PhysicalPath = PhysicalName from @BackupFileList


select @ReversePhysicalPath = REVERSE(@physicalpath)
select @CharIndex1 = CHARINDEX('\',@ReversePhysicalPath)
select @PhysicalName = substring(@ReversePhysicalPath,1,@CharIndex1 - 1)
select @PhysicalName = REVERSE(@PhysicalName)

insert @DBLogicalPhysical1
select @LogicalName, @PhysicalName

delete @BackupFileList where LogicalName = @LogicalName and PhysicalName = @PhysicalPath

set @Loop1 = @Loop1 + 1
end
 
set @Concat = 'Disk = ' +'''' +@filepath +''''

insert @BackupFileStr
select @Concat



declare @Loop3 int, @Count3 int, @BackupFileConcat nvarchar(max) = '', @BackupStr nvarchar(max), @BackupFileConcatFinal nvarchar(max)

set @Loop3 = 1
select @Count3 = count(*) from @BackupFileStr
set @BackupFileConcat = ''

	while @Loop3 <= @Count3
	begin
	select top 1 @BackupStr = BackupFileStr from @BackupFileStr
	set @BackupFileConcat = @BackupFileConcat + @BackupStr + ','
	
	if @Loop3 = @Count3
	set @BackupFileConcatFinal = 'RESTORE DATABASE '+QUOTENAME(@DBDestName) + ' FROM '+@BackupFileConcat 
	delete @BackupFileStr where BackupFileStr = @BackupStr
	set @Loop3 = @Loop3 + 1
	end
	
	----Move Logical file to destination

declare @Loop4 int, @Count4 int, @LogicalFileConcat nvarchar(max),@LogicalFileConcatFinal nvarchar(max), @LogicalStr nvarchar(100), @PhysicalStr nvarchar(100)

set @LogicalFileConcat = ''

--set @Loop4 = 1

select @Count4 =  count(*) from @DBLogicalPhysical1

while @Count4 > 0
Begin
select top 1 @LogicalStr = logicalName,  @PhysicalStr = physicalname from @DBLogicalPhysical1


----if @LogicalFileConcat != ''
set @LogicalFileConcat = @LogicalFileConcat  +','+'Move ' +'''' +@LogicalStr +'''' + ' TO ' +'''' +@DBDestinationFolder +@PhysicalStr +''''

if @Count4 = @Count4
select @LogicalFileConcatFinal = @LogicalFileConcat

delete @DBLogicalPhysical1 where logicalName = @LogicalStr and physicalname = @PhysicalStr
set @Count4 = @Count4 - 1
end
select @LogicalFileConcatFinal = substring(@LogicalFileConcatFinal,2,len(@LogicalFileConcatFinal))
--select @LogicalFileConcatFinal
	select @BackupFileConcatFinal = substring(@BackupFileConcatFinal,1,len(@BackupFileConcatFinal)-1)
	--select @BackupFileConcatFinal 
	select @BackupFileConcatFinal + ' WITH ' +@LogicalFileConcatFinal as '@BackupFileConcatFinal'

SET @filecount = @filecount - 1
DELETE @BackupPath WHERE Backuppath = @filepath
END	

