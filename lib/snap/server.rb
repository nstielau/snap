require 'rubygems'
require 'sinatra'
require 'erb'
require 'digest/md5'

module Snap
  class Server < Sinatra::Base
    set :views, File.dirname(__FILE__) + '/views'

    #require 'logger'
    #use Rack::CommonLogger, Logger.new(STDOUT)
    # Add Rack::Cache
    
    def self.run!(options={})
      @@root_dir = options[:root]
      super.run! if super.respond_to?("run!")
    end

    def get_root_dir
      @@root_dir ||= Dir.pwd
    end
    
    # TODO: Cattr?    
    def get_current_dir
      @dir
    end
  
    def set_current_dir(newdir)
      @dir = newdir
    end
  
    #############
    # Snap Assets    
    get '/__snap__*/:file.:format' do
      filename = File.dirname(__FILE__) + "/assets#{params[:splat]}/#{params[:file]}.#{params[:format]}"
      headers({"Cache-Control" => "max-age=3600, public"})
      content_type params[:format]
      send_file filename
    end  
  
    ######
    # 404    
    not_found do
      status 404
      erb :not_found
    end
  
    ####################
    # Main splat handler
    get '/*' do
      relative_location = params[:splat]
      full_location = File.join(get_root_dir, relative_location)
      if File.exist?(full_location)
        if File.directory?(full_location)
          set_current_dir(full_location)
          erb :index
        elsif File.file?(full_location)
          if params[:format] && params[:format].to_sym == :code
            @full_location = full_location
            erb :code
          else
            send_file full_location, :type => params[:format] || File.extname(full_location)
          end
        end
      else
        raise Sinatra::NotFound
      end
    end
  
  
    def get_snap_files
      files = Dir.glob("#{get_current_dir}/**").map{|f| SnapFile.new(f)}
      files.insert(0,SnapFile.new(File.join(get_current_dir, '..'))) unless at_root?      
      files
    end
    
    def at_root?
      File.expand_path(get_current_dir) == File.expand_path(get_root_dir)
    end
    
    # def breadcrumberize_path
    #   relative_path = get_current_dir.sub(get_root_dir, "")
    #   puts "Relative path is #{relative_path}"
    #   relative_parts = relative_path.split("/")
    #   relative_parts.pop
    #   puts "relative_parts are #{relative_parts.inspect}"
    #   b_root = get_current_dir
    #   relative_parts.each do |p|
    #     b_root = b_root.sub(p, "<a href=\"/#{p}\">#{p}</a>")
    #     puts "Bboot is now #{b_root}"
    #   end
    #   b_root
    # end
  end
end
