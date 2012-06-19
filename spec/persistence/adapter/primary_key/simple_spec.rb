
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Adapter::Abstract::PrimaryKey::Simple do

  ###################################
  #  primary_key_for_attribute_name  #
  ###################################

  it 'can be used for a simple primary key' do
    class ::Persistence::Adapter::Abstract::PrimaryKey::Simple::Mock
      include ::Persistence::Adapter::Abstract::PrimaryKey::Simple
    end
    ::Persistence::Adapter::Abstract::PrimaryKey::Simple::Mock.new.instance_eval do
      primary_key_for_attribute_name( self, :attribute_name ).should == :attribute_name
    end
  end
  
end
