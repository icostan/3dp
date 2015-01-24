#
# 3 Days Project Template
#
# USAGE: rails new NAME -m 3dp-template.rb --skip-active-record --skip-test-unit
#

# >----------------------------[ Initial Setup ]------------------------------<

initializer 'generators.rb', <<-RUBY
Rails.application.config.generators do |g|
end
RUBY

# >--------------------------------[ Mongoid ]--------------------------------<

say '==> Mongoid'

gem 'bson_ext'
gem 'mongoid'

after_bundle do
  generate 'mongoid:config'
end

# >---------------------------------[ RSpec ]---------------------------------<

say '==> RSpec'

gem 'rspec-rails', group: [:development, :test]

placeholder = "Rails.application.config.generators do |g|\n"
inject_into_file 'config/initializers/generators.rb', after: placeholder do
  "    g.test_framework = :rspec\n"
end

after_bundle do
  generate 'rspec:install'
end

# >-------------------------------[ Cucumber ]--------------------------------<

say '==> Cucumber'

gem 'cucumber-rails', group: [:development, :test]
gem 'capybara', group: [:development, :test]
gem 'database_cleaner', group: [:development, :test]

after_bundle do
  generate 'cucumber:install --capybara --rspec -D'
end

# >-----------------------------[ Run Bundler ]-------------------------------<

say '==> Running Bundler install. This will take a while.'
run 'bundle install'
