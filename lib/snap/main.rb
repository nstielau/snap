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
    Dir.pwd
  end
  
  def get_files
    Dir.glob("#{get_dir}/**")
  end
  
  def file_name(file_path)
    if file_path.match("/")
      file_path.split("/").last
    else
      file_path
    end
  end
  
  def file_mtime(f)
    File.mtime(f).strftime("%Y-%m-%d %I:%M")
  end
end
