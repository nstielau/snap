#require 'helper'
require 'snap'
require 'rack/test'
require 'test/unit'
require 'mocha'

class SnapAppTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
   Snap::Server
  end

  def test_title
   get '/'
   assert last_response.body.match(/.<title>Snap! \/.*<\/title>/)
  end
  
  def test_title_with_path
    get '/'
    string = "<title>Snap! #{Dir.pwd}/<\/title>"    
    assert last_response.body.match(string), "Body doesn't contain #{string}:\n#{last_response.body}"
  end
  
  def test_404
    get '/couldnt/possibly/exist'
    assert_equal(last_response.status, 404)
    assert(last_response.body.match("404"))
  end
  
  def test_file
    get "/Rakefile"
    assert_equal(last_response.status, 200, "Reponse should be 200")
    assert(!last_response.body.match("<html"), "Should not match '<html', should be raw text.")
  end
  
  def test_file_code_view
    get "/Rakefile?format=code"
    assert_equal(last_response.status, 200)
    assert(last_response.body.match("<pre>"))
  end
  
  def test_snap_asset
    get '/__snap__/styles.css'
    assert_equal(last_response.status, 200)
    string = "body"
    assert last_response.body.match(string), "Body doesn't contain #{string}:\n#{last_response.body}"
  end
end
