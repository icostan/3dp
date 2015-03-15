Given(/^a blog app$/) do
  system 'rm -rf blog'
  system 'bundle exec rails new blog -m rails-template.rb --skip-active-record --skip-test-unit --skip-spring --skip-turbolinks'
end

When(/^I generate "(.*?)" scaffold$/) do |name|
  execute "bundle exec rails g scaffold #{name} boolean:boolean email url phone password search uuid text:text file hidden integer:integer float:float range:range date:date time:time country time_zone"
end

When(/^I create "(.*?)" record$/) do |name|
  execute "bundle exec rails runner '#{name}.delete_all'"
  sleep 1
  execute "bundle exec rails runner '#{name}.create!.id'"
end

def execute(cmd)
  system "cd blog && #{cmd}"
end
