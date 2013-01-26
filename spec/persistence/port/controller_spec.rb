
require_relative '../../../lib/persistence.rb'
require_relative '../adapter/mock_helpers.rb'

describe ::Persistence::Port::Controller do

  ###########################
  #  enable_port                              #
  #  port                                          #
  #  current_port                             #
  #  disable_port                             #
  #  set_current_port                       #
  #  port_for_name_or_port            #
  ###########################

  before :all do
    class ::Persistence::Port::Controller::Mock
      extend ::Persistence::Port::Controller
    end
  end

  after :each do
    class ::Persistence::Port::Controller::Mock
      disable_port( :mock_adapter )
    end
    ::Persistence.disable_port( :mock_adapter )
  end

  context "#enable_port"  do
    it "should enable the adapter instance" do
      class ::Persistence::Port::Controller::Mock
        mock_adapter_instance = ::Persistence::Adapter::Mock.new
        enable_port( :mock_adapter, mock_adapter_instance )
        mock_adapter_instance.enabled?.should == true
      end
    end

    it "should enable the port" do
      class ::Persistence::Port::Controller::Mock
        first_port = enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        first_port.enabled?.should == true
      end
    end
  end
  context "#port" do

    it "should return a port" do
      class ::Persistence::Port::Controller::Mock
        first_port = enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        port( :mock_adapter ).should == first_port
      end
    end

    it "the returned port should be enabled" do
      class ::Persistence::Port::Controller::Mock
        enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        port(:mock_adapter).enabled?.should == true
      end
    end
  end

  context "#current_port" do

    it "should return the active port" do
      class ::Persistence::Port::Controller::Mock
        first_port = enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        current_port.should == first_port
      end
    end
  end

  context "#disable_port" do

    it "#port should be disabled" do
      class ::Persistence::Port::Controller::Mock
        enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        disable_port( :mock_adapter )
        port(:mock_adapter).enabled?.should == false
      end
    end

    it "#current_port should be nil" do
      class ::Persistence::Port::Controller::Mock
        enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        disable_port( :mock_adapter )
        current_port.should == nil
      end
    end

    it "should disable the adapter instance" do
      class ::Persistence::Port::Controller::Mock
        mock_adapter_instance = ::Persistence::Adapter::Mock.new
        enable_port( :mock_adapter, mock_adapter_instance )
        disable_port( :mock_adapter )
        mock_adapter_instance.enabled?.should == false
      end
    end
  end
  context "#set_current_port" do
    it "should set a port regardless of its state" do
      class ::Persistence::Port::Controller::Mock
        port = enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        disable_port( :mock_adapter )
        set_current_port( :mock_adapter )
        current_port.should == port
      end
    end

    it "should be able to set port to nil" do
      class ::Persistence::Port::Controller::Mock
        enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        set_current_port( nil )
        current_port.should == nil
      end
    end
  end

  context "#re-enable" do
    it "should be able to re-enable a disabled port" do
      class ::Persistence::Port::Controller::Mock
        first_port = enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
        disable_port( :mock_adapter )
        enable_port( :mock_adapter )
        first_port.enabled?.should == true
      end
    end
  end

  ############################
  #  create_pending_buckets            #
  #  pending_bucket                         #
  ############################

  context "#pending_bucket" do
    it "should be able to crate buckets before the port is enabled" do
      bucket_instance = ::Persistence.pending_bucket( ::Persistence::Port::Controller, :some_bucket )
      ::Persistence.pending_buckets.should == { ::Persistence::Port::Controller => bucket_instance }
    end

    it "pending buckets should be removed after port is enabled" do
      ::Persistence.pending_bucket( ::Persistence::Port::Controller, :some_bucket )
      port = ::Persistence.enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
      ::Persistence.pending_buckets.should == {}
    end

    it "instance should get the enabled port set to parent_port" do
      bucket_instance = ::Persistence.pending_bucket( ::Persistence::Port::Controller, :some_bucket )
      ::Persistence.enable_port( :mock_adapter, ::Persistence::Adapter::Mock.new )
      bucket_instance.parent_port.should == ::Persistence.port( :mock_adapter )
    end
  end

end
