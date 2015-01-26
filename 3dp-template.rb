#
# 3 Days Project Template
#
# rails new NAME -m 3dp-template.rb --skip-active-record --skip-test-unit --skip-spring
# bundle exec rake rails:template LOCATION=~/Work/3dp/3dp-template.rba
#

#
# Setup
#
initializer 'generators.rb', <<-RUBY
Rails.application.config.generators do |g|
end
RUBY

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
inject_into_file 'config/initializers/generators.rb', after: placeholder do
  "    g.test_framework = :rspec\n"
end

after_bundle do
  generate 'rspec:install'
end

#
# Jasmine
#
gem 'jasmine-rails'
run 'brew install phantomjs'
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
gem 'factory_girl'

#
# Faker
#
gem 'faker'

#
# VCR
#
gem 'vcr'
gem 'webmock'
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
  inject_into_file '.rspec', after: '--require spec_helper\n' do
    '--require vcr_helper'
  end
end

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
