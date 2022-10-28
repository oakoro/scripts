--IF NOT EXISTS
--    (SELECT * FROM sys.symmetric_keys
--        WHERE symmetric_key_id = 101)
--BEGIN
--    CREATE MASTER KEY ENCRYPTION BY PASSWORD = '0C34C960-6621-4682-A123-C7EA08E3FC46' -- Or any newid().
--END
--GO
IF EXISTS
    (SELECT * FROM sys.database_scoped_credentials
        -- TODO: Assign AzureStorageAccount name, and the associated Container name.
        WHERE name = 'https://gmstorageaccountxevent.blob.core.windows.net/gmcontainerxevent')
BEGIN
    DROP DATABASE SCOPED CREDENTIAL
        -- TODO: Assign AzureStorageAccount name, and the associated Container name.
        [https://oaazstorageacct.blob.core.windows.net/extendedevent] ;
END
GO

CREATE
    DATABASE SCOPED
    CREDENTIAL
        -- use '.blob.',   and not '.queue.' or '.table.' etc.
        -- TODO: Assign AzureStorageAccount name, and the associated Container name.
        [https://oaazstorageacct.blob.core.windows.net/extendedevent]
    WITH
        IDENTITY = 'SHARED ACCESS SIGNATURE',  -- "SAS" token.
        -- TODO: Paste in the long SasToken string here for Secret, but exclude any leading '?'.
        SECRET = 'sp=rwle&st=2022-04-27T10:36:06Z&se=2022-04-27T18:36:06Z&spr=https&sv=2020-08-04&sr=c&sig=2Wql7Ov6piL4IxhX7OWhx86zT8hHIr%2Frswtd8zBDse8%3D'
    ;
GO
--drop master key