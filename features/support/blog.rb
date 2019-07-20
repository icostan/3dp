puts ''
puts '==> Initialize rails app...'

puts ''
puts '==> Cleaning up...'
system 'rm -rf blog'

puts ''
puts '==> Generate Blog app...'
system 'bundle exec rails new blog -m rails-template.rb --skip-test-unit --skip-spring --skip-turbolinks'

puts '==> Generate Guest model...'
system 'cd blog && bundle exec rails generate scaffold guest name email'

puts '==> Run migrations...'
system 'cd blog && bundle exec rake db:migrate'
