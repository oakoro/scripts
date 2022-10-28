DECLARE @Dt DATETIME = GETDATE(),

@usr UNIQUEIDENTIFIER = (SELECT [userid] FROM [BPAUser] WHERE [BPAUser].username='admin'),
@mxDT DATETIME = (SELECT MAX(installedon) FROM [BPALicense])

SELECT CONVERT(VARCHAR(20),(@mxDt),103), CONVERT(VARCHAR(20),GETDATE(),103) 

IF (CONVERT(VARCHAR(20),(@mxDt),103) = CONVERT(VARCHAR(20),GETDATE(),103))
BEGIN
SELECT CONVERT(VARCHAR(20),(@mxDt),103) AS 'LicenseInstalledDate'
END
ELSE
BEGIN
INSERT INTO [BPALicense] ([licensekey], [installedon], [installedby])
values (
'LICENSE VALUE ENTERED HERE'
,@Dt,@usr)

SELECT MAX(installedon) AS 'LicenseWasInstalled' FROM [BPALicense]
END