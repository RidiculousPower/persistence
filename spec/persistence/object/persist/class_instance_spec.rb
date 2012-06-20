
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Persist::ClassInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end
  
  ################
  #  persisted?  #
  #  persist     #
  #  count       #
  ################
  
  it 'can persist an object and test whether it has been persisted' do
    class ::Persistence::Object::Persist::ClassInstance::Mock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      include ::Persistence::Object::PersistenceID
      include ::Persistence::Object::Equality
      include ::Persistence::Object::Persist::ObjectInstance
      extend ::Persistence::Object::Persist::ClassInstance
      self.instance_persistence_port = ::Persistence.port( :mock_port )
      def persistence_hash_to_port
        return {}
      end
      def self.non_atomic_attribute_readers
        return []
      end
      def non_atomic_attribute_readers
        return []
      end
      def atomic_attribute_readers
        return []
      end
    end
    instance = ::Persistence::Object::Persist::ClassInstance::Mock.new
    ::Persistence::Object::Persist::ClassInstance::Mock.count.should == 0
    instance.persistence_port.put_object!( instance )
    instance.persistence_id.should == 0
    ::Persistence::Object::Persist::ClassInstance::Mock.persisted?( 0 ).should == true
    ::Persistence::Object::Persist::ClassInstance::Mock.persist( 0 ).should == instance
    ::Persistence::Object::Persist::ClassInstance::Mock.count.should == 1
  end
    
end
