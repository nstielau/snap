require 'rubygems'
require 'sinatra'

module Snap
  get '/' do
    "<h2>ooooh Snap!</h2> <ul>#{get_files.map{|f| "<li>#{f}</li>"}.join()}</ul> are the files in #{get_dir}"
  end
  
  def get_dir
    File.dirname(__FILE__)
  end
  
  def get_files
    Dir.glob("#{get_dir}/**")
  end
  
end

