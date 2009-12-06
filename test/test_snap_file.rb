require 'test/unit'
require 'snap/snap_file'
require 'mocha'

class SnapFileTest < Test::Unit::TestCase
  def test_file_name
    a = Snap::SnapFile.new('/path/to/some_file')
    assert_equal(a.name, "some_file")
  end
  
  def test_file_name_with_space
    a = Snap::SnapFile.new('/path/to/some file')
    assert_equal(a.name, "some file")
  end
  
  def test_file_path
    a = Snap::SnapFile.new('/path/to/some_file')
    assert_equal(a.path, "/path/to/some_file")
  end
  
  def test_file_path_with_space
    a = Snap::SnapFile.new('/path/to/some file')
    assert_equal(a.path, "/path/to/some file")
  end
  
  def test_file_path_with_extra_slash
    a = Snap::SnapFile.new('/path/to//some file')
    assert_equal(a.path, "/path/to/some file")
  end
  
  def test_file_type_with_extension
    {
      :rb => "ruby",
      :txt => "text",
      :jpg => "image"
    }.each_pair do |ext, value|    
      a = Snap::SnapFile.new("/file.#{ext}")    
      assert(a.type.match(value), "A file with extension '#{ext}' should have a type that matches #{value}.")
    end
  end
  
  def test_file_type_with_space
    Tempfile.open("snap test temp") do |f|
      a = Snap::SnapFile.new(f.path)    
      assert_equal(a.type, "empty")
    end
  end
  
  def test_file_size
    size = 100
    a = Snap::SnapFile.new(__FILE__)
    File.stubs(:size).with(a.path).returns(size)
    assert(a.size > 0)
    assert_equal(a.size, size)
    assert_equal(a.size.class, Fixnum)
  end

  def test_empty_file_size
    Tempfile.open("snap_test_temp") do |f|
      a = Snap::SnapFile.new(f.path)    
      assert_equal(a.size, 0, "Tempfile should be of size 0")
    end
  end
  
  def test_mtime_within_24_hours
    a = Snap::SnapFile.new("/path")
    0.upto(23).each do |h|
      File.stubs(:mtime).with(a.path).returns(Time.now - h*60*60)    
      assert(a.mtime.match(/\d\d:\d\d:\d\d??/), "Mtime is #{a.mtime}, which isn't a time.")
    end
  end
  
  def test_mtime_more_than_24_hours
    a = Snap::SnapFile.new("/path")
    File.stubs(:mtime).with(a.path).returns(Time.now - 60*60*25)    
    assert(a.mtime.match(/\d\d-\d\d-\d\d\d\d??/), "Mtime is #{a.mtime}, which isn't a date.")
  end
  
  def test_image_helper
    a = Snap::SnapFile.new("/path")
    %w(image/jpeg image/png).each do |t|
      a.stubs(:type).returns(t)    
      assert(a.image?, "File of type '#{t}' should be marked as an image.")
    end
    
    %w(text/plain directory).each do |t|
      a.stubs(:type).returns(t)    
      assert(!a.image?, "File should not be marked as an image.")
    end
  end
  
  def test_image_helper_by_extension
    %w(jpeg jpg png gif).each do |ext|
      a = Snap::SnapFile.new("/path.#{ext}")
      assert(a.image?, "File should be marked as an image.")
    end
    
    %w(.txt .html).each do |ext|
      a = Snap::SnapFile.new("/path.#{ext}")
      assert(!a.image?, "File should not be marked as an image.")
    end
  end
  
  def test_directory_helper
    a = Snap::SnapFile.new("/path")
    %w(directory).each do |t|
      a.stubs(:type).returns(t)    
      assert(a.directory?, "File should be marked as a directory.")
    end
    
    %w(text png jpeg).each do |t|
      a.stubs(:type).returns(t)    
      assert(!a.directory?, "File should not be marked as an directory.")
    end
  end
  
  def test_relative_path
    a = Snap::SnapFile.new(__FILE__)
    assert_equal(a.relative_to(File.dirname(__FILE__)), "/#{File.basename(__FILE__)}")
  end
  
  def test_path
    a = Snap::SnapFile.new(__FILE__)
    assert_equal(a.path, __FILE__)
  end

end