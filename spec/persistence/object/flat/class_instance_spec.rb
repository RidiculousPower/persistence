
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat::ClassInstance do
  
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
    class ::Persistence::Object::Flat::ClassInstance::Mock
      include ::Persistence::Object::Flat
      self.instance_persistence_port = ::Persistence.port( :mock_port )
    end
    instance = ::Persistence::Object::Flat::ClassInstance::Mock.new
    instance.persistence_port.put_object!( instance )
    instance.persistence_id.nil?.should == false
    ::Persistence::Object::Flat::ClassInstance::Mock.persisted?( 0 ).should == true
    ::Persistence::Object::Flat::ClassInstance::Mock.persist( 0 ).should == instance
  end
    
end
