
require_relative '../../../lib/persistence.rb'

require_relative './mock_helpers.rb'

describe ::Persistence::Adapter::Mock do
  
  before( :all ) do
    @adapter = ::Persistence::Adapter::Mock.new( '/tmp/persistence_home' )
    @object = ::Persistence::Adapter::Abstract::Mock::Object.new
    @object.persistence_port = ::Persistence::Adapter::Abstract::Mock::Port.new( :test_port, @adapter )
    @object.persistence_port.enable
    @object.persistence_bucket = ::Persistence::Adapter::Abstract::Mock::Bucket.new( @object.class.to_s )
    @object.value = :some_value
    @bucket = @adapter.persistence_bucket( @object.persistence_bucket.name )
    @value_index = nil
    @duplicate_value_index = nil
  end
  
  ################
  #  initialize  #
  #  enable      #
  #  disable     #
  #  enabled?    #
  ################

  it 'can initialize enabled state, enable, disable, and report whether enabled' do
    @object.persistence_port.instance_eval do
      enabled?.should == true
      disable
      enabled?.should == false
      enable
      enabled?.should == true
    end
  end

  #################
  #  put_object!  #
  #################

  it "can put and get an object with simple properties and sub objects" do
  
    # put_object!
    @bucket.put_object!( @object )
    @object.persistence_id.should_not == nil
    
    retrieved_object_hash = @bucket.get_object( @object.persistence_id )
    retrieved_object_hash.should == @object.persistence_hash_to_port
    
  end

  ###########
  #  count  #
  ###########
  
  it 'can report how many objects are persisted' do
    
    @bucket.count.should == 1
    
  end

  ####################
  #  delete_object!  #
  ####################

  it "can delete an object" do

    # delete_object!
    @bucket.delete_object!( @object.persistence_id )
    @bucket.get_object( @object.persistence_id ).should == nil

    # now put it back
    @object.persistence_id = nil
    @bucket.put_object!( @object )
    retrieved_object_hash = @bucket.get_object( @object.persistence_id )
    retrieved_object_hash.should == @object.persistence_hash_to_port
    
  end

  ##############################
  #  get_bucket_name_for_object_id  #
  ##############################

  it "can get a bucket for a given object ID" do

    # get_bucket_name_for_object_id
    @adapter.get_bucket_name_for_object_id( @object.persistence_id ).should == @object.persistence_bucket.name
  
  end

  #############################
  #  get_class_for_object_id  #
  #############################

  it "can get a class for a given object ID" do

    # get_class_for_object_id
    @adapter.get_class_for_object_id( @object.persistence_id ).should == @object.class
  
  end

  ####################
  #  put_attribute!  #
  ####################

  it "can put a attribute for an object" do
  
    # put_attribute!
    primary_key = @bucket.primary_key_for_attribute_name( @object, :attribute )
    @bucket.put_attribute!( @object, primary_key, 'attribute!' )
  
  end

  ###################
  #  get_attribute  #
  ###################

  it "can get a attribute for an object" do

    # get_attribute
    primary_key = @bucket.primary_key_for_attribute_name( @object, :attribute )
    @bucket.get_attribute( @object, primary_key ).should == 'attribute!'
  
  end

  #######################
  #  delete_attribute!  #
  #######################

  it "can delete a attribute on an object" do

    # delete_attribute!
    primary_key = @bucket.primary_key_for_attribute_name( @object, :attribute )
    @bucket.delete_attribute!( @object, primary_key )
    @bucket.get_attribute( @object, primary_key ).should == nil
  
  end

  ##################
  #  create_index  #
  #  has_index?    #
  #  index         #
  ##################

  it 'can create an index on a class so instances can be retrieved by key and report whether a given index exists' do
    @bucket.create_index( :key, false )
    @bucket.has_index?( :key ).should == true
    @bucket.index( :key ).should_not == nil
    @bucket.create_index( :duplicate_key, true )
    @bucket.has_index?( :duplicate_key ).should == true
    @bucket.index( :duplicate_key ).should_not == nil
  end

  #########################
  #  permits_duplicates?  #
  #########################

  it 'can report whether an index permits duplicate entries' do
    @bucket.index( :key ).permits_duplicates?.should == false
    @bucket.index( :duplicate_key ).permits_duplicates?.should == true
  end

  ##################
  #  index_object  #
  ##################

  it 'can index an object based on a created index so that the object ID can be retrieved by key' do
    @bucket.index( :key ).index_object_id( @object.persistence_id, @object.value )
    @bucket.index( :key ).get_object_id( @object.value ).should == @object.persistence_id
  end

  ###########
  #  count  #
  ###########
  
  it 'can report how many objects are persisted' do
    
    @bucket.index( :key ).count.should == 1
    
  end

  ###################
  #  get_object_id  #
  ###################

  it "can get the object ID corresponding to a key in a bucket" do
  
    # get_object_id_for_index_and_key
    @bucket.index( :key ).get_object_id( @object.value ).should == @object.persistence_id

  end

  ################################
  #  delete_keys_for_object_id!  #
  ################################

  it 'can delete index values for an object' do
    @bucket.index( :key ).delete_keys_for_object_id!( @object.persistence_id )
    ( @bucket.index( :key ).get_object_id( @object.value ) ? true : false ).should == false
  end

  ##################
  #  delete_index  #
  ##################

  it 'can delete an index that has been created on a class attribute' do
    @bucket.delete_index( :key )
    @bucket.has_index?( :key ).should == false
  end
  
end
