
if $__persistence__spec__development__
  require_relative '../../../../../lib/persistence-object.rb'
  require_relative '../../../../../../adapters/mock/lib/persistence-adapter-mock.rb'
  require_relative '../../../../../../port/lib/persistence-port.rb'
else
  require 'persistence-object'
  require 'persistence-adapter-mock'
  require 'persistence-port'
end

describe ::Persistence::Object::Persist::ClassInstance do
  
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
    instance = ::Persistence::Object::Persist::ClassInstance::Mock.new
    ::Persistence::Object::Persist::ClassInstance::Mock.count.should == 0
    instance.persistence_port.put_object!( instance )
    instance.persistence_id.should == 0
    ::Persistence::Object::Persist::ClassInstance::Mock.persisted?( 0 ).should == true
    ::Persistence::Object::Persist::ClassInstance::Mock.persist( 0 ).should == instance
    ::Persistence::Object::Persist::ClassInstance::Mock.count.should == 1
  end
    
end
