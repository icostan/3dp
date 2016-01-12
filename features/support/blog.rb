puts ''
puts '==> Initialize rails app...'

puts ''
puts '==> Clean up...'
system 'rm -rf blog'

puts ''
puts '==> Generate Blog app...'
system 'bundle exec rails new blog -m rails-template.rb --skip-active-record --skip-test-unit --skip-spring --skip-turbolinks'
system 'cd blog && bundle exec rails generate scaffold guest name email'
