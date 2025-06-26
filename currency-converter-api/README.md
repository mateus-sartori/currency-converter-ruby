🚀 API Conversor de Moedas
API para conversão de moedas com autenticação JWT, desenvolvida em Ruby on Rails e Docker.

📋 Pré-requisitos
*   Docker e Docker Compose (recomendado)
*   Ou Ruby 3.4.1 + PostgreSQL

🐳 Execução com Docker (Recomendado)

1.  **Configure as variáveis de ambiente:**

    Crie ou edite o arquivo `.env` na raiz do projeto. Este arquivo é crucial para configurar a aplicação, definindo as variáveis de ambiente necessárias para o funcionamento correto. Certifique-se de que o arquivo `.env` esteja na raiz do projeto `currency-converter-api`.

    ```bash
    # Exemplo .env
      POSTGRES_DB=currency_converter_api_development
      POSTGRES_USER=postgres
      POSTGRES_PASSWORD=postgres

      DEVISE_JWT_SECRET_KEY=chave_super_secreta 
      CURRENCY_API_KEY=sua_chave_api # Obtenha sua chave em: [https://api.currencyapi.com/v3]
    ```

    **Importante:**
    *   Substitua `sua_chave_api` pela chave fornecida pelo serviço de API de câmbio [https://api.currencyapi.com/v3].
    *   A `DEVISE_JWT_SECRET_KEY` deve ser uma string complexa e mantida em segredo, pois é usada para assinar os tokens JWT.

    Você pode gerar uma chave secreta forte usando o seguinte comando no terminal dentro do web bash:

    ```bash
    bundle exec rails secret
    ```

    Este comando irá gerar uma string aleatória que pode ser usada como `JWT_SECRET_KEY`.

2.  **Inicie os containers:**

    ```bash
    docker-compose up -d
    ```

    A API estará disponível em: `http://localhost:3000/api/v1/`

3.  **Comandos úteis:**

    | Descrição             | Comando                         |
    | --------------------- | ------------------------------- |
    | Entrar na bash       | `docker-compose exec web bash` |
    | Rodar migrações       | `bundle exec rails db:migrate` |
    | Acessar console Rails | `bundle exec rails c`         |
    | Parar containers      | `docker-compose down`           |

🔧 Configuração Manual (Sem Docker)

1.  Instale Ruby 3.4.1 e PostgreSQL.
2.  Siga os passos do README original para configuração manual do banco de dados e dependências.

🔄 Mock de Usuário Automático

Um usuário de teste é criado automaticamente ao iniciar a aplicação.

*   **Email:** `hZ6Ys@example.com`
*   **Senha:** `password`

Utilize estas credenciais para testes rápidos. O mock é definido no arquivo `app/mocks/user_mock.rb`.
Para executar a rake task de mock, utilize o seguinte comando:
Entrar na bash do docker

`docker-compose exec web bash`
`bundle exec rails mock:run`

⚙️ Variáveis de Ambiente Obrigatórias

| Variável           | Descrição                       | Exemplo              |
| ------------------ | ------------------------------- | -------------------- |
| POSTGRES_USER      | Usuário do PostgreSQL          | postgres             |
| POSTGRES_PASSWORD  | Senha do PostgreSQL            | postgres             |
| POSTGRES_DB        | Nome do banco de dados         | currency_converter_api_development |
| CURRENCY_API_KEY   | Chave da API de câmbio         | chave_super_secreta  |
| DEVISE_JWT_SECRET_KEY | Chave secreta para tokens JWT | sua_chave_api        |

🚨 Troubleshooting

*   **Erros no Docker?**

    Execute `docker-compose down -v` e recrie os containers com `docker-compose up -d`.

*   **Problemas no mock?**

    Verifique os logs da aplicação com `docker-compose logs app`.

📌 Exemplo de Uso

(Adicione aqui um exemplo de como usar a API, com um request e response de exemplo)

🔗 Links Úteis

*   [Documentação da API](link_para_documentacao) (Manutenção)
*   [Swagger UI](link_para_swagger) (Manutenção)

✨ Pronto! Seu ambiente está configurado com Docker, variáveis de ambiente e um usuário mock para testes rápidos.