require 'test/unit'
require 'snap/snap_file'

class SnapFileTest < Test::Unit::TestCase
  def test_file_name
    a = Snap::SnapFile.new('/path/to/some_file')
    assert_equal(a.name, "some_file")
  end
  
  def test_file_name_with_space
    a = Snap::SnapFile.new('/path/to/some file')
    assert_equal(a.name, "some file")
  end
  
  def test_file_type
    a = Snap::SnapFile.new(__FILE__)    
    assert_equal(a.type, "text")
  end
  
  def test_file_type_with_space
    Tempfile.open("snap test temp") do |f|
      a = Snap::SnapFile.new(f.path)    
      assert_equal(a.type, "empty")
    end
  end
  
  def test_file_size
    a = Snap::SnapFile.new(__FILE__)    
    assert(a.size > 0)
    assert_equal(a.size.class, Fixnum)
  end

  def test_empty_file_size
    Tempfile.open("snap_test_temp") do |f|
      a = Snap::SnapFile.new(f.path)    
      assert_equal(a.size, 0, "Tempfile should be of size 0")
    end
  end
  
  def test_mtime
    Tempfile.open("snap_test_temp") do |f|
      a = Snap::SnapFile.new(f.path)    
      assert(a.mtime.match(/\d\d:\d\d:\d\d??/), "Mtime is #{a.mtime}")
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