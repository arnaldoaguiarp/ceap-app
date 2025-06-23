# Desafio Backend - Ranking de Gastos de Deputados

## 📖 Visão Geral

A plataforma permite o upload de um arquivo CSV contendo as despesas da Cota para o Exercício da Atividade Parlamentar (CEAP) e, a partir desses dados, exibe um ranking de gastos dos deputados de um determinado estado, com detalhamento de suas despesas.
O projeto foi construído com foco em boas práticas de desenvolvimento, escalabilidade e qualidade de código, utilizando um ambiente conteinerizado com Docker.

---

## ✨ Features

* **Upload de Arquivo CSV:** Interface para envio do arquivo de despesas (`Ano-2024.csv`).
* **Processamento Assíncrono:** O processamento do arquivo CSV é realizado em segundo plano utilizando o **Sidekiq**, garantindo que a interface do usuário não seja bloqueada durante a importação de dados.
* **API RESTful:** Backend em Rails que expõe endpoints para consulta dos dados processados.
* **Frontend Reativo:** Interface construída em React (Vite) para uma experiência de usuário fluida e moderna.

---

## 🛠️ Tech Stack

A aplicação foi desenvolvida utilizando as seguintes tecnologias e ferramentas:

* **Backend:**
    * Ruby 3.2.2
    * Ruby on Rails 7.1 (API mode)
    * Sidekiq (Processamento de Jobs em Background)
    * Puma (Application Server)
* **Frontend:**
    * React 18
    * Vite (Build Tool)
* **Banco de Dados & Cache:**
    * PostgreSQL 15
    * Redis 7
* **Qualidade de Código:**
    * RuboCop (Linter de Código)
* **Infraestrutura & DevOps:**
    * Docker
    * Docker Compose

---

## 🚀 Setup e Execução Local

### Pré-requisitos
* [Docker](https://www.docker.com/get-started/)
* [Docker Compose](https://docs.docker.com/compose/install/)

### Passo a Passo

1.  **Clone o repositório:**
    ```bash
    git clone [URL-DO-SEU-REPOSITORIO]
    cd nome-da-pasta-do-projeto
    ```

2.  **Construa e suba os containers:**
    Este comando irá construir as imagens do backend e frontend e iniciar todos os serviços (Rails, React, Sidekiq, PostgreSQL, Redis).
    ```bash
    docker-compose up --build
    ```

3.  **Prepare o banco de dados:**
    Em um **novo terminal**, na mesma pasta, execute os seguintes comandos para criar o banco de dados e rodar as migrations.
    ```bash
    docker-compose exec backend rails db:create
    docker-compose exec backend rails db:migrate
    ```
4.  **Acesse a aplicação!**
    * **Frontend:** Abra seu navegador e acesse `http://localhost:5173`
    * **UI do Sidekiq:** Monitore os jobs em `http://localhost:3000/sidekiq`

---

## 🧠 Decisões de Arquitetura e Trade-offs

Durante o desenvolvimento, algumas decisões foram tomadas para garantir a qualidade e escalabilidade do projeto:

* **Processamento Assíncrono com Sidekiq:** A importação e processamento de um arquivo CSV pode ser uma tarefa demorada. Para evitar que a requisição do usuário ficasse bloqueada esperando o término, a tarefa foi delegada a um job em background. Isso melhora drasticamente a experiência do usuário e a resiliência da aplicação.

* **Service Objects (`CsvProcessorService`):** A lógica de negócio para processar o CSV foi encapsulada em uma classe de serviço. Esta abordagem (SOLID) mantém os Controllers e Jobs menores e focados em suas responsabilidades primárias (orquestração), facilitando a manutenção e os testes da lógica de negócio de forma isolada.

* **Prevenção de N+1 Queries:** Foi tomada atenção especial para evitar o problema de N+1 nas consultas ao banco de dados, utilizando `includes` para Eager Loading e construindo queries com `joins` e `group by` para agregar dados de forma eficiente, garantindo a performance da API.

* **Ambiente Conteinerizado com Docker:** A escolha pelo Docker garante um ambiente de desenvolvimento padronizado, reprodutível e isolado, eliminando problemas de configuração entre diferentes máquinas e simplificando o processo de deploy futuro.

---

## 📈 Possíveis Melhorias Futuras

Se houvesse mais tempo para continuar o desenvolvimento, os próximos passos seriam:

* **Testes e Documentação:** Implementação do RSwag para uma documentação completa do projeto e testes com o RSpec.
* **Autenticação e Autorização:** Implementar um sistema de login para proteger o acesso à funcionalidade de upload.
* **Filtros Avançados:** Adicionar mais filtros à API (ex: por data, por tipo de despesa, por partido).
* **Paginação:** Implementar paginação nos endpoints que retornam listas longas (despesas de um deputado).
* **Testes de Frontend:** Adicionar uma suíte de testes para os componentes React utilizando Jest e React Testing Library.
* **Deploy:** Criar um pipeline de CI/CD para automatizar o deploy da aplicação em um serviço de nuvem como Heroku ou AWS.

---

## 👨‍💻 Autor

**[Arnaldo Aguiar]**

* **Email:** [arnaldoaguiarp@gmail.com](mailto:arnaldoaguiarp@gmail.com)
* **LinkedIn:** [https://www.linkedin.com/in/arnaldoaguiarp/](https://www.linkedin.com/in/arnaldoaguiarp/)
* **GitHub:** [https://github.com/arnaldoaguiarp](https://github.com/arnaldoaguiarp)