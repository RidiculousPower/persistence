require_relative '../../../lib/rpersistence.rb'
require_relative '../Mock/Object.rb'

# defined so that this spec file will run independently
$__rpersistence__spec__adapter_test_class__       ||= Rpersistence::Adapter::Mock
$__rpersistence__spec__adapter_home_directory__   ||= nil

describe Rpersistence::Adapter do

  before( :all ) do
    # initialize
    @object = Rpersistence::Mock::Object.new
    @object.persistence_port = Rpersistence::Port.new( :test_port, $__rpersistence__spec__adapter_test_class__.new( $__rpersistence__spec__adapter_home_directory__ ) )
    @object.persistence_port.enable
    @object.some_value = 'persisted value'
  end

  after( :all ) do
    @object.persistence_port.adapter.disable
  end

  ############
  #  enable  #
  ############

  it "can be enabled" do
    @object.persistence_port.adapter.enabled?.should == true
  end

  ##################
  #  disable_port  #
  ##################

  it "can be disabled" do
    @object.persistence_port.adapter.disable
    @object.persistence_port.adapter.enabled?.should == false
    @object.persistence_port.adapter.enable
  end

  #################
  #  put_object!  #
  #################

  it "can put an object" do
  
    # put_object!
    @object.persistence_port.adapter.put_object!( @object )
    @object.persistence_id.should_not == nil

  end

  ########################################
  #  persistence_key_exists_for_bucket?  #
  ########################################

  it "can report if a persistence key exists in a given bucket" do
  
    # persistence_key_exists_for_bucket?
    @object.persistence_port.adapter.persistence_key_exists_for_bucket?( @object.persistence_bucket, @object.persistence_key ).should == true

  end

  ################
  #  get_object  #
  ################

  it "can get an object" do

    # get_object
    retrieved_object_hash = @object.persistence_port.adapter.get_object( @object.persistence_id, @object.persistence_bucket )
    retrieved_object_hash.delete( :@__rpersistence__id__ )
    retrieved_object_hash.should == @object.instance_variable_hash
  
  end

  ######################################
  #  get_object_id_for_bucket_and_key  #
  ######################################

  it "can get the object ID corresponding to a key in a bucket" do
  
    # get_object_id_for_bucket_and_key
    @object.persistence_port.adapter.get_object_id_for_bucket_and_key( @object.persistence_bucket, @object.persistence_key ).should == @object.persistence_id

  end

  ########################################
  #  get_bucket_key_class_for_object_id  #
  ########################################

  it "can get a bucket and key for a given object ID" do

    # get_bucket_key_class_for_object_id
    @object.persistence_port.adapter.get_bucket_key_class_for_object_id( @object.persistence_id ).should == [ @object.persistence_bucket, @object.persistence_key, @object.class ]
  
  end

  ###################
  #  put_property!  #
  ###################

  it "can put a property for an object" do
  
    # put_property!
    @object.persistence_port.adapter.put_property!( @object, :@property, 'property!' )
  
  end

  ##################
  #  get_property  #
  ##################

  it "can get a property for an object" do

    # get_property
    @object.persistence_port.adapter.get_property( @object, :@property ).should == 'property!'
  
  end

  ######################
  #  delete_property!  #
  ######################

  it "can delete a property on an object" do

    # delete_property!
    @object.persistence_port.adapter.delete_property!( @object, :@property )
    @object.persistence_port.adapter.get_property( @object, :@property ).should == nil
  
  end

  ####################
  #  delete_object!  #
  ####################

  it "can delete an object" do

    # delete_object!
    @object.persistence_port.adapter.delete_object!( @object.persistence_id, @object.persistence_bucket )
    @object.persistence_port.adapter.get_object( @object.persistence_id, @object.persistence_bucket ).should == {}

  end

  ############################################# Indexes #####################################################

  ###################
  #  index_object!  #
  ###################

  #################################
  #  index_attribute_for_bucket!  #
  #################################

end
