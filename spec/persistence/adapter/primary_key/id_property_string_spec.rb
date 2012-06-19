
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString do

  ###################################
  #  primary_key_for_attribute_name  #
  ###################################

  it 'can be used for a simple primary key' do
    class ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock
      include ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString
      include ::CascadingConfiguration::Setting
      SerializationClass = Marshal
      SerializationMethod = :dump
      attr_instance_configuration :persistence_id
      def persistence_port
        return ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::MockPort.new
      end
    end
    ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock.new.instance_eval do
      self.persistence_id = 0
      instance = Object.new
      primary_key_for_attribute_name( self, :attribute_name ).should == ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock::SerializationClass.__send__( ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock::SerializationMethod, [ persistence_id, :attribute_name ] )
      primary_key_for_attribute_name( self, instance ).should == ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock::SerializationClass.__send__( ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock::SerializationMethod, [ persistence_id, instance ] )
    end
  end

end
