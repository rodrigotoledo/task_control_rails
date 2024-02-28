# Course: Application Development with Ruby on Rails - Tasks Control

In this course, we will learn how to develop a web application using the Ruby on Rails framework, called Tasks Control. Throughout this course, we will cover everything from installing the necessary technologies to exposing the project for external access using NGrok.

## Technologies Used

- **Ruby on Rails**: MVC web framework for rapid development of web applications in Ruby.
- **Docker**: The need for Docker in the Rails project is to ensure consistent development and deployment environments across different systems.
- **NGrok**: Tool for creating tunnels that allows you to expose local projects for external access.

## Course Differences

- Installation and use of RVM for Ruby version control and environment management.
- Implementation of data manipulation through browser and API, reflecting changes in real time.
- Complete test coverage using RSpec to ensure code quality.
- Use of NGrok to expose the project for external access, facilitating development and integration with other applications.

## Course content

### 1. Installing RVM

RVM will be used to manage Ruby versions and development environments. It will be installed using the following procedure:

- Access [https://rvm.io/](https://rvm.io/) and follow the installation instructions.

### 2. Creating and Initializing the Rails Project

First you need to create the .env file based on the .env.example file, don't worry this file it's ignored  on.gitignore file.

With RVM installed, let's create and initialize the Rails project environment:

```bash
rvm use 3.2.1@tasks_control --create
gem install rails --no-doc
rails new tasks_control -d postgresql -T
```

With this, the latest version of the Rails framework will be installed in the project's environment (gemset).

The `tasks_control` project will be created. Inside the folder there will probably not be a file called .ruby-gemset, go into the folder and if it doesn't really exist, create it and write `tasks_control` inside it. With this, the project will know that it should install `gems` libraries only within this environment.

**Start Docker services**:

After installing the Docker, you need to start the services:

- redis
- postgresql
- mailcatcher

Enter the following command in each docker compose directory **docker-compose/...**:

```bash
docker compose up -d docker-compose/mailcatcher
docker compose up -d docker-compose/postgresql
docker compose up -d docker-compose/redis
```

Feel free to update with your data.

So to start the project, let's run it inside the folder:

```bash
bundle install
rails db:drop db:create db:migrate
rails s
```

### 3. Configuring Libraries for Development

We will configure the libraries necessary for application development, such as RSpec, Faker, FactoryBot, Guard and others. Below is the content that will be added to the Gemfile

```ruby
# Gemfile
# Remove gem 'juilder'

group :development, :test do
  # Debug tool
  gem 'byebug', '~> 11.1'
  # Load environment variables from a .env file
  gem 'dotenv-rails'
  # Facilitates the creation of object mocks in tests
  gem 'factory_bot_rails'
  # Generates false data for testing
  gem 'faker', '~> 3.2'
  # Automatically save and run tests
  gem 'guard-rspec', '~> 4.7'
  # RSpec testing framework
  gem 'rspec-rails'
  # Add support for testing with shoulda-matchers
  gem 'shoulda-matchers', require: false
  # Analyze code coverage of tests
  gem 'simplecov'
end

group :development do
  # Annotate models with database schema information
  gem 'annotate'
  # Security tool for Rails
  gem 'brakeman'
  # Helps detect N+1 queries in ActiveRecord
  gem 'bullet'
end

# Image processing
gem 'image_processing', '~> 1.2'
# CORS configuration for Rack
gem 'rack-cors', '~> 2.0'
# In-memory key-value database
gem 'redis', '>= 4.0.1'
# Ruby static code analysis tool
gem 'rubocop', require: false
# RuboCop extension for Rails
gem 'rubocop-rails', require: false
# Tailwind CSS Framework for Rails
gem 'tailwindcss-rails'
```

Stopping the server, then run:

```bash
bundle install
```

Let's let the look of our project follow the TailwindCSS framework, so run:

```bash
rails tailwindcss:install
gem install foreman
```

From this moment on, we will not start the project with the `rails s` command but rather with `bin/dev`.

So now let's configure the tests, stop the rails server and run the commands:

```bash
bundle install
rails generate rspec:install
bundle exec guard init rspec
```

Open the spec/rails_helper.rb file and look for the line commented below as the idea is to leave the `spec/support` directory to receive help files for testing:

```ruby
# Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }
```

Remove the comment leaving:

```ruby
Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }
```

Check if the `spec/support` directory exists, but if not, create it. Within this directory, create a file called helpers.rb and place the content below that will allow the factories created in the `spec/factories` directory to be executed in tests and the result of the test coverage made by `simple_cov`, filtering unnecessary folders and files

```ruby
require 'factory_bot_rails'
require 'simplecov'
require 'shoulda/matchers'
RSpec.configure from |config|
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
  |with| config.integrate
    with.test_framework :rspec
    with.library :rails
  end
end
```

### 4. Starting the Development environment with Tests

We will configure the development environment to run automated tests using Guard and RSpec. Test coverage will also be carried out to ensure code quality.

As we will be running tests, the application needs to accept requests in a development environment from any host. This is due to the `rack-cors` gem. Then in the file config/environments/development.rb insert the content before closing `end`

```ruby
config.hosts.clear
```

You may have noticed that we are using Guard for TDD development, so edit the `Guardfile` file and look for the line:

```rb
rspec.spec.call("controllers/#{m[1]}_controller"),
```

And add below

```rb
rspec.spec.call("requests/#{m[1]}"),
```

With this, test requests will also be executed. Now run:

```bash
bundle exec guard
```

And press `Enter`, the tests will be run and the `coverage` folder will be created in the root of the project. Even add it to the .gitignore file

Every change made to any part of the project will run the tests.

Test coverage will have increased if you run `rspec` again, just open the coverage/index.html file to see the result.

Now it's really time to understand what is useful in testing and how to code with tests.

### 5. Creating CRUD Structure

CRUD stands for Create Update Read Update and Delete, in other words the necessary operations that can occur on an object, table in the database and everything else. We will create the models and their cruds necessary for the application, such as Project and Task, along with their respective factories for generating fictitious data.

It's important to install the annotate feature, which will automatically generate documentation for models and their cruds:

```bash
rails g annotate:install
```

And now generate the scaffold files:

```bash
rails g scaffold project title completed_at:datetime
rails g scaffold task title scheduled_at:datetime completed_at:datetime
```

**Ordered by updated_at**:

The idea is that the user have the ability to see last updated information, change the controllers order in `index` method:

For the projects app/controllers/projects_controller.rb

```ruby
  def index
    @projects = Project.order(updated_at: :desc)
  end
```

And for the tasks app/controllers/tasks_controller.rb

```ruby
  def index
    @tasks = Task.order(updated_at: :desc)
  end
```

We don't use jbuilders so we can remove the json files as follows

```bash
find app/views -type f -name "*.jbuilder" -exec rm {} \;
```

Furthermore, place the code below in the db/seeds.rb file:

```ruby
30.times of |i|
  Task.create!(title: Faker::Lorem.question, scheduled_at: (Time.now+ 1.days))
  Project.create!(title: Faker::Job.title)
end
```

Then we will create the tables in the database and place fictitious data:

```bash
rails db:drop db:create db:migrate db:seed
```

With Guard running, press `Enter` and you will now be able to see the test coverage in the coverage/index.html file

### 6. API Development

We will configure the API routes for handling task and project resources, allowing us to obtain the list of data and mark it as complete.

Creating the controllers as follows:

```bash
rails g controller api/tasks
rails g controller api/projects
```

Then open the config/routes.rb file and add

```ruby
namespace :api do
  resources :tasks, only: [:index, :update]
  resources :projects, only: [:index, :update]
end
```

Note that controller test files will also be created by requests. Therefore, in the `spec/requests` folder we will concentrate the request tests for both the rails application and the `API`.

### 7. Test Development

Let's start Guard so that everything from now on is tested and we can guarantee `TDD`-oriented development

```bash
bundle exec guard
```

And open a new terminal

### Reviewing the Tests generated by the scaffold

The scaffold for each Model already generates tests in several ways, but we will only use a few that already guarantee quality control, so some folders can be removed.

```bash
rm -rf spec/routing
rm -rf spec/views
rm -rf spec/helpers
```

**Understanding factories**:

Factories are functions that generate instances of dummy objects for use in automated tests. They simplify the creation of test data

For each model that corresponds to a table in the database, a factory is automatically created. Using fakers together with factories it is possible to have fictitious data without having to worry about terms.

For projects we edit spec/factories/projects.rb for projects.

```ruby
FactoryBot.define
  factory :project do
    title { Faker::Lorem.sentence }
  end
end
```

And for tasks spec/factories/tasks.rb

```ruby
FactoryBot.define
  factory :task do
    title { Faker::Lorem.sentence }
  end
end
```

**Model tests**:

For each model that corresponds to a table in the database, we will have tests to ensure that they operate correctly.

Starting with projects

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

Now with tasks

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

**Request tests**:

They are generated by the scaffold, but need to be adjusted for a valid result.

For projects spec/requests/projects_spec.rb

```ruby
  let(:valid_attributes) {
    attributes_for(:project)
  }

  let(:invalid_attributes) {
    {title: ''}
  }
  # And the rest of the file
```

and tasks spec/requests/tasks_spec.rb

```ruby
  let(:valid_attributes) {
    attributes_for(:task)
  }

  let(:invalid_attributes) {
    {title: ''}
  }
  # and the rest of the file
```

`API` testing requires a little more attention so let's go step by one.

Starting with spec/requests/api/projects_spec.rb

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

And also for spec/requests/api/tasks_spec.rb

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

The tests are ready but the project files are not.

app/controllers/api/projects_controller.rb

```ruby
class Api::ProjectsController < ActionController::API
  def index
    projects = Project.order(updated_at: :desc)
    render json: projects.all
  end

  def update
    project = Project.find(params[:id])
    project.update(completed_at: Time.now)
    head: ok
  end
end
```

and app/controllers/api/tasks_controller.rb

```ruby
class Api::TasksController < ActionController::API
  def index
    tasks = Task.order(updated_at: :desc)
    render json: tasks.all
  end

  def update
    task = Task.find(params[:id])
    task.update(completed_at: Time.now)
    head: ok
  end
end
```

Once again, with Guard running, press `Enter` on the application and everything will be seen as covered and the application will be ready to receive access.

Just start with `bin/dev`

### 8. Broadcasting - Real-time actions

In Rails, real-time actions have always been a topic to be discussed. What would be the best proposal and suddenly Rails core came up with the idea and solution called `broadcasting`.

In short, broadcasting in Rails is a way of providing real-time communication between the server and clients, using technologies such as WebSockets to send and receive messages instantly.

Starting with the models adding:

app/models/project.rb

```ruby
  broadcasts_refreshes # part of the magic happens here
  after_create :broadcast_create
  private

  def broadcast_create
    broadcast_append_to self, target: "projects", partial: "projects/project", locals: { project: self } # other part here
  end
```

Create, update and delete actions are heard when adding `broadcasts_refreshes`. The only difference we have is that when creating we need to actually insert it into a certain html point in the system.

So `broadcast_append_to self, target: "projects", partial: "projects/project", locals: { project: self }` is telling you to do `append`, that is, insert at the beginning of a `target`, that is, the identifier of broadcasting in the system. Soon after, the content will be added, precisely a partial with the object itself.

Then two changes will occur in the view:

app/views/projects/index.html.erb

```html
  <div id="projects" class="min-w-full">
    <%= turbo_stream_from :projects %>
    <%= render @projects %>
  </div>
```

The code `<%= turbo_stream_from :projects %>` will mainly serve to add when creating the object in the list.

At the beginning of the app/views/projects/_project.html.erb file

```html
<%= turbo_stream_from project %>
```

This ensures that code in the `broadcasts_refreshes` model reflects any change that occurs on this object, that is, updating or deleting it. The same will be done about task.

And so that what is created is reflected at the beginning of the list in the controller app/controllers/projects_controller.rb, we will change the `index` method

```ruby
@projects = Project.order(updated_at: :desc)
```

For model app/models/task.rb

```ruby
  broadcasts_refreshes # part of the magic happens here
  after_create :broadcast_create
  private

  def broadcast_create
    broadcast_append_to self, target: "tasks", partial: "tasks/task", locals: { task: self } # other part here
  end
```

Then two changes will occur in the view:

app/views/tasks/index.html.erb

```html
  <div id="tasks" class="min-w-full">
    <%= turbo_stream_from :tasks %>
    <%= render @tasks %>
  </div>
```

At the beginning of the app/views/tasks/_task.html.erb file

```html
<%= turbo_stream_from task %>
```

In the controller app/controllers/projects_controller.rb we will change the `index` method

```ruby
@tasks = Task.order(updated_at: :desc)
```

### 9. Placing navigation between screens

As an extra, code to navigate between screens will be added.
First we add the font-awesome icon library to the layout header and then the navigation.
In the app/views/layouts/application.html.erb file inside the `<head></head>` tag add:

```html
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" integrity="sha384-DyZ88mC6Up2uqS4h/KRgHuoeGwBcD4Ng9SiP4dIRy0EXTlnuz47vAwmeGwVChigm" crossorigin="anonymous"/>
```

And for navigation add above `<main></main>`

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

### 10. Exposing the Project with NGrok

We will use NGrok to expose the project locally, allowing external access to the application's endpoints.

First, go to `https://ngrok.com/`, if possible, register, download and install `ngrok` on your machine. After doing this, if the `Rails` project is running, type the command in another terminal tab:

```bash
ngrok http 3000
```

### 11. Security

We will increase application security by allowing external access only to certain sources and hiding sensitive parameters.

Initially we will allow external access. In the config/initializers/cors.rb file to:

```ruby
# Global configuration to handle CORS (Cross-Origin Resource Sharing)
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # Allow requests from any origin
  allow do
    # Allowed origins
    origins '*'
    # Feature allowed
    resource '*',
             # Allow all headers
             headers: :any,
             # Allowed HTTP methods
             methods: %i[get post put patch delete options head],
             # Expose the following headers in responses
             expose: %w[access-token expiry token-type uid client],
             # Set the maximum age for cached responses (0 to disable caching)
             max_age: 0
  end
end
```

And config/initializers/filter_parameter_logging.rb

```ruby
Rails.application.config.filter_parameters += [
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
]
```

Restart the server and guard, run again.

## Extras

Here are some useful commands that are available through gems:

**It will generate a file with possible security flaws in your project**:

```bash
brakeman -o coverage/output.html
```

**Generates useful comments on your files**:

```bash
annotate
```

**settings for visual studio**:

You can add the file in root of your project with the name **settings.json** and add the following code (**But change the rvm configurations**):

```json
{
  "rufo": "/usr/share/rvm/gems/ruby-3.2.1/bin/rufo",
  "editor.formatOnSave": true,
  "rubocop.autocorrect": true,
  "rubocop.safeAutocorrect": false,
  "rubocop.layoutMode": true,
  "rubocop.commandPath": "/usr/share/rvm/gems/ruby-3.2.1/bin/rufo",
  "ruby.rubocop.onSave": true,
  "editor.formatOnSaveTimeout": 5000,
  "files.associations": {
    "*.erb": "erb"
  },
  "ruby.rubocop.executePath": "/usr/share/rvm/gems/ruby-3.2.1/bin/rufo"
}
```

**I really like the visual studio editor, so some of the extensions I use**:

## Prerequisites

- Basic knowledge of Ruby and web programming.
- Installation of RVM.
- Have Ruby, Rails and NGrok installed on the machine from RVM.
- Docker to start the services found in the docker-compose folder

At the end of this course, you will be able to develop a web application, API, using Ruby on Rails, implement automated tests to ensure code quality and expose the project for external access using NGrok.
