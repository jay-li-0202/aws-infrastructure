# Useful commands

## SSH

### SSH - Port Forward via Bastion (Production)

```bash
ssh -i <your_private_key.pem> \
    -L 9000:es.basisregisters.local:443 \
    -L 9001:db.basisregisters.local:1433 \
    -L 6379:cache.basisregisters.local:6379 \
    root@<bastion_ip>
```

### SSH - Port Forward via Bastion (Staging)

```bash
ssh -i <your_private_key.pem> \
    -L 9000:es.staging-basisregisters.local:443 \
    -L 9001:db.staging-basisregisters.local:1433 \
    -L 6379:cache.staging-basisregisters.local:6379 \
    root@<bastion_ip>
```

## SQL

### SQL - Find all ColumnStore indices

```sql
SELECT OBJECT_SCHEMA_NAME(OBJECT_ID) SchemaName,
       OBJECT_NAME(OBJECT_ID) TableName,
       i.name AS IndexName,
       i.type_desc IndexType
  FROM sys.indexes AS i
 WHERE is_hypothetical = 0
   AND i.index_id <> 0
   AND i.type_desc IN ('CLUSTERED COLUMNSTORE','NONCLUSTERED COLUMNSTORE')
```

### SQL - Delete all tables and sequences

```sql
SELECT ' DROP TABLE ' + QUOTENAME(DB_NAME()) + '.' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
  FROM sys.tables t
  JOIN sys.schemas s
    ON t.[schema_id] = s.[schema_id]
 WHERE t.type = 'U'
 UNION
SELECT ' DROP VIEW ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(v.NAME) + '; '
  FROM sys.views v
  JOIN sys.schemas s
    ON v.[schema_id] = s.[schema_id]
 UNION
SELECT ' DROP SEQUENCE ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
  FROM sys.sequences t
  JOIN sys.schemas s
    ON t.[schema_id] = s.[schema_id]
```

### SQL - Select all ProjectionStates

```sql
SELECT 'DECLARE @Events INT' + CHAR(13) + CHAR(10) +
       'SELECT @Events = COUNT(*) - 1 FROM ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + CHAR(13) + CHAR(10) +
       'SELECT ''' + QUOTENAME(s.NAME) + ''' AS Name, @Events AS Position, '''' As Status UNION' + CHAR(13) + CHAR(10)
  FROM sys.tables t
  JOIN sys.schemas s
    ON t.[schema_id] = s.[schema_id]
 WHERE t.type = 'U'
   AND t.name like '%Messages%'
 UNION
SELECT 'SELECT  Name, Position, IIF(Position = @Events, ''Ready'', ''Running'') AS Status FROM ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + ' UNION '
  FROM sys.tables t
  JOIN sys.schemas s
    ON t.[schema_id] = s.[schema_id]
 WHERE t.type = 'U'
   AND t.name like '%ProjectionStates%'
```

```sql
sp_MSforeachdb 'IF EXISTS (SELECT "?" AS DB, * FROM [?].sys.tables WHERE name like ''%ProjectionStates%'')
SELECT ''SELECT * FROM [?].'' + QUOTENAME(s.NAME) + ''.'' + QUOTENAME(t.NAME) + ''; ''
  FROM [?].sys.tables t
  JOIN [?].sys.schemas s
    ON t.[schema_id] = s.[schema_id]
 WHERE t.type = ''U''
   AND t.name like ''%ProjectionStates%'''
```

### SQL - Show Missing Index Suggestions

```sql
SELECT db.[name] AS [DatabaseName]
    ,id.[object_id] AS [ObjectID]
    ,OBJECT_NAME(id.[object_id], db.[database_id]) AS [ObjectName]
    ,id.[statement] AS [FullyQualifiedObjectName]
    ,id.[equality_columns] AS [EqualityColumns]
    ,id.[inequality_columns] AS [InEqualityColumns]
    ,id.[included_columns] AS [IncludedColumns]
    ,gs.[unique_compiles] AS [UniqueCompiles]
    ,gs.[user_seeks] AS [UserSeeks]
    ,gs.[user_scans] AS [UserScans]
    ,gs.[last_user_seek] AS [LastUserSeekTime]
    ,gs.[last_user_scan] AS [LastUserScanTime]
    ,gs.[avg_total_user_cost] AS [AvgTotalUserCost]  -- Average cost of the user queries that could be reduced by the index in the group.
    ,gs.[avg_user_impact] AS [AvgUserImpact]  -- The value means that the query cost would on average drop by this percentage if this missing index group was implemented.
    ,gs.[system_seeks] AS [SystemSeeks]
    ,gs.[system_scans] AS [SystemScans]
    ,gs.[last_system_seek] AS [LastSystemSeekTime]
    ,gs.[last_system_scan] AS [LastSystemScanTime]
    ,gs.[avg_total_system_cost] AS [AvgTotalSystemCost]
    ,gs.[avg_system_impact] AS [AvgSystemImpact]  -- Average percentage benefit that system queries could experience if this missing index group was implemented.
    ,gs.[user_seeks] * gs.[avg_total_user_cost] * (gs.[avg_user_impact] * 0.01) AS [IndexAdvantage]
    ,'CREATE INDEX [IX_' + OBJECT_NAME(id.[object_id], db.[database_id]) + '_' + REPLACE(REPLACE(REPLACE(ISNULL(id.[equality_columns], ''), ', ', '_'), '[', ''), ']', '') + CASE
        WHEN id.[equality_columns] IS NOT NULL
            AND id.[inequality_columns] IS NOT NULL
            THEN '_'
        ELSE ''
        END + REPLACE(REPLACE(REPLACE(ISNULL(id.[inequality_columns], ''), ', ', '_'), '[', ''), ']', '') + '_' + LEFT(CAST(NEWID() AS [nvarchar](64)), 5) + ']' + ' ON ' + id.[statement] + ' (' + ISNULL(id.[equality_columns], '') + CASE
        WHEN id.[equality_columns] IS NOT NULL
            AND id.[inequality_columns] IS NOT NULL
            THEN ','
        ELSE ''
        END + ISNULL(id.[inequality_columns], '') + ')' + ISNULL(' INCLUDE (' + id.[included_columns] + ')', '') AS [ProposedIndex]
    ,CAST(CURRENT_TIMESTAMP AS [smalldatetime]) AS [CollectionDate]
FROM [sys].[dm_db_missing_index_group_stats] gs WITH (NOLOCK)
INNER JOIN [sys].[dm_db_missing_index_groups] ig WITH (NOLOCK) ON gs.[group_handle] = ig.[index_group_handle]
INNER JOIN [sys].[dm_db_missing_index_details] id WITH (NOLOCK) ON ig.[index_handle] = id.[index_handle]
INNER JOIN [sys].[databases] db WITH (NOLOCK) ON db.[database_id] = id.[database_id]
WHERE  db.[database_id] = DB_ID()
--AND OBJECT_NAME(id.[object_id], db.[database_id]) = 'YourTableName'
ORDER BY ObjectName, [IndexAdvantage] DESC
OPTION (RECOMPILE);
```

### SQL - Show SQL Query for Missing Index Suggestions

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO

WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
, PlanMissingIndexes
AS (SELECT query_plan, usecounts
    FROM sys.dm_exec_cached_plans cp
    CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
    WHERE qp.query_plan.exist('//MissingIndexes') = 1)
, MissingIndexes
AS (SELECT stmt_xml.value('(QueryPlan/MissingIndexes/MissingIndexGroup/MissingIndex/@Database)[1]', 'sysname') AS DatabaseName,
           stmt_xml.value('(QueryPlan/MissingIndexes/MissingIndexGroup/MissingIndex/@Schema)[1]', 'sysname') AS SchemaName,
           stmt_xml.value('(QueryPlan/MissingIndexes/MissingIndexGroup/MissingIndex/@Table)[1]', 'sysname') AS TableName,
           stmt_xml.value('(QueryPlan/MissingIndexes/MissingIndexGroup/@Impact)[1]', 'float') AS Impact,
           ISNULL(CAST(stmt_xml.value('(@StatementSubTreeCost)[1]', 'VARCHAR(128)') AS FLOAT), 0) AS Cost,
           pmi.usecounts UseCounts,
           STUFF((SELECT DISTINCT ', ' + c.value('(@Name)[1]', 'sysname')
      FROM stmt_xml.nodes('//ColumnGroup') AS t(cg)
     CROSS APPLY cg.nodes('Column') AS r(c)
     WHERE cg.value('(@Usage)[1]', 'sysname') = 'EQUALITY'
          FOR XML PATH('')),1,2,'') AS equality_columns,
           STUFF(( SELECT DISTINCT ', ' + c.value('(@Name)[1]', 'sysname')
          FROM stmt_xml.nodes('//ColumnGroup') AS t(cg)
          CROSS APPLY cg.nodes('Column') AS r(c)
          WHERE cg.value('(@Usage)[1]', 'sysname') = 'INEQUALITY'
          FOR XML PATH('')),1,2,'') AS inequality_columns,
           STUFF((SELECT DISTINCT ', ' + c.value('(@Name)[1]', 'sysname')
          FROM stmt_xml.nodes('//ColumnGroup') AS t(cg)
          CROSS APPLY cg.nodes('Column') AS r(c)
          WHERE cg.value('(@Usage)[1]', 'sysname') = 'INCLUDE'
          FOR XML PATH('')),1,2,'') AS include_columns,
           query_plan,
           stmt_xml.value('(@StatementText)[1]', 'varchar(4000)') AS sql_text
    FROM PlanMissingIndexes pmi
    CROSS APPLY query_plan.nodes('//StmtSimple') AS stmt(stmt_xml)
    WHERE stmt_xml.exist('QueryPlan/MissingIndexes') = 1)

SELECT TOP 200
       DatabaseName,
       SchemaName,
       TableName,
       equality_columns,
       inequality_columns,
       include_columns,
       UseCounts,
       Cost,
       Cost * UseCounts [AggregateCost],
       Impact,
       query_plan
FROM MissingIndexes
WHERE DatabaseName = '[YourDatabaseName]' AND TableName = '[YourTableName]'
ORDER BY Cost * UseCounts DESC;
```

## Redis

### Redis - Connect to cluster

* Be sure to have `redis-tools` installed (`apt-get install redis-tools`)
* From a bastion, use `redis-cli -h cache.staging-basisregisters.local`
* From a development station, use `redis-cli -h 127.0.0.1 -p 6379`

### Redis - List all nodes and store in variable

```bash
NODES=`redis-cli -h cache.staging-basisregisters.local cluster nodes | cut -f2 -d' '`
echo $NODES
```

### Redis - Clear entire cluster

```bash
for node in $NODES; do echo Flushing node $node...; redis-cli -h ${node%:*} -p ${node##*:} flushall; done
```

### Redis - Clear keys based on wildcard

This can only be done on a bastion, since it has to connect to all nodes seperately using their AWS internal ip.

Make sure the following scripts are present on the bastion:

> maintenance\redis\clear-redis-key.sh
> maintenance\redis\scan-match.sh

To test, you can use `./scan-match.sh legacy/municipality` which should return all municipality keys.

When you are certain, you can execute `./clear-redis-key.sh legacy/municipality` to clear these keys.

## Terraform

### Delete all terraform folders

```bash
find -type d -name ".terraform" -exec rm -rf {} \;
```

## Paket

### List all outdated packages

```bash
rm -rf /tmp/repos-outdated.txt; forrepos "git pull; sleep 5; echo 'Pulled '(pwd); echo (pwd) >> /tmp/repos-outdated.txt; mono .paket/paket.exe outdated --ignore-constraints | awk '/Outdated packages found:/,/Performance:/' >> /tmp/repos-outdated.txt; sleep 5; echo >> /tmp/repos-outdated.txt; echo 'Outdated '(pwd);"; echo 'Outdated check done!!'
```

### ECS - Metadata

```json
{
  "Cluster":"arn:aws:ecs:eu-west-1:xxxxxxxxxxx:cluster/project-production",
  "TaskARN":"arn:aws:ecs:eu-west-1:xxxxxxxxxxx:task/beefb00b-6de6-4c11-ab89-c80839b70ea8",
  "Family":"david-production-bastion",
  "Revision":"5",
  "DesiredStatus":"RUNNING",
  "KnownStatus":"RUNNING",
  "Containers":[
    {
      "DockerId":"d72a67da4986d6c199261dfa78c821fbc5d37a644b13828e046026afa0e82273",
      "Name":"david-production-bastion",
      "DockerName":"ecs-david-production-bastion-5-david-production-bastion-dec291e7d6ec9bf09001",
      "Image":"basisregisters/bastion:latest",
      "ImageID":"sha256:4678e1d08c2a1234d52bfb8c12345d40f7bfd06384ddf3d9921fe02db5518661",
      "Labels":{
        "com.amazonaws.ecs.cluster":"arn:aws:ecs:eu-west-1:xxxxxxxxxxx:cluster/project-production",
        "com.amazonaws.ecs.container-name":"david-production-bastion",
        "com.amazonaws.ecs.task-arn":"arn:aws:ecs:eu-west-1:xxxxxxxxxxx:task/beefb00b-6de6-4c11-ab89-c80839b70ea8",
        "com.amazonaws.ecs.task-definition-family":"david-production-bastion",
        "com.amazonaws.ecs.task-definition-version":"5"
      },
      "DesiredStatus":"RUNNING",
      "KnownStatus":"RUNNING",
      "Limits":{
        "CPU":256,
        "Memory":512
      },
      "CreatedAt":"2019-04-17T16:03:32.477798353Z",
      "StartedAt":"2019-04-17T16:03:33.11989194Z",
      "Type":"NORMAL",
      "Networks":[
        {
          "NetworkMode":"awsvpc",
          "IPv4Addresses":[
            "x.x.x.x"
          ]
        }
      ]
    }
  ],
  "Limits":{
    "CPU":0.25,
    "Memory":512
  },
  "PullStartedAt":"2019-04-17T16:03:27.212830141Z",
  "PullStoppedAt":"2019-04-17T16:03:32.47066787Z"
}
```
