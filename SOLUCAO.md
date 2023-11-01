# Solução

## Para executar o projeto

### Iniciando um servidor sqlserver
Execute o script `docker_sqlserver_start.cmd` para subir um container
Docker com um sqlserver.

Ou, utilize o `(localdb)` caso tenha o sqlserver instalado na máquina. 
Nesse caso, utilize a string de conexão:

```json
"ConnectionStrings": {
    "ConexaoPadrao": "Server=(localdb)\\mssqllocaldb;Database=Dio.DesafioNetAPI.OrganizadorDb;Trusted_Connection=True;"
  }
```

### Criando o banco de dados e a tabela de Tarefas

Para criar os scripts de _Migrations_ e criar os objetos no servidor SQLServer, 
utilize o script `db_bootstra.cmd`.

Esse script vai criar/atualizar a pasta `Migrations` com os arquivos
.cs para a migração de dados e aplicá-los no servidor de banco de
dados.

```shell
db_bootstrap.cmd
D:\dev\github\dio\trilha-net-api-desafio>dotnet ef migrations add InitialCreate
Build started...
Build succeeded.
The name 'InitialCreate' is used by an existing migration.

D:\dev\github\dio\trilha-net-api-desafio>dotnet ef database update
Build started...
Build succeeded.
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (582ms) [Parameters=[], CommandType='Text', CommandTimeout='60']
      CREATE DATABASE [Dio.DesafioNetAPI.OrganizadorDb];
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (115ms) [Parameters=[], CommandType='Text', CommandTimeout='60']
      IF SERVERPROPERTY('EngineEdition') <> 5
      BEGIN
          ALTER DATABASE [Dio.DesafioNetAPI.OrganizadorDb] SET READ_COMMITTED_SNAPSHOT ON;
      END;
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (8ms) [Parameters=[], CommandType='Text', CommandTimeout='30']
      SELECT 1
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (7ms) [Parameters=[], CommandType='Text', CommandTimeout='30']
      CREATE TABLE [__EFMigrationsHistory] (
          [MigrationId] nvarchar(150) NOT NULL,
          [ProductVersion] nvarchar(32) NOT NULL,
          CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])  
      );
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (0ms) [Parameters=[], CommandType='Text', CommandTimeout='30']
      SELECT 1
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (22ms) [Parameters=[], CommandType='Text', CommandTimeout='30']
      SELECT OBJECT_ID(N'[__EFMigrationsHistory]');
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (4ms) [Parameters=[], CommandType='Text', CommandTimeout='30']
      SELECT [MigrationId], [ProductVersion]
      FROM [__EFMigrationsHistory]
      ORDER BY [MigrationId];
info: Microsoft.EntityFrameworkCore.Migrations[20402]
      Applying migration '20231101195404_InitialCreate'.
Applying migration '20231101195404_InitialCreate'.
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (2ms) [Parameters=[], CommandType='Text', CommandTimeout='30']
      CREATE TABLE [Tarefas] (
          [Id] int NOT NULL IDENTITY,
          [Titulo] nvarchar(max) NULL,
          [Descricao] nvarchar(max) NULL,
          [Data] datetime2 NOT NULL,
          [Status] int NOT NULL,
          CONSTRAINT [PK_Tarefas] PRIMARY KEY ([Id])
      );
info: Microsoft.EntityFrameworkCore.Database.Command[20101]
      Executed DbCommand (3ms) [Parameters=[], CommandType='Text', CommandTimeout='30']
      INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])  
      VALUES (N'20231101195404_InitialCreate', N'7.0.13');
Done.
```

## Testando os endpoints

### POST /Tarefa

Inserindo uma tarefa.

```bash
curl --insecure -X POST https://localhost:7295/Tarefa -H "Content-Type:application/json" -d '{ "titulo": "teste de desafio", "descricao":"Descricao do teste", "data":"2023-11-01T17:44:00.000Z", "status":"Pendente"}'
```

Inserindo segunda tarefa.

```bash
curl --insecure -X POST https://localhost:7295/Tarefa -H "Content-Type:application/json" -d '{ "titulo": "Segundo TESTE de desafio", "descricao":"Descricao do SEGUNDO teste", "data":"2023-11-01T17:52:00.000Z", "status":"Pendente"}'
```

### PUT /Tarefa/{id}

Alterando dados de uma tarefa.

```bash
curl --insecure -X PUT https://localhost:7295/Tarefa/2 -H "Content-Type:application/json" -d '{ "titulo": "Segundo TESTE de desafio (Alterado)", "descricao":"Descricao do SEGUNDO teste (Alterado)", "data":"2023-11-01T18:00:00.000Z", "status":"Pendente"}'
```

Alterando dados de uma tarefa inexistente.

```bash
curl --insecure -X PUT https://localhost:7295/Tarefa/3 -H "Content-Type:application/json" -d '{ "titulo": "Segundo TESTE de desafio (Alterado)", "descricao":"Descricao do SEGUNDO teste (Alterado)", "data":"2023-11-01T18:00:00.000Z", "status":"Pendente"}'
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   320    0   161  100   159   3865   3817 --:--:-- --:--:-- --:--:--  8000
{"type":"https://tools.ietf.org/html/rfc7231#section-6.5.4","title":"Not Found","status":404,"traceId":"00-3172541f4db5d5822e23132d9412bbc2-1d07b8659cc5f57c-00"}
```

### DELETE /Tarefa/{id}

Removendo registro de uma tarefa.

```bash
curl --insecure -X DELETE https://localhost:7295/Tarefa/1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
```

Tentando remover registro de uma tarefa inexistente.

```bash
curl --insecure -X DELETE https://localhost:7295/Tarefa/3
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   161    0   161    0     0   2067      0 --:--:-- --:--:-- --:--:--  2090
{"type":"https://tools.ietf.org/html/rfc7231#section-6.5.4","title":"Not Found","status":404,"traceId":"00-26473f566987e90cb990de88162457fd-8ce41c8fa06b6bad-00"}
```

### GET /Tarefa/{id}

Obtendo dados de uma tarefa.

```bash
curl --insecure https://localhost:7295/Tarefa/2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   156    0   156    0     0     76      0 --:--:--  0:00:02 --:--:--    76
{"id":2,"titulo":"Segundo TESTE de desafio (Alterado)","descricao":"Descricao do SEGUNDO teste (Alterado)","data":"2023-11-01T18:00:00","status":"Pendente"}
```

Consultando dados de uma tarefa inexistente.

```bash
curl --insecure https://localhost:7295/Tarefa/3
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   161    0   161    0     0   4776      0 --:--:-- --:--:-- --:--:--  5031
{"type":"https://tools.ietf.org/html/rfc7231#section-6.5.4","title":"Not Found","status":404,"traceId":"00-fc1e7866117b8b02459d3146e1bd5d03-e1e8487d12507570-00"}
```

### GET /Tarefa/ObterTodos

Consultando todas as tarefas cadastradas.

```bash
curl --insecure https://localhost:7295/Tarefa/ObterTodos
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   277    0   277    0     0   3461      0 --:--:-- --:--:-- --:--:--  3506
[{"id":2,"titulo":"Segundo TESTE de desafio (Alterado)","descricao":"Descricao do SEGUNDO teste (Alterado)","data":"2023-11-01T18:00:00","status":"Pendente"},{"id":3,"titulo":"teste de desafio","descricao":"Descricao do teste","data":"2023-11-01T17:44:00","status":"Pendente"}]
```

## GET /Tarefa/ObterPorTitulo

```bash
curl --insecure https://localhost:7295/Tarefa/ObterPorTitulo?titulo=teste
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   277    0   277    0     0   3955      0 --:--:-- --:--:-- --:--:--  4014
[{"id":2,"titulo":"Segundo TESTE de desafio (Alterado)","descricao":"Descricao do SEGUNDO teste (Alterado)","data":"2023-11-01T18:00:00","status":"Pendente"},{"id":3,"titulo":"teste de desafio","descricao":"Descricao do teste","data":"2023-11-01T17:44:00","status":"Pendente"}]
```

### GET /Tarefa/ObterPorData

```bash
 curl --insecure https://localhost:7295/Tarefa/ObterPorData?data=2023-11-01
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   277    0   277    0     0   9360      0 --:--:-- --:--:-- --:--:--  9892
[{"id":2,"titulo":"Segundo TESTE de desafio (Alterado)","descricao":"Descricao do SEGUNDO teste (Alterado)","data":"2023-11-01T18:00:00","status":"Pendente"},{"id":3,"titulo":"teste de desafio","descricao":"Descricao do teste","data":"2023-11-01T17:44:00","status":"Pendente"}]
```

### GET /Tarefa/ObterPosStatus

```bash
 curl --insecure https://localhost:7295/Tarefa/ObterPorStatus?status=Pendente
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   277    0   277    0     0  13647      0 --:--:-- --:--:-- --:--:-- 14578
[{"id":2,"titulo":"Segundo TESTE de desafio (Alterado)","descricao":"Descricao do SEGUNDO teste (Alterado)","data":"2023-11-01T18:00:00","status":"Pendente"},{"id":3,"titulo":"teste de desafio","descricao":"Descricao do teste","data":"2023-11-01T17:44:00","status":"Pendente"}]
```