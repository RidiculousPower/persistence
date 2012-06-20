
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Cease::ClassInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end
  
  ############
  #  cease!  #
  ############
  
  it 'can persist an object and test whether it has been persisted' do
    class ::Persistence::Object::Cease::ClassInstance::Mock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      include ::Persistence::Object::PersistenceID
      include ::Persistence::Object::Equality
      extend ::Persistence::Object::Cease::ClassInstance
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
    instance = ::Persistence::Object::Cease::ClassInstance::Mock.new
    instance.persistence_port.put_object!( instance )
    instance.persistence_id.should == 0
    ::Persistence::Object::Cease::ClassInstance::Mock.cease!( 0 )
    ( instance.persistence_port.get_bucket_name_for_object_id( 0 ) ? true : false ).should == false
  end
    
end
