require 'helper'
require 'snap'
require 'rubygems'
require 'rack/test'

class TestApp
  include Snap
end

class MyAppTest < Test::Unit::TestCase
 include Rack::Test::Methods

 def app
   Snap::Server
 end

 def test_my_default
   get '/'
   assert_equal 'Hello World!', last_response.body
 end
end

