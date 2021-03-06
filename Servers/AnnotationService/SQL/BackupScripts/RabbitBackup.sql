

BACKUP DATABASE [Rabbit] TO  DISK = N'F:\DatabaseBackup\Rabbit\Rabbit.bak' WITH NOFORMAT, INIT,  NAME = N'Rabbit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
BACKUP DATABASE [Rabbit] TO  DISK = N'Z:\DatabaseBackup\Rabbit\Rabbit.bak' WITH NOFORMAT, INIT,  NAME = N'Rabbit-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'Rabbit' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'Rabbit' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''Rabbit'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'F:\DatabaseBackup\Rabbit\Rabbit.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
RESTORE VERIFYONLY FROM  DISK = N'Z:\DatabaseBackup\Rabbit\Rabbit.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO

BACKUP DATABASE [DebelloOB1] TO  DISK = N'F:\DatabaseBackup\Debello\DebelloOB1.bak' WITH NOFORMAT, INIT,  NAME = N'DebelloOB1-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
BACKUP DATABASE [DebelloOB1] TO  DISK = N'Z:\DatabaseBackup\Debello\DebelloOB1.bak' WITH NOFORMAT, INIT,  NAME = N'DebelloOB1-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'DebelloOB1' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'DebelloOB1' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''DebelloOB1'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'F:\DatabaseBackup\Debello\DebelloOB1.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
RESTORE VERIFYONLY FROM  DISK = N'Z:\DatabaseBackup\Debello\DebelloOB1.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO

BACKUP DATABASE [9482] TO  DISK = N'F:\DatabaseBackup\FelixDrew\9482.bak' WITH NOFORMAT, INIT,  NAME = N'9482-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
BACKUP DATABASE [9482] TO  DISK = N'Z:\DatabaseBackup\FelixDrew\9482.bak' WITH NOFORMAT, INIT,  NAME = N'9482-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'9482' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'9482' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''9482'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'F:\DatabaseBackup\FelixDrew\9482.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
RESTORE VERIFYONLY FROM  DISK = N'Z:\DatabaseBackup\FelixDrew\9482.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO


BACKUP DATABASE [6250-6A] TO  DISK = N'F:\DatabaseBackup\Remodeling\6250-6A.bak' WITH NOFORMAT, INIT,  NAME = N'6250-6A-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
BACKUP DATABASE [6250-6A] TO  DISK = N'Z:\DatabaseBackup\Remodeling\6250-6A.bak' WITH NOFORMAT, INIT,  NAME = N'6250-6A-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'6450-6A' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'9482' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''6450-6A'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'F:\DatabaseBackup\Remodeling\6250-6A.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
RESTORE VERIFYONLY FROM  DISK = N'Z:\DatabaseBackup\Remodeling\6250-6A.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO

BACKUP DATABASE [UserAccounts] TO  DISK = N'F:\DatabaseBackup\UserAccounts.bak' WITH NOFORMAT, INIT,  NAME = N'UserAccounts-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
BACKUP DATABASE [UserAccounts] TO  DISK = N'Z:\DatabaseBackup\UserAccounts.bak' WITH NOFORMAT, INIT,  NAME = N'UserAccounts-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'UserAccounts' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'UserAccounts' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''UserAccounts'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'F:\DatabaseBackup\UserAccounts.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
RESTORE VERIFYONLY FROM  DISK = N'Z:\DatabaseBackup\UserAccounts.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO

BACKUP DATABASE [RC2] TO  DISK = N'F:\DatabaseBackup\RC2.bak' WITH NOFORMAT, INIT,  NAME = N'RC2-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
BACKUP DATABASE [RC2] TO  DISK = N'Z:\DatabaseBackup\RC2.bak' WITH NOFORMAT, INIT,  NAME = N'RC2-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'RC2' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'RC2' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''RC2'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'F:\DatabaseBackup\RC2\RC2.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
RESTORE VERIFYONLY FROM  DISK = N'Z:\DatabaseBackup\RC2\RC2.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO