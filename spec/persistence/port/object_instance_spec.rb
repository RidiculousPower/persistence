
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Port::ObjectInstance do

  #######################
  #  persistence_port=  #
  #  persistence_port   #
  #######################

  it "it can set and return a persistence port, either from an instance, a name, or another instance's persistence port, or from its class's instance persistence port by default" do
    class ::Persistence::Port::ObjectInstance::Mock
      include ::Persistence::Port::ObjectInstance
      # mock function
      def self.instance_persistence_port
        return :instance_port
      end      
    end
    ::Persistence::Port::ObjectInstance::Mock.new.instance_eval do
      persistence_port.should == :instance_port
      self.persistence_port = :another_port
    end
  end
  
end
