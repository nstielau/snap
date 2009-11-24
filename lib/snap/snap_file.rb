module Snap
  class SnapFile
    def initialize(file_name)
      @path = file_name.sub("//", "/")
    end
  
    def name
      if @path && @path.match("/")
        @path.split("/").last
      else
        @path
      end
    end
    
    def path
      @path
    end
    
    def relative_to(dir)
      rel = @path.sub(dir, "")
    end

    def size
      File.size(@path)
    end

    def mtime
      mtime = File.mtime(@path)
      if (mtime.to_i > Time.now.to_i - 24*60*60)
        mtime.strftime("%I:%M:%S %p")
      else
        mtime.strftime("%Y-%m-%d")      
      end
    end
    
    def type
      escaped_path = @path.gsub(" ", "\\ ")
      type = `file #{escaped_path}`.strip.sub(/.*:\s*/, "")
      type = "text" if type.match("text")
      type
    end
    
    def directory?
      type.match("directory")
    end
  end
end