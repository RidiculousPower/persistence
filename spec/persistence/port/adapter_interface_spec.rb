
require_relative '../../../lib/persistence.rb'

require_relative '../adapter/mock_helpers.rb'

describe ::Persistence::Port::AdapterInterface do
  
  before :all do

    class ::Persistence::Port::AdapterInterface::Mock
      include ::Persistence::Port::Interface
      include ::Persistence::Port::AdapterInterface
    end

    @adapter = ::Persistence::Adapter::Mock.new
    @port_interface = ::Persistence::Port::AdapterInterface::Mock.new( :port_name, @adapter )
    @port_interface.enable
    
  end

  ################
  #  initialize  #
  ################

  it 'can initialize with a port name and adapter instance' do
    @port_interface.instance_eval do
      name.should == :port_name
    end
  end

  ###############
  #  enable     #
  #  enabled?   #
  #  disabled?  #
  #  disable    #
  ###############

  it 'can be enabled, disabled, and report whether it is enabled or not' do
    @port_interface.instance_eval do
      enable
      enabled?.should == true
      disabled?.should == false
      disable
      enabled?.should == false
      disabled?.should == true
      enable
    end
  end
  
  ########################
  #  persistence_bucket  #
  ########################
  
  it 'can return a persistence bucket instance linked to the bucket instance in the adapter' do
    @port_interface.persistence_bucket( :some_bucket ).is_a?( ::Persistence::Port::Bucket ).should == true
  end
  
  ###################################
  #  put_object!                    #
  #  get_bucket_name_for_object_id  #
  #  get_class_for_object_id        #
  #  get_object                     #
  #  get_object                     #
  #  delete_object!                 #
  #  get_flat_object                #
  ###################################

  it 'can interface with the adapter' do
    @object = ::Persistence::Adapter::Abstract::Mock::Object.new
    @object.class.instance_persistence_port = @port_interface
    bucket = @port_interface.persistence_bucket( :some_bucket )
    bucket.initialize_bucket_for_port( @port_interface )
    @object.class.instance_persistence_bucket = bucket
    @object.class.non_atomic_attribute_readers.push( :some_value, :other_value )
    @object.instance_eval do
      @some_value = :value
      @other_value = :other_value
    end
    @port_interface.put_object!( @object )
    @object.persistence_id.should_not == nil
    
    @port_interface.get_bucket_name_for_object_id( @object.persistence_id ).should == @object.persistence_bucket.name
    @port_interface.get_class_for_object_id( @object.persistence_id ).should == @object.class

    persisted_object = @port_interface.get_object( @object.persistence_id )
    persisted_object.persistence_id.should == @object.persistence_id
    @port_interface.delete_object!( @object.persistence_id )
    @port_interface.get_object( @object.persistence_id ).should == nil
    class String
      attr_accessor :persistence_id
      def self.instance_persistence_bucket
        return @bucket ||= ::Persistence::Adapter::Abstract::Mock::Object.instance_persistence_bucket
      end
      def persistence_bucket
        return self.class.instance_persistence_bucket
      end
      def persistence_hash_to_port
        return { self.class.to_s => self }
      end
    end
    some_string = 'some string'
    @port_interface.put_object!( some_string )
    @port_interface.get_flat_object( some_string.persistence_id ).should == some_string
  end
  
end
