require 'aruba/cucumber'

Aruba.configure do |config|
  config.startup_wait_time = 10
  config.io_wait_timeout = 60
  config.exit_timeout = 10
  config.log_level = :error
end
