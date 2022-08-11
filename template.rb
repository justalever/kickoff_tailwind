=begin
Template Name: Kickoff - Tailwind CSS
Author: Andy Leverenz
Author URI: https://web-crunch.com
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb
=end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'devise', '~> 4.8', '>= 4.8.1'
  gem 'friendly_id', '~> 5.4', '>= 5.4.2'
  gem 'cssbundling-rails'
  gem 'name_of_person'
  gem 'sidekiq', '~> 6.5', '>= 6.5.4'
  gem 'stripe'
end

def add_tailwind
  rails_command "css:install:tailwind"
  # remove tailwind config that gets installed and swap for custom config
  remove_file "tailwind.config.js"
end


def add_storage_and_rich_text
  rails_command "active_storage:install"
  rails_command "action_text:install"
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, "User", "first_name", "last_name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end

  # name_of_person gem
  append_to_file("app/models/user.rb", "\nhas_person_name\n", after: "class User < ApplicationRecord")
end

def copy_templates
  directory "app", force: true
  directory "lib", force: true
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

def add_friendly_id
  generate "friendly_id"
end

def add_tailwind_plugins
  run "yarn add -D @tailwindcss/typography @tailwindcss/forms @tailwindcss/aspect-ratio @tailwindcss/line-clamp"

  copy_file "tailwind.config.js"
end

# Main setup
source_paths

add_gems

after_bundle do
  add_tailwind
  add_tailwind_plugins
  add_storage_and_rich_text
  add_users
  add_sidekiq
  copy_templates
  add_friendly_id

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit" }

  say
  say "Kickoff app successfully created! 👍", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ ./bin/dev", :green
end
