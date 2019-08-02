USE [${database}]
GO
IF SCHEMA_ID(N'${registry}') IS NULL EXEC(N'CREATE SCHEMA [${registry}];');
GO
IF SCHEMA_ID(N'Redis') IS NULL EXEC(N'CREATE SCHEMA [Redis];');
GO
