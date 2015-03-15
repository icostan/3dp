When(/^I create Post record$/) do
  # TODO: find a way to cleanup db
  execute "bundle exec rails runner 'Post.delete_all'"
  execute "bundle exec rails runner 'Post.create!.id'"
end

def execute(cmd)
  system "cd blog && #{cmd}"
end
