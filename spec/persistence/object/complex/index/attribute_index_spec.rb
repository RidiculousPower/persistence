
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Index::AttributeIndex do

  ##################
  #  index_object  #
  ##################

  it 'can index a specific attribute on an object' do

    class ::Persistence::Object::Complex::Index::AttributeIndex::Mock
      include ::Persistence::Object::Complex
      attr_non_atomic_accessor :some_value
    end
    
    object = ::Persistence::Object::Complex::Index::AttributeIndex::Mock.new

    bucket = object.persistence_bucket

    bucket.index( :attribute_index ).should == nil

    # before port
    index_instance = ::Persistence::Object::Complex::Index::AttributeIndex.new( :attribute_index, bucket, false )
    index_instance.attribute_name = :some_value
    Proc.new { bucket.create_index( :attribute_index, true ) }.should raise_error
    index_instance.permits_duplicates?.should == false
    Proc.new { index_instance.adapter_index }.should raise_error
    Proc.new { index_instance.index_object( object  ) }.should raise_error
    Proc.new { index_instance.persisted?( :any_key ) }.should raise_error
    Proc.new { index_instance.get_object_id( :any_key ) }.should raise_error
    Proc.new { index_instance.index_object_id( any_id = 0, :any_key ) }.should raise_error
    Proc.new { index_instance.delete_keys_for_object_id!( any_id = 0 ) }.should raise_error

    # after port
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    index_instance.adapter_index.should_not == nil

    bucket.index( :other_attribute_index ).should == nil
    index_instance_two = ::Persistence::Object::Complex::Index::AttributeIndex.new( :other_attribute_index, bucket, true )
    index_instance_two.attribute_name = :some_value
    index_instance_two.adapter_index.should_not == nil
    index_instance_two.permits_duplicates?.should == true
    index_instance_two_conflicting_settings = Proc.new { bucket.create_index( :other_attribute_index, false ) }.should raise_error

    index_instance.persisted?( :any_key ).should == false
    index_instance.get_object_id( :any_key ).should == nil

    object.some_value = :some_key

    # put object
    object.persist!

    # create arbitrary index value for object
    index_instance.index_object( object )
    
    # test retrieval of ID for index value
    index_instance.persisted?( :some_key ).should == true
    index_instance.get_object_id( :some_key ).should == object.persistence_id

    # delete keys
    index_instance.delete_keys_for_object_id!( object.persistence_id )
    index_instance.get_object_id( :some_key ).should == nil
    
    # delete object
    index_instance.index_object( object )
    index_instance.get_object_id( :some_key ).should == object.persistence_id
    index_instance.delete_keys_for_object!( object )
    index_instance.get_object_id( :some_key ).should == nil
    
    ::Persistence.disable_port( :mock )
    
  end

end
