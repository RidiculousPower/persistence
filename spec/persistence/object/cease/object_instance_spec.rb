
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Cease::ObjectInstance do
  
  ############
  #  cease!  #
  ############
  
  it 'can persist an object and test whether it has been persisted' do
    class ::Persistence::Object::Cease::ObjectInstance::Mock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      include ::Persistence::Object::PersistenceID
      include ::Persistence::Object::Equality
      include ::Persistence::Object::Cease::ObjectInstance
      self.instance_persistence_port = ::Persistence::Port.new( :mock_port, ::Persistence::Adapter::Mock.new )
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
    instance = ::Persistence::Object::Cease::ObjectInstance::Mock.new
    instance.persistence_port.put_object!( instance )
    instance.persistence_id.should == 0
    instance.cease!
    instance.persistence_id.should == nil
    ( instance.persistence_port.get_bucket_name_for_object_id( 0 ) ? true : false ).should == false
  end
    
end
