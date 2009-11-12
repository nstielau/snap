require 'rubygems'
require 'sinatra'
require 'erb'

module Snap
  class Server < Sinatra::Base
    set :views, File.dirname(__FILE__) + '/views'
  
    #attr :dir, true
  
    def get_dir
      @dir
    end
  
    def set_dir(newdir)
      @dir = newdir
    end
  
    get '/' do
      set_dir(Dir.pwd)
      erb :index
    end
  
    get '/__snap__/:image.:format' do
      filename = File.dirname(__FILE__) + "/images/#{params[:image]}.#{params[:format]}"
      content_type params[:format]
      send_file filename
    end
  
    get '/*' do
      relative_location = params[:splat]
      full_location = File.join(Dir.pwd, get_dir.to_s, relative_location)
    
      if File.exist?(full_location)
        if File.directory?(full_location)
          set_dir(full_location)
          erb :index
        elsif File.file?(full_location)
          mime :foo, 'text'
          content_type :foo
          send_file full_location, :type => :foo
        end
      end
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
  
    def file_size(f)
      File.size(f)
    end
  
    def file_mtime(f)
      File.mtime(f).strftime("%Y-%m-%d %I:%M")
    end
  end
end
