
require_relative '../../../lib/persistence.rb'

require_relative '../adapter/mock_helpers.rb'

describe ::Persistence::Port::PortInterface do
  
  before :all do

    class ::Persistence::Port::PortInterface::Mock
      include ::Persistence::Port::PortInterface
    end

    @adapter = ::Persistence::Adapter::Mock.new
    @port_interface = ::Persistence::Port::PortInterface::Mock.new( :port_name, @adapter )
    @port_interface.enable
    
  end

  before :each do 
    @object = ::Persistence::Adapter::Abstract::Mock::Object.new
    @object.class.instance_persistence_port = @port_interface
    bucket = @port_interface.persistence_bucket( :some_bucket )
    bucket.initialize_for_port( @port_interface )
    @object.class.instance_persistence_bucket = bucket
    @object.class.non_atomic_attribute_readers.push( :some_value, :other_value )
    @object.instance_eval do
      @some_value = :value
      @other_value = :other_value
    end

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
  end

  ################
  #  initialize  #
  ################

  context "#initialize" do 
    it 'should initialize with a port name and adapter instance' do
      @port_interface.instance_eval do
        name.should == :port_name
      end
    end
  end
  ###############
  #  enable     #
  #  enabled?   #
  #  disabled?  #
  #  disable    #
  ###############

  context "#initialize cycle" do 
    before :each do 
      @port_interface.enable
    end

    context "#enable" do 
      it "should enable the port" do 
        @port_interface.enable #will fail with Exception
      end
    end

    context "#enabled?" do
      it "should return true if port is enabled" do 
        @port_interface.enabled?.should == true
      end
    end     

    context "#disabled?" do 
    
      it "should return true if port is enabled" do 
        @port_interface.disabled?.should == false
      end
    end  

    context "#disable" do 
      it "should disable the port" do 
        @port_interface.disable
        @port_interface.enabled?.should == false
      end
    end      
  end

  ########################
  #  persistence_bucket  #
  ########################
  
  context "#persistence_bucket" do 
    it 'should return a persistence bucket instance linked to the bucket instance in the adapter' do
      @port_interface.enable
      @port_interface.persistence_bucket( :some_bucket ).is_a?( ::Persistence::Port::Bucket ).should == true
    end
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
  
  context "#put_object" do 
    it "should persist an object" do 
      @port_interface.enable
      @port_interface.put_object!( @object )
      @object.persistence_id.should_not == nil
    end
  end
  
  context "after put_object!" do 
    before :each do 
      @port_interface.enable
      @port_interface.put_object!( @object )
    end

    context "#get_bucket_name_for_object_id" do 
      it "should get the bucket name of the persisted object" do 
        @port_interface.get_bucket_name_for_object_id( @object.persistence_id ).should == @object.persistence_bucket.name
      end
    end
    context "#get_class_for_object_id" do 
      it "should get the class of the persisted object" do 
        @port_interface.get_class_for_object_id( @object.persistence_id ).should == @object.class
      end
    end
    context "#get_object" do 
      it "should get the persisted object" do 
        persisted_object = @port_interface.get_object( @object.persistence_id )
        persisted_object.persistence_id.should == @object.persistence_id
      end
    end
    context "#delete_object" do 
      it "should delete the persisted object" do 
        @port_interface.delete_object!( @object.persistence_id )
    @port_interface.get_object( @object.persistence_id ).should == nil
      end
    end
    context "#get_flat_object" do 
      it "should get a persisted flat object" do 
        some_string = 'some string'
        @port_interface.put_object!( some_string )
        @port_interface.get_flat_object( some_string.persistence_id ).should == some_string
      end
    end
  end
end