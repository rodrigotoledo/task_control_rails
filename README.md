# Curso: Desenvolvimento de Aplicações com Ruby on Rails - Tasks Control

Neste curso, vamos aprender a desenvolver uma aplicação web utilizando o framework Ruby on Rails, denominada Tasks Control. Ao longo deste curso, abordaremos desde a instalação das tecnologias necessárias até a exposição do projeto para acesso externo utilizando o NGrok.

## Tecnologias Utilizadas

- **Ruby on Rails**: Framework web MVC para desenvolvimento rápido de aplicações web em Ruby.
- **Banco de Dados SQL_LITE**: Banco de dados leve e de fácil integração com o Rails para armazenamento dos dados da aplicação.
- **NGrok**: Ferramenta para criação de túneis que permite expor projetos locais para acesso externo.

## Diferenciais do Curso

- Instalação e utilização do RVM para controle de versões do Ruby e gerenciamento de ambientes.
- Implementação de manipulação de dados por meio de navegador e API, refletindo alterações em tempo real.
- Cobertura completa de testes utilizando RSpec para garantir a qualidade do código.
- Utilização do NGrok para expor o projeto para acesso externo, facilitando o desenvolvimento e integração com outras aplicações.

## Conteúdo do Curso

### 1. Instalando o RVM

O RVM será utilizado para gerenciar as versões do Ruby e os ambientes de desenvolvimento. Será instalado através do seguinte procedimento:

- Acesse [https://rvm.io/](https://rvm.io/) e siga as instruções para instalação.

### 2. Criando e Inicializando o Projeto Rails

Com o RVM instalado, vamos criar e inicializar o ambiente do projeto Rails:

```bash
rvm use 3.2.1@tasks_control --create
gem install rails --no-doc
rails new tasks_control -T
```

Com isto a versão mais recente do framework Rails sera instalada no ambiente (gemset) do projeto.

Sera criado o projeto `tasks_control`. Dentro da pasta provavelmente nao existira um arquivo chamado .ruby-gemset, entre na pasta e caso realmente nao exista, crie ele e escreva dentro dele `tasks_control`. Com isso o projeto sabera que deve instalar bibliotecas `gems` somente dentro desse ambiente.

Entao para iniciarmos o projeto, vamos rodar dentro da pasta:

```bash
bundle install
rails db:drop db:create db:migrate
rails s
```

### 3. Configurando Bibliotecas para Desenvolvimento

Configuraremos as bibliotecas necessárias para o desenvolvimento da aplicação, como RSpec, Faker, FactoryBot, Guard e outras. Abaixo, esta o conteudo que sera acrescentado ao arquivo Gemfile

```ruby
# Gemfile

group :development, :test do
  # Ferramenta para debugar
  gem 'byebug', '~> 11.1'
  # Carrega variáveis de ambiente a partir de um arquivo .env
  gem 'dotenv-rails'
  # Facilita a criação de mocks de objetos em testes
  gem 'factory_bot_rails'
  # Gera dados falsos para testes
  gem 'faker', '~> 3.2'
  # Guarda e executa automaticamente os testes
  gem 'guard-rspec', '~> 4.7'
  # Framework de testes RSpec
  gem 'rspec-rails'
  # Adiciona suporte para testes com shoulda-matchers
  gem 'shoulda-matchers', require: false
  # Analisa a cobertura de código dos testes
  gem 'simplecov'
end

group :development do
  # Anota os modelos com informações do schema do banco de dados
  gem 'annotate'
  # Ferramenta de segurança para Rails
  gem 'brakeman'
  # Ajuda a detectar queries N+1 em ActiveRecord
  gem 'bullet'
end

# Processamento de imagens
gem 'image_processing', '~> 1.2'
# Configuração de CORS para Rack
gem 'rack-cors', '~> 2.0'
# Banco de dados chave-valor em memória
gem 'redis', '>= 4.0.1'
# Ferramenta de análise estática de código Ruby
gem 'rubocop', require: false
# Extensão do RuboCop para Rails
gem 'rubocop-rails', require: false
# Framework CSS Tailwind CSS para Rails
gem 'tailwindcss-rails'
```

Parando o servidor, rode então:

```bash
bundle install
```

Configurando o banco de dados PostgreSQL. Precisamospegar o arquivo .env.example e duplicar para .env.development, .env.test e .env

No arquivo .env.example as constantes ficam em branco

```env
PRODUCTION_DATABASE_URL=
JWT_KEY=
```

Mas nos demais preencha corretamente com as informações necessárias

Vamos deixar que o visual de nosso projeto passe a seguir o framework TailwindCSS, então rode:

```bash
rails tailwindcss:install
gem install foreman
```

A partir deste momento não iniciaremos o projeto com o comando `rails s` mas sim com `bin/dev`.

Entao agora vamos configurar os testes, pare o servidor rails e rode os comandos:

```bash
bundle install
rails generate rspec:install
bundle exec guard init rspec
```

Abra o arquivo spec/rails_helper.rb e procure pela linha comentada abaixo pois a ideia eh deixar o diretorio `spec/support` para receber arquivos de ajuda nos testes:

```ruby
# Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }
```

Remova o comentario deixando:

```ruby
Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }
```

Verifique se o diretorio `spec/support` existe, mas caso nao exista crie. Dentro deste diretorio crie um arquivo chamado helpers.rb e coloque o conteudo abaixo que ira permitir que as factories criadas no diretorio `spec/factories` sejam executadas nos testes e o resultado da cobertura de testes feita por `simple_cov` filtrando pastas e arquivos desnecessarios

```ruby
require 'factory_bot_rails'
require 'simplecov'
require 'shoulda/matchers'
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
SimpleCov.start 'rails' do
  add_filter 'vendor'
  add_filter 'storage'
  add_filter 'app/channels'
  add_filter 'app/helpers'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
end
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

### 4. Iniciando o ambiente de Desenvolvimento com Testes

Configuraremos o ambiente de desenvolvimento para rodar testes automatizados utilizando o Guard e o RSpec. Também será realizada a cobertura de testes para garantir a qualidade do código.

Como iremos rodar testes, a aplicacao precisa aceitar requisicoes em ambiente de `development` vindos de qualquer host. Isto ocorre devido a gem `rack-cors`. Entao no arquivo config/environments/development.rb insira antes do fechamento `end` o conteudo

```ruby
config.hosts.clear
```

Voce deve ter notado que estamos usando o Guard para desenvolvimento TDD, entao edite o arquivo `Guardfile` e procure pela linha:

```rb
rspec.spec.call("controllers/#{m[1]}_controller"),
```

E adicione abaixo

```rb
rspec.spec.call("requests/#{m[1]}"),
```

Com isso testes requests serao executados tambem. Agora execute:

```bash
bundle exec guard
```

E pressione `Enter`, os testes serao rodados e a pasta `coverage` sera criada na raiz do projeto. Inclusive ja adicione a mesma no arquivo .gitignore

Cada alteracao feita em qualquer parte do projeto ira rodar os testes.

A cobertura por testes tera aumentado se rodar o `rspec` novamente, basta abrir o arquivo coverage/index.html para ver o resultado.

Agora realmente eh hora de entender o que eh util em testes e como codificar com testes.

### 5. Criando Estrutura CRUD

CRUD significa Create Update Read Update e Delete, em outras palavras as operações necessárias que podem ocorrer sobre um objeto, tabela no banco e tudo mais. Criaremos os modelos e seus cruds necessários para a aplicação, como Project e Task, juntamente com suas respectivas factories para geração de dados fictícios.

```bash
rails g scaffold project title completed_at:datetime
rails g scaffold task title scheduled_at:datetime completed_at:datetime
```

Não usamos jbuilders então podemos remover os arquivos json da seguinte maneira

```bash
find app/views -type f -name "*.jbuilder" -exec rm {} \;
```

Alem disso coloque no arquivo db/seeds.rb o codigo abaixo:

```ruby
30.times do |i|
  Task.create!(title: Faker::Lorem.question, scheduled_at: (Time.now+ 1.days))
  Project.create!(title: Faker::Job.title)
end
```

Entao criaremos as tabelas no banco e colocaremos dados fictiícios:

```bash
rails db:drop db:create db:migrate db:seed
```

Com Guard rodando, aperte `Enter` e já será possível ver a cobertura de testes no arquivo coverage/index.html

### 6. Desenvolvimento  API

Configuraremos as rotas da API para manipulação dos recursos de tasks e projects, permitindo obter a lista de dados e marcar como completo.

Criando os controllers da seguinte maneira:

```bash
rails g controller api/tasks
rails g controller api/projects
```

Entao abra o arquivo config/routes.rb e adicione

```ruby
namespace :api do
  resources :tasks, only: [:index, :update]
  resources :projects, only: [:index, :update]
end
```

Note que serao criados arquivos tambem de testes de controllers por requests (requisicoes). Portanto na pasta `spec/requests` é que iremos concentrar os testes de requisição tanto da aplicação rails quanto da `API`.

### 7. Desenvolvimento dos Testes

Vamos inciar o Guard para que tudo a partir de agora seja testado e garantirmos o desenvolvimento orientado a `TDD`

```bash
bundle exec guard
```

E abra um novo terminal

### Revisando os Testes gerados pelo scaffold

O scaffold de cada Model já gera testes de várias maneiras, mas vamos utilizar apenas algumas que já garantem o controle de qualidade, portanto algumas pastas podem ser removidas.

```bash
rm -rf spec/routing
rm -rf spec/views
rm -rf spec/helpers
```

**Entendendo factories**:

As factories são funções que geram instâncias de objetos fictícios para uso em testes automatizados. Elas simplificam a criação de dados de teste

Para cada model que corresponde a uma tabela no banco é criada uma factory automaticamente. Utilizando fakers juntamente de factories é possível ter dados fictícios sem precisar se preocupar com termos.

Para projects editamos spec/factories/projects.rb para projects.

```ruby
FactoryBot.define do
  factory :project do
    title { Faker::Lorem.sentence }
  end
end
```

E para tasks spec/factories/tasks.rb

```ruby
FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
  end
end
```

**Testes de models**:

Para cada model que corresponde a uma tabela no banco teremos seus testes para garantir que eles operam corretamente.

Iniciando com projects

app/models/project.rb

```ruby
validates :title, presence: true
```

spec/models/project_spec.rb

```ruby
  describe "validations" do
    it { should validate_presence_of(:title) }
  end
```

Agora com tasks

app/models/task.rb

```ruby
validates :title, presence: true
```

spec/models/task_spec.rb

```ruby
  describe "validations" do
    it { should validate_presence_of(:title) }
  end
```

**Testes de requests**:

São gerados pelo scaffold, mas precisam ser ajustados para um resultado válido.

Para projects  spec/requests/projects_spec.rb

```ruby
  let(:valid_attributes) {
    attributes_for(:project)
  }

  let(:invalid_attributes) {
    {title: ''}
  }
  # E o restante do arquivo
```

e tasks spec/requests/tasks_spec.rb

```ruby
  let(:valid_attributes) {
    attributes_for(:task)
  }

  let(:invalid_attributes) {
    {title: ''}
  }
  # e o restante do arquivo
```

O testes de `API` requerem um pouco mais de atenção então vamos passo uma a um.

Iniciando com spec/requests/api/projects_spec.rb

```ruby
require 'rails_helper'

RSpec.describe 'Api::Projects', type: :request do
  describe 'Projects Operations' do

    describe 'GET /api/projects' do
      it 'returns a list of projects in ascending order of creation' do
        create_list(:project, 5)

        get api_projects_path
        projects = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(projects.length).to eq(5)
      end
    end

    describe 'PATCH /api/projects/:id' do
      it 'marks a project as completed' do
        project = create(:project)

        patch api_project_path(project.id)
        project.reload

        expect(response).to have_http_status(200)
        expect(project.completed_at).not_to be_nil
      end
    end
  end
end
```

E também para spec/requests/api/tasks_spec.rb

```ruby
require 'rails_helper'

RSpec.describe "Api::Tasks", type: :request do
  describe 'Tasks Operations' do
    describe 'GET /api/tasks' do
      it 'returns a list of tasks in ascending order of creation' do
        create_list(:task, 5)
        get api_tasks_path
        tasks = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(tasks.length).to eq(5)
      end
    end

    describe 'PATCH /api/tasks/:id' do
      it 'marks a task as completed' do
        task = create(:task)

        patch api_task_path(task.id)
        task.reload

        expect(response).to have_http_status(200)
        expect(task.completed_at).not_to be_nil
      end
    end
  end
end
```

Os testes estão prontos mas os arquivos do projeto não.

app/controllers/api/projects_controller.rb

```ruby
class Api::ProjectsController < ActionController::API
  def index
    projects = Project.order(created_at: :asc)
    render json: projects.all
  end

  def update
    project = Project.find(params[:id])
    project.update(completed_at: Time.now)
    head :ok
  end
end
```

e app/controllers/api/tasks_controller.rb

```ruby
class Api::TasksController < ActionController::API
  def index
    tasks = Task.order(scheduled_at: :asc)
    render json: tasks.all
  end

  def update
    task = Task.find(params[:id])
    task.update(completed_at: Time.now)
    head :ok
  end
end
```

Pronto, novamente com Guard executando aperte `Enter` a aplicacão e tudo será visto como coberto e a aplicação pronta para receber acessos.

Basta iniciar com `bin/dev`

### 8. Broadcasting - Ações em tempo real

Em Rails ações em tempo real sempre foi um tema a ser discutido. Qual seria a melhor proposta e de repente core do Rails veio com a idéia e solução chamada `broadcasting`.

Em resumo, broadcasting em Rails é uma maneira de fornecer comunicação em tempo real entre o servidor e os clientes, utilizando tecnologias como WebSockets para enviar e receber mensagens instantaneamente.

Começando com os models acrescentando:

app/models/project.rb

```ruby
  broadcasts_refreshes # parte da magica acontece aqui
  after_create :broadcast_create
  private

  def broadcast_create
    broadcast_append_to self, target: "projects", partial: "projects/project", locals: { project: self } # outra parte aqui
  end
```

As ações de criar, atualizar e excluir são ouvidas ao adicionar `broadcasts_refreshes`. A única diferença que temos é que ao criar precisamos inserir realmente em um determinado ponto de html no sistema.

Então `broadcast_append_to self, target: "projects", partial: "projects/project", locals: { project: self }` está informando para fazer `append` ou seja inserir ao início de um `target`, ou seja o identificador de broadcasting no sistema. Logo em seguida qual conteúdo será adicionado, justamente uma partial com o próprio objeto.

Então duas mudanças ocorrerão na view:

app/views/projects/index.html.erb

```html
  <div id="projects" class="min-w-full">
    <%= turbo_stream_from :projects %>
    <%= render @projects %>
  </div>
```

O código `<%= turbo_stream_from :projects %>` servirá principalmente para acrescentar ao criar o objeto na lista.

No início do arquivo app/views/projects/_project.html.erb

```html
<%= turbo_stream_from project %>
```

Isto garante que código no model `broadcasts_refreshes` em qualquer alteração que ocorra reflita sobre este objeto, ou seja, atualizando ou excluindo. O mesmo será feito sobre task.

E para que o que for criado seja refletido no início da lista no controller app/controllers/projects_controller.rb vamos alterar o método `index`

```ruby
@projects = Project.order(updated_at: :desc)
```

Para o model app/models/task.rb

```ruby
  broadcasts_refreshes # parte da magica acontece aqui
  after_create :broadcast_create
  private

  def broadcast_create
    broadcast_append_to self, target: "tasks", partial: "tasks/task", locals: { task: self } # outra parte aqui
  end
```

Então duas mudanças ocorrerão na view:

app/views/tasks/index.html.erb

```html
  <div id="tasks" class="min-w-full">
    <%= turbo_stream_from :tasks %>
    <%= render @tasks %>
  </div>
```

No início do arquivo app/views/tasks/_task.html.erb

```html
<%= turbo_stream_from task %>
```

No controller app/controllers/projects_controller.rb vamos alterar o método `index`

```ruby
@tasks = Task.order(updated_at: :desc)
```

### 9. Colocando a navegação entre telas

Como um extra, o código para navegar entre as telas será acrescentado.
Primeiro acrescentamos a biblioteca de ícones font-awesome no cabeçalho do layout e depois a navegação.
No arquivo app/views/layouts/application.html.erb dentro entre a tag `<head></head>` adicione:

```html
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" integrity="sha384-DyZ88mC6Up2uqS4h/KRgHuoeGwBcD4Ng9SiP4dIRy0EXTlnuz47vAwmeGwVChigm" crossorigin="anonymous"/>
```

E para navegação acrescentar acima de de `<main></main>`

```html
<nav class="bg-gray-800 p-4 text-white fixed w-full top-0">
  <div class="container mx-auto flex justify-between items-center">
    <%= link_to root_path, class: "text-lg font-bold" do %>
      <i class="fas fa-check-double m-2"></i>
    <% end %>
    <div class="flex space-x-4">
      <%= link_to tasks_path, class: "flex items-center space-x-2" do %>
        <i class="fas fa-tasks mr-2"></i>
        Tasks
      <% end %>
      <%= link_to projects_path, class: "flex items-center space-x-2" do %>
        <i class="fas fa-briefcase mr-2"></i>
        Projects
      <% end %>
    </div>
  </div>
</nav>
```

### 10. Expondo o Projeto com NGrok

Utilizaremos o NGrok para expor o projeto localmente, permitindo acesso externo aos endpoints da aplicação.

Primeiramente entre em `https://ngrok.com/` se possivel faca o cadastro, baixe e faca a instalacao do `ngrok` na sua maquina. Apos feito isso se o projeto `Rails` estiver rodando, digite o comando em outra aba do terminal:

```bash
ngrok http 3000
```

### 11. Segurança

Aumentaremos a segurança da aplicação permitindo acesso externo somente a determinadas origens e ocultando parâmetros sensíveis.

Inicialmente iremos dar permissão a acesso externo. No arquivo config/initializers/cors.rb para:

```ruby
# Configuração global para lidar com CORS (Cross-Origin Resource Sharing)
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # Permite solicitações de qualquer origem
  allow do
    # Origens permitidas
    origins '*'
    # Recurso permitido
    resource '*',
             # Permite todos os cabeçalhos
             headers: :any,
             # Métodos HTTP permitidos
             methods: %i[get post put patch delete options head],
             # Expor os seguintes cabeçalhos nas respostas
             expose: %w[access-token expiry token-type uid client],
             # Define a idade máxima para as respostas em cache (0 para desativar o cache)
             max_age: 0
  end
end
```

E config/initializers/filter_parameter_logging.rb

```ruby
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
]
```

Reinicie o servidor e o guard, rode novamente.

## Extras

Aqui vão alguns comandos úteis que estão disponíveis por conta de gems:

**Irá gerar um arquivo com as possíveis falhas de segurança em seu projeto**:

```bash
brakeman -o coverage/output.html
```

**Gera comentários úteis em seus arquivos**:

```bash
annotate
```

**Eu gosto muito do editor visual studio, então algumas das extensões que utilizo**:



## Pré-requisitos

- Conhecimento básico de Ruby e programação web.
- Instalação do RVM.
- Ter o Ruby, o Rails e o NGrok instalados na máquina a partir do RVM.
- Docker para initiciliar os serviços que encontram na pasta docker-compose

Ao final deste curso, você estará apto a desenvolver uma aplicação web, API, utilizando Ruby on Rails, implementar testes automatizados para garantir a qualidade do código e expor o projeto para acesso externo utilizando o NGrok.
