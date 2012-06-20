
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Port::Controller do

  ###########################
  #  enable_port            #
  #  port                   #
  #  current_port           #
  #  disable_port           #
  #  set_current_port       #
  #  port_for_name_or_port  #
  ###########################

  it 'can enable a port with an adapter instance, get it by name or as the current port, disable it, and re-enable it later' do
    class ::Persistence::Port::Controller::Mock
      extend ::Persistence::Port::Controller
      mock_adapter_instance = ::Persistence::Adapter::Mock.new
      first_port = enable_port( :mock_adapter, mock_adapter_instance )
      mock_adapter_instance.enabled?.should == true
      port( :mock_adapter ).should == first_port
      first_port.enabled?.should == true
      current_port.should == first_port
      disable_port( :mock_adapter )
      current_port.should == nil
      mock_adapter_instance.disabled?.should == true
      second_mock_adapter_instance = ::Persistence::Adapter::Mock.new
      second_port = enable_port( :second_mock_adapter, second_mock_adapter_instance )
      port( :second_mock_adapter ).should == second_port
      second_port.enabled?.should == true
      current_port.should == second_port
      set_current_port( :mock_adapter )
      current_port.should == first_port
      current_port.disabled?.should == true
      set_current_port( nil )
      current_port.should == nil
      disable_port( :mock_adapter )
      disable_port( :second_mock_adapter )
    end
  end

  ############################
  #  create_pending_buckets  #
  #  pending_bucket  #
  ############################
  
  it 'can allow a bucket to be initialized before its port is open' do
    bucket_instance = ::Persistence.pending_bucket( ::Persistence::Port::Controller, :some_bucket )
    ::Persistence.instance_eval do
      pending_buckets.should == { ::Persistence::Port::Controller => bucket_instance }
    end
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    ::Persistence.instance_eval do
      pending_buckets.should == {}
    end
    bucket_instance.parent_port.should == ::Persistence.port( :mock )
    ::Persistence.disable_port( :mock )
  end

end
