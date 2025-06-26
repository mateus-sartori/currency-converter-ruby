## 🛠️ Passo a Passo para Build do Projeto Quasar

### 🚀 Tecnologias Utilizadas
- **Framework**: Quasar com Vue 3 (Composition API)
- **Linguagem**: TypeScript
- **Gerenciamento de Estado**: Pinia (substituto do Vuex)
- **Requisições HTTP**: Axios com instância customizada
- **Autenticação**: JWT com armazenamento em cookies
- **Roteamento**: Vue Router
- **UI Components**: Biblioteca de componentes do Quasar
- **Linting/Formatação**: ESLint + Prettier

### Pré-requisitos
1. Node.js instalado (versão 18 ou superior)
2. Yarn ou npm instalado
3. Quasar CLI instalado globalmente

### Instalação
1. Navegue até o diretório do projeto:
   ```bash
   cd currency-converter-frontend
   ```
2. Instale as dependências:
   ```bash
   yarn install
   # ou
   npm install
   ```

### Configuração
1. Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:
   ```env
   VITE_WEB_BASE_URL=http://localhost:3000/  # Base URL para autenticação
   VITE_API_BASE_URL=http://localhost:3000/api/v1/  # Endpoint da API
   ```

### Executando o Projeto
1. Para rodar o projeto em modo de desenvolvimento:
   ```bash
   quasar dev
   ```
2. O projeto estará disponível em:
   ```bash
   http://localhost:9000
   ```

### Estrutura de Serviços
- **authenticate_service.ts**: Gerencia login/logout com JWT
- **axios_instance.ts**: Configuração global do Axios
- **user-store.ts**: Store Pinia para gerenciamento do estado do usuário

### Linting e Formatação
1. Para verificar problemas de código:
   ```bash
   yarn lint
   ```
2. Para formatar o código automaticamente:
   ```bash
   yarn format
   ```

### 📸 Preview da Aplicação

![Preview da Página Principal](./exemplo.png)

*Tela principal mostrando:*
- Conversor de moedas (integração com API)
- Histórico de transações (via Pinia Store)
- Autenticação JWT (via Service Layer)
