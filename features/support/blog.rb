puts ''
puts '==> Initialize rails app...'

puts ''
puts '==> Clean up...'
system 'rm -rf blog'

puts ''
puts '==> Generate Blog app...'
system 'bundle exec rails new blog -m rails-template.rb --skip-active-record --skip-test-unit --skip-spring --skip-turbolinks'

puts ''
puts '==> Generate Post scaffold...'
system 'cd blog && bundle exec rails g scaffold Post boolean:boolean email url phone password search uuid file hidden integer:integer float:float range:range date:date time:time country time_zone'
