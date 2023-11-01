:: DB BOOTSTRAP
:: Cria instancia de banco de dados no SQLServer e cria a tabela 
:: Tarefas

:: deve ser executado apos a execucao do script 'docker_sqlserver_start.cmd'
:: que executa um container com sqlserver
::
dotnet ef migrations add InitialCreate
dotnet ef database update
