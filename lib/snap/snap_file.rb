module Snap
  class SnapFile
    def initialize(file_name)
      @file_name = file_name.sub("//", "/")
    end
  
    def name
      if @file_name && @file_name.match("/")
        @file_name.split("/").last
      else
        @file_name
      end
    end
    
    def relative_to(dir)
      rel = @file_name.sub(dir, "")
    end

    def size
      File.size(@file_name)
    end

    def mtime
      mtime = File.mtime(@file_name)
      if (mtime.to_i > Time.now.to_i - 24*60*60)
        mtime.strftime("%I:%M:%S %p")
      else
        mtime.strftime("%Y-%m-%d")      
      end
    end
    
    def type
      type = `file #{@file_name}`.strip.sub(/\S+\s+/, "")
      type = "text" if type.match("text")
      type
    end
    
    def directory?
      type.match("directory")
    end
  end
end