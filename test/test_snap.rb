#require 'helper'
require 'snap'
require 'rubygems'
require 'rack/test'
require 'test/unit'

class SnapAppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
   Snap::Server
  end

  def test_title
   get '/'
   assert last_response.body.match(/.<title>Snap! \/.*<\/title>/)
  end
end
