require 'rubygems'
require 'sinatra'
require 'erb'

module Snap
  set :views, File.dirname(__FILE__) + '/views'
  
  get '/' do
    erb :index
  end
  
  get '/__snap__/:image.:format' do
    filename = File.dirname(__FILE__) + "/images/#{params[:image]}.#{params[:format]}"
    content_type params[:format]
    send_file filename
  end
  
  def get_dir
    File.dirname(__FILE__)
  end
  
  def get_files
    Dir.glob("#{get_dir}/**")
  end  
end
