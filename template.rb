=begin
Template Name: Kickoff - Tailwind CSS
Author: Andy Leverenz
Author URI: https://web-crunch.com
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb
=end

require "fileutils"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_paths
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("kickoff_tailwind-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/dfang/kickoff_tailwind.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{kickoff_tailwind/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def remove_gem(*names)
  names.each do |name|
    gsub_file 'Gemfile', /gem '#{name}'.*\n/, ''
  end
end

def remove_gems
  remove_gem 'tzinfo-data'
end

def add_gems
  gem 'devise', '~> 4.7', '>= 4.7.3'
  gem 'devise_masquerade', '~> 1.2'
  gem 'friendly_id', '~> 5.4', '>= 5.4.1'
  gem 'sidekiq', '~> 6.1', '>= 6.1.2'
  gem 'name_of_person', '~> 1.1', '>= 1.1.1'
  gem 'noticed', '~> 1.2'
  gem 'omniauth-github', '~> 1.4'
  gem 'sitemap_generator', '~> 6.1', '>= 6.1.2'
  gem 'image_processing'
  gem 'high_voltage', '~> 3.1'
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
  remove_file "app/assets/stylesheets/application.css"

  copy_file "Procfile"
  copy_file "Procfile.dev"
  copy_file ".foreman"

  directory "app", force: true
end

def add_tailwind
  # Until PostCSS 8 ships with Webpacker/Rails we need to run this compatability version
  # See: https://tailwindcss.com/docs/installation#post-css-7-compatibility-build
  run "yarn add tailwindcss@npm:@tailwindcss/postcss7-compat postcss@^7 autoprefixer@^9"
  run "mkdir -p app/javascript/stylesheets"

  append_to_file("app/javascript/packs/application.js", 'import "stylesheets/application"')
  inject_into_file("./postcss.config.js", "\n    require('tailwindcss')('./app/javascript/stylesheets/tailwind.config.js'),", after: "plugins: [")

  run "mkdir -p app/javascript/stylesheets/components"
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

# Main setup
add_template_repository_to_source_paths

remove_gems
add_gems

after_bundle do
  add_users
  add_sidekiq
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
  say "Kickoff app successfully created! 👍", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ rails server", :green
end
