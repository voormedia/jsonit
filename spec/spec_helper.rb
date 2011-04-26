$:.unshift File.expand_path('../../lib', __FILE__)
$:.unshift File.dirname(__FILE__)

require "json"

RSpec.configure do |config|
  config.mock_with :mocha
end


