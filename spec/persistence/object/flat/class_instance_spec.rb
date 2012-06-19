
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat::ClassInstance do
  
  #############
  #  persist  #
  #############
  
  it 'can persist a flat object and test whether it has been persisted' do
    class ::Persistence::Object::Flat::ClassInstance::Mock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      self.instance_persistence_port = ::Persistence::Port.new( :mock_port, ::Persistence::Adapter::Mock.new )
    end
    instance = ::Persistence::Object::Flat::ClassInstance::Mock.new
    instance.persistence_port.put_object!( instance )
    instance.persistence_id.should == 0
    ::Persistence::Object::Flat::ClassInstance::Mock.persisted?( 0 ).should == true
    ::Persistence::Object::Flat::ClassInstance::Mock.persist( 0 ).should == instance
  end
    
end