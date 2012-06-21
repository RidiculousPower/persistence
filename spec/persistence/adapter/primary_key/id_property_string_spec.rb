
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString do

  ####################################
  #  primary_key_for_attribute_name  #
  ####################################

  it 'can be used for a simple primary key' do
    class ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock
      include ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString
      Delimiter = '-'
      def persistence_port
        return ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::MockPort.new
      end
    end
    ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock.new.instance_eval do
      instance = Object.new
      instance.extend( ::CascadingConfiguration::Setting )
      instance.attr_object_configuration :persistence_id
      instance.persistence_id = 0
      primary_key_for_attribute_name( instance, :attribute_name ).should == '0-attribute_name'
    end
  end

end
