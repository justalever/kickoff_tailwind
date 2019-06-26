=begin
Template Name: Kickstart application template - Tailwind CSS - Rails 5.2.3
Author: Andy Leverenz
Author URI: https://web-crunch.com
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite> -m template.rb
=end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'devise', '~> 4.4', '>= 4.4.3'
  gem 'friendly_id', '~> 5.2', '>= 5.2.4'
  gem 'foreman', '~> 0.84.0'
  gem 'sidekiq', '~> 5.1', '>= 5.1.3'
  gem 'tailwindcss', '~> 0.2.0'
  gem 'webpacker', '~> 4.0', '>= 4.0.7'
  gem_group :development, :test do
    gem 'better_errors'
  end
end

def set_application_name
  # Ask user for application name
  application_name = ask("What is the name of your application? Default: Kickoff")

  # Checks if application name is empty and add default Kickoff.
  application_name = application_name.present? ? application_name : "Kickoff"

  # Add Application Name to Config
  environment "config.application_name = '#{application_name}'"

  # Announce the user where he can change the application name in the future.
  puts "Your application name is #{application_name}. You can change this later on: ./config/application.rb"
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, "User", "username", "name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end
end

def add_webpack
  rails_command "webpacker:install"
end

def copy_templates
  directory "app", force: true
end

def add_tailwind
  run "yarn add tailwindcss"
  run "mkdir app/javascript/stylesheets"
  append_to_file("app/javascript/packs/application.js", 'import "stylesheets/application"')
  inject_into_file("./postcss.config.js",
  "var tailwindcss = require('tailwindcss');\n",  before: "module.exports")
  inject_into_file("./postcss.config.js", "\n    tailwindcss('./app/javascript/stylesheets/tailwind.config.js'),", after: "plugins: [")
  run "mkdir app/javascript/stylesheets/components"
end

# Remove Application CSS
def remove_app_css
  remove_file "app/assets/stylesheets/application.css"
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"

  insert_into_file "config/routes.rb",
    "require 'sidekiq/web'\n\n",
    before: "Rails.application.routes.draw do"

  content = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY
  insert_into_file "config/routes.rb", "#{content}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_foreman
  copy_file "Procfile"
end

def add_friendly_id
  generate "friendly_id"

  insert_into_file(
    Dir["db/migrate/**/*friendly_id_slugs.rb"].first,
    "[5.2]",
    after: "ActiveRecord::Migration"
  )
end

def stop_spring
  run "spring stop"
end

# Main setup
source_paths

add_gems

after_bundle do
  set_application_name
  stop_spring
  add_users
  add_webpack
  remove_app_css
  add_sidekiq
  add_foreman
  copy_templates
  add_tailwind
  add_friendly_id

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit" }

  say
  say "#{app_name} successfully created! 👍", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ rails server", :green
end
