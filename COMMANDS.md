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
SELECT OBJECT_SCHEMA_NAME(OBJECT_ID) SchemaName, OBJECT_NAME(OBJECT_ID) TableName, i.name AS IndexName, i.type_desc IndexType
FROM sys.indexes AS i 
WHERE is_hypothetical = 0 
  AND i.index_id <> 0 
  AND i.type_desc IN ('CLUSTERED COLUMNSTORE','NONCLUSTERED COLUMNSTORE')
  ```

### SQL - Delete all tables and sequences

```sql
SELECT ' DROP TABLE ' + QUOTENAME(DB_NAME()) + '.' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U'
UNION
SELECT ' DROP VIEW ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(v.NAME) + '; '
FROM   sys.views v
       JOIN sys.schemas s
         ON v.[schema_id] = s.[schema_id]
UNION
SELECT ' DROP SEQUENCE ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
FROM   sys.sequences t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
```

### SQL - Select all ProjectionStates

```sql
SELECT 'DECLARE @Events INT' + CHAR(13) + CHAR(10) +
       'SELECT @Events = COUNT(*) - 1 FROM ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + CHAR(13) + CHAR(10) +
       'SELECT ''' + QUOTENAME(s.NAME) + ''' AS Name, @Events AS Position, '''' As Status UNION' + CHAR(13) + CHAR(10)
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U'
  AND  t.name like '%Messages%'
UNION
SELECT 'SELECT  Name, Position, IIF(Position = @Events, ''Ready'', ''Running'') AS Status FROM ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + ' UNION '
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U'
  AND  t.name like '%ProjectionStates%'
```

```sql
sp_MSforeachdb 'IF EXISTS (SELECT "?" AS DB, * FROM [?].sys.tables WHERE name like ''%ProjectionStates%'')
SELECT ''SELECT * FROM [?].'' + QUOTENAME(s.NAME) + ''.'' + QUOTENAME(t.NAME) + ''; ''
FROM   [?].sys.tables t
       JOIN [?].sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = ''U''
  AND  t.name like ''%ProjectionStates%'''
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
