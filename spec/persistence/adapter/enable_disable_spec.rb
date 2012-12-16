
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Adapter::Abstract::EnableDisable do

  ################
  #  initialize  #
  ################

  home_directory_location = '/tmp/persistence_spec_home_directory'

  before :all do 
  	class ::Persistence::Adapter::Abstract::EnableDisable::Mock
      include ::Persistence::Adapter::Abstract::EnableDisable
    end
    class ::Persistence::Adapter::Abstract::EnableDisable::Mock
      include ::Persistence::Adapter::Abstract::EnableDisable
    end
    
  end
  
  after :each do 
  	Dir.delete( home_directory_location )
  end

  let(:adapter) {::Persistence::Adapter::Abstract::EnableDisable::Mock.new( home_directory_location )}

	#can initialize with a home directory specified
  it "should not be enabled by default" do 
  	adapter.enabled?.should == false
  end

  context "after enable" do 
  	before :each do 
  	  adapter.enable
  	end
  	
	  it "should be enabled" do 
      adapter.enabled?.should == true
	  end
	  it "should disable" do 
      adapter.disable
      adapter.enabled?.should == false
	  end
	  context "home_directory" do 
		  it "should exist" do 
	      File.exists?( adapter.home_directory ).should == true
		  end
		  it "should be the same directory as user defined" do       
	      adapter.home_directory.should == home_directory_location
		  end
    end
  end


end
