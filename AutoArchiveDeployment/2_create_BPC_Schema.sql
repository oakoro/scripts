/****** Create BPC Schema ******/
IF (SELECT SCHEMA_ID('BPC')) IS NULL
BEGIN
EXECUTE('CREATE SCHEMA [BPC];')
END