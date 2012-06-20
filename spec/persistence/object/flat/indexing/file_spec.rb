
require_relative '../../../../../lib/persistence.rb'

describe File do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a file object to a persistence port and get it back" do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Object::Flat::Indexing::FileMock < File
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      include ::Persistence::Object::Flat::File::ObjectInstance
      extend ::Persistence::Object::Flat::File::ClassInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Flat::Indexing::ClassInstance
      include ::Persistence::Object::Flat::Indexing::ObjectInstance
      explicit_index :explicit_index
    end
    class ::Persistence::Object::Flat::File::Contents
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Flat::Indexing::ClassInstance
      include ::Persistence::Object::Flat::Indexing::ObjectInstance
    end
    class ::Persistence::Object::Flat::File::Path
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Flat::Indexing::ClassInstance
      include ::Persistence::Object::Flat::Indexing::ObjectInstance
    end
    file_object = ::Persistence::Object::Flat::Indexing::FileMock.open( __FILE__, 'r' )
    file_object.persistence_port.persist_file_by_path
    file_object.persistence_port.persist_file_paths_as_strings
    file_object.persist!( :explicit_index => __FILE__ )
    
    persisted_file = ::Persistence::Object::Flat::Indexing::FileMock.persist( :explicit_index => __FILE__ )
    persisted_file.should == file_object.path
    file_object.persistence_port.persist_file_paths_as_objects
    persisted_file = ::Persistence::Object::Flat::Indexing::FileMock.persist( :explicit_index => __FILE__ )
    persisted_file.path.should == file_object.path
    
    file_object.persistence_port.persist_file_by_content
    file_object.persist!( :explicit_index => __FILE__ )
    persisted_file = ::Persistence::Object::Flat::Indexing::FileMock.persist( :explicit_index => __FILE__ )
    persisted_file.should == file_object.readlines.join
    ::Persistence::Object::Flat::Indexing::FileMock.cease!( :explicit_index => __FILE__ )
    ::Persistence::Object::Flat::Indexing::FileMock.persist( :explicit_index => __FILE__ ).should == nil
  end
  
end