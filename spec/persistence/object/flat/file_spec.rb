
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
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::File::ObjectInstance
      extend ::Persistence::Object::Flat::File::ClassInstance
    end
    class ::Persistence::Object::Flat::File::Contents
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    class ::Persistence::Object::Flat::File::Path
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    file_object = ::Persistence::Object::Flat::File::FileMock.open( __FILE__, 'r' )
    file_object.persistence_port.persist_file_by_path
    file_object.persistence_port.persist_file_paths_as_strings
    file_object.persist!
    
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( file_object.persistence_id )
    persisted_file.should == file_object.path
    file_object.persistence_port.persist_file_paths_as_objects
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( file_object.persistence_id )
    persisted_file.path.should == file_object.path
    
    file_object.persistence_port.persist_file_by_content
    file_object.persist!
    persisted_file = ::Persistence::Object::Flat::File::FileMock.persist( file_object.persistence_id )
    persisted_file.should == file_object.readlines.join
    file_object.cease!
    ::Persistence::Object::Flat::File::FileMock.persist( file_object.persistence_id ).should == nil
  end
  
end