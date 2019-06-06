USE [${database}]
GO
IF SCHEMA_ID(N'${registry}') IS NULL EXEC(N'CREATE SCHEMA [${registry}];');
GO
IF SCHEMA_ID(N'${registry}Import') IS NULL EXEC(N'CREATE SCHEMA [${registry}Import];');
GO
IF SCHEMA_ID(N'${registry}Legacy') IS NULL EXEC(N'CREATE SCHEMA [${registry}Legacy];');
GO
IF SCHEMA_ID(N'${registry}Extract') IS NULL EXEC(N'CREATE SCHEMA [${registry}Extract];');
GO
IF SCHEMA_ID(N'Redis') IS NULL EXEC(N'CREATE SCHEMA [Redis];');
GO
