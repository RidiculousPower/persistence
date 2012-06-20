
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat::File::ObjectInstance do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )  
  end
  
  after :all do
    ::Persistence.disable_port( :mock )  
  end

  ##############
  #  persist!  #
  ##############
  
  it 'can persist a flat object and test whether it has been persisted' do
    class File
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::File::ClassInstance
      include ::Persistence::Object::Flat::File::ObjectInstance
    end
    class ::Persistence::Object::Flat::File::Contents
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
    end
    class ::Persistence::Object::Flat::File::Path
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
    end
    
    File.instance_persistence_port = :mock_port
    instance = File.open( __FILE__, 'r' )

    # by content
    instance.persistence_port.persist_file_by_content
    instance.persist!
    instance.persistence_id.should_not == nil
    instance.persistence_port.persist_file_by_content
    instance.persistence_port.get_flat_object( instance.persistence_id ).should == instance.readlines.join

    # by path
    instance.persistence_port.persist_file_by_path
    instance.persistence_id = nil
    instance.persist!
    instance.persistence_id.should_not == nil
    instance.persistence_port.get_flat_object( instance.persistence_id ).should == instance.path
  end
    
end
