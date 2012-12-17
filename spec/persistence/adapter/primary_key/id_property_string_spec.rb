
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString do

  ####################################
  #  primary_key_for_attribute_name  #
  ####################################

  before :all do 
  	class ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock
      include ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString
      Delimiter = '-'
      def persistence_port
        return ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::MockPort.new
      end
    end
  end

  it 'should persist with a simple primary key' do    
    ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString::Mock.new.instance_eval do
      instance = Object.new
      instance.extend( ::CascadingConfiguration::Setting )
      instance.attr_object_configuration :persistence_id
      instance.persistence_id = 0
      primary_key_for_attribute_name( instance, :attribute_name ).should == '0-attribute_name'
    end
  end

end
