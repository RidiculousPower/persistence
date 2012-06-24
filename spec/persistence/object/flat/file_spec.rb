
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat::File do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a file object to a persistence port and get it back" do
    class ::Persistence::Object::Flat::File::FileMock < File
      include ::Persistence::Object::Flat::File
      explicit_index :explicit_index
    end
    class ::Persistence::Object::Flat::File::Contents
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    class ::Persistence::Object::Flat::File::Path
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    file_object = ::Persistence::Object::Flat::File::FileMock.open( __FILE__, 'r' )
    file_object.persistence_port.persist_files_by_path!
    file_object.persistence_port.persist_file_paths_as_strings!
    file_object.persist!
    
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( file_object.persistence_id )
    persisted_file.should == file_object.path
    file_object.persistence_port.persist_file_paths_as_objects!
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( file_object.persistence_id )
    persisted_file.path.should == file_object.path
    
    file_object.persistence_port.persists_files_by_content!
    file_object.persist!
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( file_object.persistence_id )
    persisted_file.should == file_object.readlines.join
    file_object.cease!
    ::Persistence::Object::Flat::File::FileMock.persist( file_object.persistence_id ).should == nil

    file_object.persistence_port.persist_files_by_path!
    file_object.persistence_port.persist_file_paths_as_strings!
    file_object.persist!( :explicit_index => __FILE__ )
    
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( :explicit_index => __FILE__ )
    persisted_file.should == file_object.path
    file_object.persistence_port.persist_file_paths_as_objects!
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( :explicit_index => __FILE__ )
    persisted_file.path.should == file_object.path
    
    file_object.persistence_port.persists_files_by_content!
    file_object.persist!( :explicit_index => __FILE__ )
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( :explicit_index => __FILE__ )
    persisted_file.should == file_object.readlines.join
    ::Persistence::Object::Flat::File::FileMock.cease!( :explicit_index => __FILE__ )
    ::Persistence::Object::Flat::File::FileMock.persist( :explicit_index => __FILE__ ).should == nil

  end
  
end