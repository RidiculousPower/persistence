
if $__persistence__spec__development__
  require_relative '../../../../../lib/persistence-object.rb'
  require_relative '../../../../../../adapters/mock/lib/persistence-adapter-mock.rb'
  require_relative '../../../../../../port/lib/persistence-port.rb'
else
  require 'persistence-object'
  require 'persistence-adapter-mock'
  require 'persistence-port'
end

describe ::Persistence::Object::Persist::ObjectInstance do
  
  ################
  #  persist!    #
  #  persisted?  #
  ################
  
  it 'can persist an object and test whether it has been persisted' do
    class ::Persistence::Object::Persist::ObjectInstance::Mock
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
    ::Persistence::Object::Persist::ObjectInstance::Mock.new.instance_eval do
      persistence_id.should == nil
      persist!
      persistence_id.should == 0
      persisted?.should == true
    end
  end
    
end
