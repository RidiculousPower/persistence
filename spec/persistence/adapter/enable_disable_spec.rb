
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Adapter::Abstract::EnableDisable do

  ################
  #  initialize  #
  ################

  it 'can initialize with a home directory specified' do
    class ::Persistence::Adapter::Abstract::EnableDisable::Mock
      include ::Persistence::Adapter::Abstract::EnableDisable
    end
    home_directory_location = '/tmp/persistence_spec_home_directory'
    ::Persistence::Adapter::Abstract::EnableDisable::Mock.new( home_directory_location ).instance_eval do
      enabled?.should == false
      enable
      enabled?.should == true
      disable
      enabled?.should == false
      enable
      File.exists?( home_directory_location ).should == true
      self.home_directory.should == home_directory_location
      Dir.delete( home_directory_location )
      File.exists?( home_directory_location ).should == false
    end    
  end

end
