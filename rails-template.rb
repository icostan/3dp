##
#
# 3DP Rails Template
#
##

#
# Meta
#

#
# Setup
#
create_file '.ruby-version' do
  'ruby-2.2.2'
end
initializer 'generators.rb', <<-RUBY
Rails.application.config.generators do |g|
end
RUBY
# add_source 'https://rails-assets.org'

#
# Twitter-Bootstrap
#
gem 'less-rails'
gem 'less-rails-bootstrap'
gem 'therubyracer'
insert_into_file 'app/assets/stylesheets/application.css',
                 before: " *= require_tree .\n" do
  " *= require twitter/bootstrap\n"
end
insert_into_file 'app/assets/javascripts/application.js',
                 after: "//= require jquery_ujs\n" do
  "//= require twitter/bootstrap\n"
end
copy_file 'public/favicon.ico', 'public/apple-touch-icon.ico'
copy_file 'public/favicon.ico', 'public/apple-touch-icon-precomposed.ico'

#
# Haml
#
gem 'haml-rails'
after_bundle do
  remove_file 'app/views/layouts/application.html.erb'
end

#
# Bootstrap generators
#
gem 'bootstrap-generators'
after_bundle do
  generate 'bootstrap:install --template-engine=haml --skip-turbolinks'
end

#
# Simple form
#
gem 'simple_form'
gem 'country_select'
after_bundle do
  generate 'simple_form:install --bootstrap --force'
end

#
# Bootstrap addons
#
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'

#
# Rails assets
#
# gem 'rails-assets-bootstrap-admin-template'

#
# Bower
#
gem 'bower-rails'
after_bundle do
  generate 'bower_rails:initialize'
end

#
# Mongoid
#
say '==> Mongoid'

gem 'bson_ext'
gem 'mongoid'

after_bundle do
  generate 'mongoid:config'
end

#
# RSpec
#
say '==> RSpec'

gem 'rspec-rails', group: [:development, :test]

placeholder = "Rails.application.config.generators do |g|\n"
insert_into_file 'config/initializers/generators.rb', after: placeholder do
  "    g.test_framework = :rspec\n"
end

after_bundle do
  generate 'rspec:install'
end

#
# Jasmine
#
gem 'jasmine-rails', group: [:development, :test]
run 'brew info phantomjs 2>&1 1>/dev/null || brew install phantomjs'
after_bundle do
  generate 'jasmine_rails:install'
end

#
# Cucumber
#
say '==> Cucumber'

gem 'cucumber-rails', require: false, group: [:development, :test]
gem 'capybara', group: [:development, :test]
gem 'database_cleaner', group: [:development, :test]
gem 'mongoid-tree', group: [:development, :test]

after_bundle do
  generate 'cucumber:install --capybara --rspec'
  gsub_file 'features/support/env.rb', '.strategy = :transaction', '.strategy = :truncation'
end

#
# Guard
#
say '==> Guard'
gem 'guard', group: [:development, :test]
gem 'guard-rspec', group: [:development, :test]
gem 'guard-jasmine', group: [:development, :test]

after_bundle do
  run 'guard init'
end

#
# FactoryGirl
say '==> FactoryGirl'
gem 'factory_girl', group: [:development, :test]

#
# Faker
#
gem 'faker', group: [:development, :test]

#
# VCR
#
gem 'vcr', group: [:development, :test]
gem 'webmock', group: [:development, :test]
after_bundle do
  create_file 'spec/vcr_helper.rb', <<-RUBY
require 'vcr'
require 'webmock'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
RUBY
  insert_into_file '.rspec', after: '--require spec_helper\n' do
    '--require vcr_helper'
  end
end

#
# Analytics
#
# gem 'rack-google-analytics'
# after_bundle do
#   create_file 'config/initializers/google-analytics.rb', <<-RUBY
# require 'rack/google-analytics'
# Rails.configuration.middleware.use Rack::GoogleAnalytics, tracker: '#{ENV['3DP_GA']}'
#   RUBY
# end
gem 'intercom-rails'
after_bundle do
  generate "intercom:config #{ENV['3DP_INTERCOM']}" # hwclugky
end

#
# Pow
#
gem 'powder', group: [:development]
after_bundle do
  create_file '.powder', <<-TXT
syntivo
  TXT
  run 'bundle exec powder link'
  create_file '.powrc', <<-TXT
if [ -f "$rvm_path/scripts/rvm" ]; then
  source "$rvm_path/scripts/rvm"

  if [ -f ".ruby-version" ]; then
    rvm use `cat .ruby-version`
  fi
fi
  TXT
end

#
# Guests
#
after_bundle do
  generate :scaffold, 'guest name email'
end

#
# Bundle
#
say '==> Running Bundler install. This will take a while.'
run 'bundle install'

#
# Git
#
# after_bundle do
#   git :init
#   git add: '.'
#   git commit: "-a -m 'Initial commit'"
# end
