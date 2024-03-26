SET NOCOUNT ON

declare @RestoreDate datetime
declare @DBName nvarchar(100)
declare @DBDestName nvarchar(100)
declare @BackupType nchar(1)
declare @FirstFullBackupDate datetime
declare @DiffBackupDate datetime
declare @DBDestinationFolder nvarchar(max)
declare @RestoreInitString nvarchar(max)
declare @RestoreString nvarchar(max)

declare @LogicalName nvarchar(100)
declare @PhysicalPath nvarchar(max)
declare @ReversePhysicalPath nvarchar(max)
declare @PhysicalName nvarchar(100)
declare @FullBackupFile nvarchar(max)
declare @RestoreFromString nvarchar(max)
declare @RestoreDiff nvarchar(max)
declare @DiffFile nvarchar(max)
declare @RestoreTLog nvarchar(max)
declare @With nvarchar(max)
declare @WithReplace nvarchar(max)
declare @AlterDB nvarchar(max)

set @RestoreDate = getdate()
set @DBName = 'AdventureWorks2019'
set @DBDestinationFolder = 'C:\SQLTest\TestRestore\'

if (@DBDestName = '' or @DBDestName is null) set @DBDestName = @DBName

declare @BackupFiles table 
(
BackupFile nvarchar(max),
BackupDate datetime,
BackupType nchar(1)
)

declare @DBFileList table
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

declare @DBLogicalPhysical table
(
LogicalName sysname null,
PhysicalName sysname null
)

----------------------------------------
--Collect Backup Files
------------------------------------------
if exists(select top 1 database_name from msdb.dbo.backupset a
join [msdb].[dbo].[backupmediafamily] b
on a.media_set_id = b.media_set_id
where a.database_name = @DBName)

begin
--Collect Full Backup Files
select top 1 @FirstFullBackupDate = a.backup_finish_date from 
msdb.dbo.backupset a
join [msdb].[dbo].[backupmediafamily] b
on a.media_set_id = b.media_set_id
where a.type = 'D' and a.database_name = @DBName and a.backup_finish_date <= @RestoreDate
and device_type <> 7
order by a.backup_finish_date desc

--select @FirstFullBackupDate


insert @BackupFiles
select b.[physical_device_name],a.backup_finish_date,a.type
from msdb.dbo.backupset a
join [msdb].[dbo].[backupmediafamily] b
on a.media_set_id = b.media_set_id
where a.backup_finish_date = @FirstFullBackupDate
end 

if exists(select top 1 database_name from msdb.dbo.backupset a
join [msdb].[dbo].[backupmediafamily] b
on a.media_set_id = b.media_set_id
where a.database_name = @DBName and a.type = 'I' and device_type <> 7
and a.backup_finish_date between @FirstFullBackupDate and @RestoreDate
) 
begin
insert @BackupFiles
select b.[physical_device_name],a.backup_finish_date,a.type
from msdb.dbo.backupset a
join [msdb].[dbo].[backupmediafamily] b
on a.media_set_id = b.media_set_id
where a.database_name = @DBName and a.type = 'I' 
and a.backup_finish_date between @FirstFullBackupDate and @RestoreDate
and device_type <> 7
end

 --Collect Tlog Backup Files
 if exists(select top 1 database_name from msdb.dbo.backupset a
join [msdb].[dbo].[backupmediafamily] b
on a.media_set_id = b.media_set_id
where a.database_name = @DBName and a.type = 'L' and device_type <> 7
and a.backup_finish_date between @DiffBackupDate and @RestoreDate
) 

insert @BackupFiles
select b.[physical_device_name],a.backup_finish_date,a.type
from msdb.dbo.backupset a
join [msdb].[dbo].[backupmediafamily] b
on a.media_set_id = b.media_set_id
where a.database_name = @DBName and a.type = 'L' 
and a.backup_finish_date between @DiffBackupDate and @RestoreDate


--Get Logical and Physical Data Names

if exists(select top 1* from @BackupFiles where BackupType = 'D') 
begin
select top 1 @FullBackupFile = BackupFile from @BackupFiles where BackupType = 'D'

insert @DBFileList
exec ('restore filelistonly from disk = ' +''''+@fullbackupfile +'''')
end


declare @Loop1 int, @Count1 int, @Len1 int, @CharIndex1 int

set @Loop1 = 1

select @Count1 = count(*) from @DBFileList

while @Loop1 <= @Count1
begin
select top 1 @LogicalName = logicalName, @PhysicalPath = PhysicalName from @DBFileList


select @ReversePhysicalPath = REVERSE(@physicalpath)
select @CharIndex1 = CHARINDEX('\',@ReversePhysicalPath)
select @PhysicalName = substring(@ReversePhysicalPath,1,@CharIndex1 - 1)
select @PhysicalName = REVERSE(@PhysicalName)

insert @DBLogicalPhysical
select @LogicalName, @PhysicalName

delete @DBFileList where LogicalName = @LogicalName and PhysicalName = @PhysicalPath

set @Loop1 = @Loop1 + 1
end

--Identify if there are multiple full backup files

declare @Loop2 int, @Count2 int, @BackupFile nvarchar(100), @Concat nvarchar(max)

declare @BackupFileStr table
(
BackupFileStr nvarchar(max)
)


set @Loop2 = 1

select @Count2 = COUNT(*) from @BackupFiles where BackupType = 'D'
while @Loop2 <= @Count2
begin
select top 1 @BackupFile = BackupFile  from @BackupFiles where BackupType = 'D'


set @Concat = 'Disk =' +'''' +@BackupFile +''''

insert @BackupFileStr
select @Concat

delete @BackupFiles where BackupFile = @BackupFile
set @Loop2 = @Loop2 + 1
end

----
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
	
	select @BackupFileConcatFinal = substring(@BackupFileConcatFinal,1,len(@BackupFileConcatFinal)-1)
	--select @BackupFileConcatFinal

	
	

----Move Logical file to destination

declare @Loop4 int, @Count4 int, @LogicalFileConcat nvarchar(max),@LogicalFileConcatFinal nvarchar(max), @LogicalStr nvarchar(100), @PhysicalStr nvarchar(100)

set @LogicalFileConcat = ''

set @Loop4 = 1

select @Count4 = count(*) from @DBLogicalPhysical

while @Loop4 <= @Count4
Begin
select top 1 @LogicalStr = logicalName,  @PhysicalStr = physicalname from @DBLogicalPhysical


--if @LogicalFileConcat != ''
set @LogicalFileConcat = @LogicalFileConcat  +','+'Move ' +'''' +@LogicalStr +'''' + ' TO ' +'''' +@DBDestinationFolder +@PhysicalStr +''''

if @Loop4 = @Count4
select @LogicalFileConcatFinal = @LogicalFileConcat

delete @DBLogicalPhysical where logicalName = @LogicalStr and physicalname = @PhysicalStr
set @Loop4 = @Loop4 + 1
end

select @LogicalFileConcatFinal = substring(@LogicalFileConcatFinal,2,len(@LogicalFileConcatFinal))

set @RestoreString = @BackupFileConcatFinal + ' WITH ' +@LogicalFileConcatFinal+';'

---------------------------------------------
-----Restore Database From Full Backup Files
----------------------------------------------
if exists(select * from master.sys.databases where name = @DBDestName) 
begin
set @AlterDB = 'Alter Database ' +@DBDestName + ' set single_user with rollback immediate;'
PRINT @AlterDB
set @RestoreFromString = @RestoreString 
PRINT @RestoreFromString
end
else
begin
set @RestoreFromString = @RestoreString 
PRINT @RestoreFromString
END


