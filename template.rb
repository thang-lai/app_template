#Add the current directoy to the path Thor uses to look up files
#(check Thor notes)

#Thor uses source_paths to look up files that are sent to file-based Thor acitons
#https://github.com/erikhuda/thor/blob/master/lib%2Fthor%2Factions%2Ffile_manipulation.rb
#like copy_file and remove_file.

#We're redefining #source_path so we can add the template dir and copy files from it
#to the application

def source_paths
  Array(super)
  #[File.join(File.expand_path(File.dirname(__FILE__)),'app_template')]
  [File.expand_path(File.dirname(__FILE__))]
end


#Here we are removing the Gemfile and starting over
#You may want to tap and existing gemset or go this method to make it easier for
#others to check it out.
#Plus, you dont have to remove the comments in the Gemfile
remove_file "Gemfile"
run "touch Gemfile"
#be sure to add source at the top of the file
add_source 'https://rubygems.org'
gem 'rails', '4.2.4'
gem 'mysql2', '~>0.3.20'

#default Rails gems:
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
#gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap-sass'
gem 'sass-rails'
gem 'devise'
#gem 'simple_form'
gem 'htmlbeautifier'

gem 'sdoc', group: :doc
#gem and gem_group will work from Rails Template API
gem_group :development, :test do
  gem 'spring'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'byebug'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem_group :test do
  gem 'guard-rspec'
  gem 'rspec-rails'
end

after_bundle do
  remove_dir 'test'
end

remove_file 'README.rdoc'
create_file 'README.md' do <<-TEXT
  #Markdown Stuff!
  Created with the help of Rails application templates
  TEXT
end

#generate 'simple_form:install --bootstrap'
#generate 'rspec:install'
#run 'guard init'

generate 'devise:install'
generate 'devise User'
generate 'devise:views'

# set up the databases
#rake "db:create", :env => 'development'
rake "db:create"
rake 'db:migrate'

#Add bootstrap to App
copy_file 'stylesheets/customizations.css.scss','app/assets/stylesheets/customizations.css.scss'
insert_into_file('app/assets/javascripts/application.js', "//= require bootstrap-sprockets\n",
                 :before => /\/\/= require_tree ./)

#Creating a home page
generate(:controller, "pages home")
route "root 'pages#home'"

remove_file 'app/views/pages/home.html.erb'

create_file 'app/views/pages/home.html.erb' do <<-TEXT
  <div class="jumbotron center">
  <h1>Templates, Whoop Whoop!</h1>
  <p>Link to my blog and shit.</p>
  <h4><%= link_to 'Sign Up', new_user_registration_path %></h4>
  </div>
  TEXT
end

copy_file 'layouts/_messages.html.erb', 'app/views/layouts/_messages.html.erb'
copy_file 'layouts/_header.html.erb', 'app/views/layouts/_header.html.erb'

remove_file 'app/views/layouts/application.html.erb'
remove_file 'app/views/devise/registrations/edit.html.erb'
remove_file 'app/views/devise/registrations/new.html.erb'
remove_file 'app/views/devise/sessions/new.html.erb'

copy_file 'layouts/application.html.erb', 'app/views/layouts/application.html.erb'
copy_file 'devise/registrations/edit.html.erb', 'app/views/devise/registrations/edit.html.erb'
copy_file 'devise/registrations/new.html.erb', 'app/views/devise/registrations/new.html.erb'
copy_file 'devise/sessions/new.html.erb', 'app/views/devise/sessions/new.html.erb'

copy_file 'devise/helpers/devise_helper.rb', 'app/helpers/devise_helper.rb'


# Ignore rails doc files, Vim/Emacs swap files, .DS_Store, and more
remove_file '.gitignore'
create_file '.gitignore' do <<-TEXT
/.bundle
/db/*.sqlite3
/db/*.sq`lite3-journal
/log/*
/tmp
database.yml
doc/
*.swp
*~
.project
.idea
.secret
.DS_Store
  TEXT
end
# Git: Initialize
git :init
git add: '.'
git commit: "-a -m 'Initial commit' -q --no-status"
