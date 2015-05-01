When(/^I create Guest record$/) do
  # TODO: find a way to cleanup db
  execute "bundle exec rails runner 'Guest.delete_all'"
  execute "bundle exec rails runner 'Guest.create!.id'"
end

def execute(cmd)
  system "cd blog && #{cmd}"
end
