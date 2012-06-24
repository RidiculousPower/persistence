
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat::File::ClassInstance do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )  
  end
  
  after :all do
    ::Persistence.disable_port( :mock )  
  end
  
  #############
  #  persist  #
  #############
  
  it 'can persist a flat object and test whether it has been persisted' do
    class ::Persistence::Object::Flat::File::ClassInstance::FileMock < File
      include ::Persistence::Object::Flat::File
    end
    class ::Persistence::Object::Flat::File::Contents
      include ::Persistence::Object::Flat
    end
    class ::Persistence::Object::Flat::File::Path
      include ::Persistence::Object::Flat
    end
    
    ::Persistence::Object::Flat::File::ClassInstance::FileMock.instance_persistence_port = :mock
    instance = ::Persistence::Object::Flat::File::ClassInstance::FileMock.open( __FILE__, 'r' )
    
    # by content
    instance_to_persist = ::Persistence::Object::Flat::File::Contents.new( instance.readlines.join )
    instance_to_persist.persistence_bucket = ::Persistence::Object::Flat::File::ClassInstance::FileMock.instance_persistence_bucket
    instance_to_persist.persistence_port.put_object!( instance_to_persist )
    instance_to_persist.persistence_id.should_not == nil
    
    ::Persistence::Object::Flat::File::ClassInstance::FileMock.instance_persistence_port.persists_files_by_content!
    persisted_file = ::Persistence::Object::Flat::File::ClassInstance::FileMock.persist( instance_to_persist.persistence_id )
    persisted_file.should == instance_to_persist

    # by path
    instance_to_persist_two = ::Persistence::Object::Flat::File::Path.new( instance.path )
    instance_to_persist_two.persistence_bucket = ::Persistence::Object::Flat::File::ClassInstance::FileMock.instance_persistence_bucket
    instance_to_persist_two.persistence_port.put_object!( instance_to_persist_two )
    instance_to_persist_two.persistence_id.should_not == nil

    ::Persistence::Object::Flat::File::ClassInstance::FileMock.instance_persistence_port.persist_file_paths_as_objects!
    persisted_file_two = ::Persistence::Object::Flat::File::ClassInstance::FileMock.persist( instance_to_persist_two.persistence_id )
    persisted_file_two.is_a?( File ).should == true
    persisted_file_two.path.should == instance_to_persist_two
  end
    
end
