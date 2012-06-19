
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Port::Bucket::ObjectInstance do
  
  #########################
  #  persistence_bucket   #
  #  persistence_bucket=  #
  #########################

  it 'can set and return a persistence bucket to be used for instances' do
    class ::Persistence::Port::Bucket::ObjectInstance::Mock
      include ::Persistence::Port::Bucket::ObjectInstance
      def self.instance_persistence_port
        @persistence_port ||= ::Persistence::Port.new( :mock_port, ::Persistence::Adapter::Mock.new )        
      end
      def persistence_port
        return self.class.instance_persistence_port
      end
      # mock function
      def self.instance_persistence_bucket
        return instance_persistence_port.persistence_bucket( to_s )
      end
    end
    object_instance = ::Persistence::Port::Bucket::ObjectInstance::Mock.new
    object_instance.persistence_bucket.name.to_s.should == ::Persistence::Port::Bucket::ObjectInstance::Mock.to_s
    object_instance.persistence_bucket = 'mock bucket'
    object_instance.persistence_bucket.name.to_s.should == 'mock bucket'
  end
  
end
