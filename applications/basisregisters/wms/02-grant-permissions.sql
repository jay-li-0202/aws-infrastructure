IF USER_ID(N'${user}') IS NULL EXEC(N'CREATE USER [${user}] FOR LOGIN [${user}];');
GO
sp_addrolemember N'db_owner', N'${user}';
GO
