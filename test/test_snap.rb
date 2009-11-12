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

 def test_title
   get '/'
   assert last_response.body.match(/.<title>Snap! \/.*<\/title>/)
 end
end

