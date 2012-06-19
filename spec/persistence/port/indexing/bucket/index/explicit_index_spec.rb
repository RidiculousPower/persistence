
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex do

  ################################
  #  index_object                #
  #  persisted?                  #
  #  get_object_id               #
  #  index_object                #
  #  delete_keys_for_object_id!  #
  #  delete_object               #
  ################################
  
  it 'interfaces with an adapter instance' do    
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
      include ::Persistence::Cursor::Port::Bucket
      include ::Persistence::Cursor::Indexing::Port::Bucket
    end
    class ::Persistence::Cursor
      include ::Persistence::Cursor::Indexing::Cursor
    end
    class ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex::Mock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
    end
    
    object = ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex::Mock.new

    bucket = object.persistence_bucket

    bucket.index( :explicit_index ).should == nil

    # before port
    index_instance = ::Persistence::Port::Indexing::Bucket::Index.new( :explicit_index, bucket, false )
    Proc.new { bucket.create_index( :explicit_index, true ) }.should raise_error
    index_instance.is_a?( ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex ).should == true
    index_instance.permits_duplicates?.should == false
    Proc.new { index_instance.adapter_index }.should raise_error
    Proc.new { index_instance.index_object( object ) }.should raise_error
    Proc.new { index_instance.persisted?( :any_key ) }.should raise_error
    Proc.new { index_instance.get_object_id( :any_key ) }.should raise_error
    Proc.new { index_instance.index_object_id( any_id = 0, :any_key ) }.should raise_error
    Proc.new { index_instance.delete_keys_for_object_id!( any_id = 0 ) }.should raise_error
    
    # after port
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    
    index_instance.adapter_index.should_not == nil
    
    bucket.index( :other_explicit_index ).should == nil
    index_instance_two = ::Persistence::Port::Indexing::Bucket::Index.new( :other_explicit_index, bucket, true )
    index_instance_two.is_a?( ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex ).should == true
    index_instance_two.adapter_index.should_not == nil
    index_instance_two.permits_duplicates?.should == true
    index_instance_two_conflicting_settings = Proc.new { bucket.create_index( :other_explicit_index, false ) }.should raise_error
    
    index_instance.persisted?( :any_key ).should == false
    index_instance.get_object_id( :any_key ).should == nil
    
    # put object
    object.persist!
    
    # create arbitrary index value for object
    index_instance.index_object( object, :some_key )
    
    # test retrieval of ID for index value
    index_instance.persisted?( :some_key ).should == true
    index_instance.get_object_id( :some_key ).should == object.persistence_id
    
    # delete keys
    index_instance.delete_keys_for_object_id!( object.persistence_id )
    index_instance.get_object_id( :some_key ).should == nil
    
    # delete object
    index_instance.index_object( object, :some_key )
    index_instance.get_object_id( :some_key ).should == object.persistence_id
    index_instance.delete_keys_for_object!( object )
    index_instance.get_object_id( :some_key ).should == nil
    
    ::Persistence.disable_port( :mock )
    
  end

end