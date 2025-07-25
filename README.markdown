# ProductManagerApp

Bem-vindo ao **ProductManagerApp**, um aplicativo Delphi VCL de 64 bits com uma API REST para gerenciar produtos. O aplicativo consiste em:

- **Front-end**: `ProductVclApp.exe`, uma interface VCL que consome a API REST.
- **Back-end**: `ProductManager.exe`, uma API REST usando Horse e FireDAC com PostgreSQL.
- **Testes**: Projetos de teste DUnitX para o front-end (`ProductVclAppTests.exe`) e back-end (`ProductManagerTests.exe`), usando SQLite em memória para testes.

Este guia explica como configurar, compilar e executar o aplicativo e os testes, com ou sem a IDE Delphi.

## Funcionalidades

- Listar produtos
- Adicionar Produto
- Deletar produto
- Editar produto

## Ferramentas utilizadas

- RAD Studio (delphi): Utilizado em toda a criação do projeto
- VCL: Framework para a interface gráfica.
- FireDAC: Conexão com bancos de dados (PostgreSQL para o aplicativo, SQLite para testes).
- Horse: Framework REST para a API em ProductManager.exe.
- DUnitX: Framework de testes unitários para ProductManagerTests.exe e ProductVclAppTests.exe.
- PostgreSQL: Banco de dados relacional para o aplicativo (requer libpq.dll).
- SQLite: Banco de dados em memória para testes.

## Requisitos

### Para Compilar (Requer IDE Delphi)

- **Delphi IDE**: Versão 2010 ou superior (recomendado: Delphi 11 ou 12).
- **Dependências**:
  - **FireDAC**: Incluído no Delphi, com suporte a PostgreSQL e SQLite.
  - **Horse**: Biblioteca REST para o back-end. Instale via GetIt Package Manager ou GitHub (`https://github.com/HashLoad/horse`).
  - **DUnitX**: Framework de testes unitários. Instale via GetIt ou GitHub (`https://github.com/VSoftTechnologies/DUnitX`).
- **PostgreSQL**: Servidor PostgreSQL (v12 ou superior) com o banco de dados `productdb` configurado.

### Para Executar os Executáveis Compilados

- **Windows 64-bit**: Necessário para rodar `ProductVclApp.exe`, `ProductManager.exe`, `ProductVclAppTests.exe`, e `ProductManagerTests.exe`.
- **PostgreSQL**: Necessário para `ProductManager.exe` e `ProductVclApp.exe`. Instale o PostgreSQL (`https://www.postgresql.org/download/windows/`) e configure o banco de dados `productdb`.
- **libpq.dll**: Biblioteca cliente PostgreSQL, geralmente incluída com a instalação do PostgreSQL. Certifique-se de que está no caminho do sistema (e.g., `C:\Program Files\PostgreSQL\<version>\bin`).
- **Nenhuma dependência adicional** é necessária para os testes, pois usam SQLite em memória (embutido no FireDAC).

## Estrutura do Projeto

- `vcl/`: Código-fonte do front-end VCL.
  - `ProductVclApp.dpr`: Projeto principal do front-end.
  - `ProductMainForm.pas`: Formulário principal VCL.
  - `ProductAPIClient.pas`: Cliente HTTP para consumir a API REST.
- `api/`: Código-fonte do back-end REST.
  - `ProductManager.dpr`: Projeto principal da API REST.
  - `ProductService.pas`: Lógica de negócios.
  - `ProductRepository.pas`: Acesso ao banco de dados (PostgreSQL no aplicativo, SQLite nos testes).
- `vcl/tests/`: Testes do front-end.
  - `ProductVclAppTests.dpr`: Projeto de testes DUnitX.
  - `TestProductAPIClient.pas`: Testes para o cliente HTTP.
- `api/tests/`: Testes do back-end.
  - `ProductManagerTests.dpr`: Projeto de testes DUnitX.
  - `TestProductService.pas`: Testes para `ProductService` e `ProductRepository`.
- `bin/`: Contém executáveis compilados para usuários sem IDE Delphi.

## Configuração do Ambiente

### 1. Configurar o PostgreSQL

1. Instale o PostgreSQL (v12 ou superior): `https://www.postgresql.org/download/windows/`.
2. Crie o banco de dados `productdb`:
   ```sql
   CREATE DATABASE productdb;
   ```
3. Crie a tabela `products`:
   ```sql
   \c productdb
   CREATE TABLE products (
       id SERIAL PRIMARY KEY,
       name TEXT NOT NULL,
       description TEXT,
       price REAL NOT NULL,
       stock INTEGER NOT NULL
   );
   ```
4. Insira dados de teste (opcional):
   ```sql
   INSERT INTO products (id, name, description, price, stock) VALUES (1, 'Test Product', 'Test Description', 10.0, 5);
   ```
5. Configure as credenciais no código:
   - Em `api/ProductRepository.pas`, atualize as credenciais do PostgreSQL:
     ```delphi
     FConnection.Params.Add('User_Name=postgres');
     FConnection.Params.Add('Password=your_password');
     ```
   - Substitua `your_password` pela senha do seu usuário PostgreSQL.

### 2. Configurar o Delphi (Para Compilação)

1. Instale as dependências:
   - **Horse**: `Tools > GetIt Package Manager > Search for Horse` ou adicione via GitHub.
   - **DUnitX**: `Tools > GetIt Package Manager > Search for DUnitX` ou adicione via GitHub.

### 3. Configurar para Executáveis Compilados

1. Baixe os executáveis do diretório `bin/`.
2. Certifique-se de que o PostgreSQL está configurado (veja acima).
3. Coloque `libpq.dll` no mesmo diretório dos executáveis ou no caminho do sistema (e.g., `C:\Program Files\PostgreSQL\<version>\bin`).

## Executando o Aplicativo

### Com a IDE Delphi

1. **Back-end (ProductManager.exe)**:
   - Abra `api/ProductManager.dpr`.
   - Configure para Win64: `Project > Options > Delphi Compiler > Target Platforms > Win64`.
   - Compile e execute (F9).
   - A API estará disponível em `http://localhost:9000`.
2. **Front-end (ProductVclApp.exe)**:
   - Abra `vcl/ProductVclApp.dpr`.
   - Configure para Win64.
   - Compile e execute (F9).
   - O aplicativo VCL se conectará à API em `http://localhost:9000`.
3. **Testes**:
   - **Back-end Tests**: Abra `api/tests/ProductManagerTests.dpr`, compile e execute (F9). Testes usam SQLite em memória.
   - **Front-end Tests**: Abra `vcl/tests/ProductVclAppTests.dpr`, compile e execute (F9). Para `TestUpdate`, descomente-o em `TestProductAPIClient.pas` e inicie `ProductManager.exe`.

### Sem a IDE Delphi (Usando Executáveis)

1. **Back-end**:
   - Execute `bin/ProductManager.exe` (certifique-se de que o PostgreSQL está rodando).
   - A API estará em `http://localhost:9000`.
2. **Front-end**:
   - Execute `bin/ProductVclApp.exe` (com `ProductManager.exe` rodando).
3. **Testes**:
   - Execute `bin/ProductManagerTests.exe` para testes do back-end.
   - Execute `bin/ProductVclAppTests.exe` para testes do front-end (inicie `ProductManager.exe` para `TestUpdate`).

## Executando os Testes

- **Back-end Tests (`ProductManagerTests.exe`)**:
  - Testa `ProductService.pas` e `ProductRepository.pas` usando SQLite em memória.
  - Saída no console ou em `TestProductService.log`.
  - Verifique:
    ```
    SQLite connection active: True
    Query row count: 1
    ```
- **Front-end Tests (`ProductVclAppTests.exe`)**:
  - Testa `ProductAPIClient.pas`.
