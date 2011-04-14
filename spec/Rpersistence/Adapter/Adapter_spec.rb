require_relative 'Mock.rb'
require_relative 'Private/Mock.rb'
require_relative '../Mock/Object.rb'


describe Rpersistence::Adapter do

  before( :all ) do
    # initialize
    @adapter = $__rpersistence__spec__adapter_test_class__.new( $__rpersistence__spec__adapter_home_directory__ )
    @adapter.enable    
    @object = Rpersistence::Mock::Object.new
  end

  after( :all ) do
    @adapter.disable
  end

  ############
  #  enable  #
  ############

  it "can be enabled" do
    @adapter.enabled?.should == true
  end

  ##################
  #  disable_port  #
  ##################

  it "can be disabled" do
    @adapter.disable
    @adapter.enabled?.should == false
    @adapter.enable
  end

  #################
  #  put_object!  #
  #################

  it "can put an object" do
  
    # put_object!
    @adapter.put_object!( @object )
    @object.persistence_id.should_not == nil

  end

  ########################################
  #  persistence_key_exists_for_bucket?  #
  ########################################

  it "can report if a persistence key exists in a given bucket" do
  
    # persistence_key_exists_for_bucket?
    @adapter.persistence_key_exists_for_bucket?( @object.persistence_bucket, @object.persistence_key ).should == true

  end

  ################
  #  get_object  #
  ################

  it "can get an object" do

    # get_object
    retrieved_object_hash = @adapter.get_object( @object.persistence_id, @object.persistence_bucket )
    retrieved_object_hash.delete( :@__rpersistence__id__ )
    retrieved_object_hash.should == @object.instance_variable_hash
  
  end

  ######################################
  #  get_object_id_for_bucket_and_key  #
  ######################################

  it "can get the object ID corresponding to a key in a bucket" do
  
    # get_object_id_for_bucket_and_key
    @adapter.get_object_id_for_bucket_and_key( @object.persistence_bucket, @object.persistence_key ).should == @object.persistence_id

  end

  ########################################
  #  get_bucket_key_class_for_object_id  #
  ########################################

  it "can get a bucket and key for a given object ID" do

    # get_bucket_key_class_for_object_id
    @adapter.get_bucket_key_class_for_object_id( @object.persistence_id ).should == [ @object.persistence_bucket, @object.persistence_key, @object.class ]
  
  end

  ###################
  #  put_property!  #
  ###################

  it "can put a property for an object" do
  
    # put_property!
    @adapter.put_property!( @object, :@property, 'property!' )
  
  end

  ##################
  #  get_property  #
  ##################

  it "can get a property for an object" do

    # get_property
    @adapter.get_property( @object, :@property ).should == 'property!'
  
  end

  ######################
  #  delete_property!  #
  ######################

  it "can delete a property on an object" do

    # delete_property!
    @adapter.delete_property!( @object, :@property )
    @adapter.get_property( @object, :@property ).should == nil
  
  end

  ####################
  #  delete_object!  #
  ####################

  it "can delete an object" do

    # delete_object!
    @adapter.delete_object!( @object.persistence_id, @object.persistence_bucket )
    @adapter.get_object( @object.persistence_id, @object.persistence_bucket ).should == {}

  end

  ############################################# Indexes #####################################################

  ###################
  #  index_object!  #
  ###################

  #################################
  #  index_attribute_for_bucket!  #
  #################################

end
