require 'aruba/cucumber'

Before do
  @dirs = ['blog']
  @aruba_timeout_seconds = 30
  @aruba_io_wait_seconds = 60
end
