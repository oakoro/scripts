DECLARE 
@Dt DATETIME = GETDATE(),
@usr UNIQUEIDENTIFIER = (SELECT [userid] FROM [BPAUser] WHERE [BPAUser].username='admin'),
@mxDT DATETIME = (SELECT MAX(installedon) FROM [BPALicense]),
@dbversion INT,
@result char(10),
@v7license nvarchar, --= $license,
@v6license nvarchar = 'hardcodedlicense',
@license nvarchar


SET @dbversion = (SELECT TOP(1) dbversion FROM [dbo].[BPADBVersion] order by scriptrundate DESC)

SET @result = CASE 
WHEN @dbversion = 444 THEN @license = @v7license
WHEN @dbversion = 481 THEN @license = @v7license
WHEN @dbversion = 486 THEN @license = @v7license
WHEN @dbversion = 501 THEN @license = @v7license
WHEN @dbversion = 523 THEN @license = @v7license
WHEN @dbversion = 533 THEN @license = @v7license
ELSE
@license = @v6license
END

SELECT @result;

--INSERT INTO [BPALicense] ([licensekey], [installedon], [installedby])
--values (
--    '@license',
--    @Dt,
--    @usr)

SELECT MAX(installedon) AS 'NewLicenseInstalled' FROM [BPALicense]