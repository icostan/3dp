##
#
# 3DP Rails Template
#
##

#
# Meta
#
def source_paths
  super + [File.join(File.expand_path(File.dirname(__FILE__)), 'rails-templates')]
end

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
# Landing page
#
directory 'public/css', 'public/css'
directory 'public/js', 'public/js'
copy_file 'public/index.html', 'public/index.html'

#
# Haml
#
gem 'haml-rails'
after_bundle do
  remove_file 'app/views/layouts/application.html.erb'
end

#
# Simple form
#
say '==> Simpleform'
gem 'simple_form'
gem 'country_select'
after_bundle do
  generate 'simple_form:install --bootstrap --force'
end

#
# Bootstrap generators
#
gem 'bootstrap-generators'
after_bundle do
  generate 'bootstrap:install --template-engine=haml --skip-turbolinks'
end

#
# Bootstrap addons
#
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'

# Rails assets
#
# gem 'rails-assets-bootstrap-admin-template'

#
# Bower
#
say '==> Bower-rails'
gem 'bower-rails'
after_bundle do
  generate 'bower_rails:initialize'
end

#
# Mongoid
#
say '==> Mongoid'
gem 'mongoid', '~> 5.0'
after_bundle do
  generate 'mongoid:config'
end

#
# Devise
#
say '==> Devise'
gem 'devise'
after_bundle do
  generate 'devise:install'
  generate 'devise User'
end

#
# Redis/Resque
#
say '==> Redis/Resque'
gem 'redis'
gem 'resque'
gem 'resque-web', require: 'resque_web'
gem 'resque-scheduler'
# after_bundle do
#   create_file 'config/initializers/redis.rb', <<-RUBY
# REDIS = Redis.new url: ENV['REDIS_URL']
#   RUBY
#   create_file 'config/initializers/resque.rb', <<-RUBY
# require 'resque'
# Resque.redis = ENV['REDIS_URL']
#   RUBY
#   create_file 'lib/tasks/resque.rake', <<-RUBY
# require 'resque/tasks'
# task 'resque:setup' => :environment
# RUBY
# end

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
gem 'capybara-screenshot', group: [:development, :test]
gem 'database_cleaner', group: [:development, :test]
gem 'mongoid-tree', group: [:development, :test]
gem 'selenium-webdriver', group: [:development, :test]

after_bundle do
  generate 'cucumber:install --capybara --rspec'
  gsub_file 'features/support/env.rb', '.strategy = :transaction', '.strategy = :truncation'
  create_file 'features/support/webmock.rb', <<-RUBY
# require 'webmock/cucumber'
# WebMock.allow_net_connect!
  RUBY
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
gem 'factory_girl_rails', group: [:development, :test]

#
# Faker
#
gem 'faker', group: [:development, :test]

#
# VCR
#
gem 'vcr', group: [:test]
gem 'webmock', group: [:test]
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
gem 'rack-tracker'
after_bundle do
  create_file 'config/initializer/rack-tracker.rb', <<-RUBY
Rails.application.config.middleware.use Rack::Tracker do
  handler :google_analytics, { tracker: ENV['GA_TRACKER'] }
end
  RUBY
end
# gem 'intercom-rails'
# after_bundle do
#   generate "intercom:config #{ENV['3DP_INTERCOM']}"
# end

#
# Monitoring/Alerts
#
gem 'newrelic_rpm'
after_bundle do
  create_file 'config/newrelic.yml', <<-YML
common: &default_settings
  license_key: <%= ENV["NEW_RELIC_LICENSE_KEY"] %>
  app_name: <%= ENV["NEW_RELIC_APP_NAME"] %>
  monitor_mode: true
  developer_mode: false
  log_level: info
  browser_monitoring:
      auto_instrument: true
  audit_log:
    enabled: false
  capture_params: false
  transaction_tracer:
    enabled: true
    transaction_threshold: apdex_f
    record_sql: obfuscated
    stack_trace_threshold: 0.500
  error_collector:
    enabled: true
    ignore_errors: "ActionController::RoutingError,Sinatra::NotFound"

development:
  <<: *default_settings
  monitor_mode: false
  app_name: <%= ENV["NEW_RELIC_APP_NAME"] %> (Development)
  developer_mode: true

test:
  <<: *default_settings
  monitor_mode: false

production:
  <<: *default_settings
  monitor_mode: true

staging:
  <<: *default_settings
  monitor_mode: false
  app_name: <%= ENV["NEW_RELIC_APP_NAME"] %> (Staging)
  YML
end
gem 'rollbar'
after_bundle do
  generate 'rollbar'
end

#
# Pow
#
gem 'powder', group: [:development]
after_bundle do
  create_file '.powder', <<-TXT
syntivo
  TXT
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
# Scaffolding
#
# after_bundle do
#   generate :scaffold, 'guest name email'
# end

#
# Bundle
#
say '==> Running Bundler install. This will take a while.'
run 'bundle install'

#
# Git
#
after_bundle do
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
