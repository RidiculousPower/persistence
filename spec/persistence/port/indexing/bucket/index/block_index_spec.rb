
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Port::Indexing::Bucket::Index::BlockIndex do

  ##################
  #  index_object  #
  ##################

  it 'can index an object by passing it to a block' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
      include ::Persistence::Cursor::Port::Bucket
      include ::Persistence::Cursor::Indexing::Port::Bucket
    end
    class ::Persistence::Port::Bucket::Index
      include ::Persistence::Cursor::Indexing::Port::Bucket::Index
    end
    class ::Persistence::Cursor
      include ::Persistence::Cursor::Indexing::Cursor
    end
    
    class ::Persistence::Port::Indexing::Bucket::Index::BlockIndex::Mock01
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      attr_accessor :some_value
    end
        
    object = ::Persistence::Port::Indexing::Bucket::Index::BlockIndex::Mock01.new

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    index_instance = ::Persistence::Port::Indexing::Bucket::Index.new( :block_index, object.persistence_bucket, false )
    index_instance.extend( ::Persistence::Port::Indexing::Bucket::Index::BlockIndex )
    indexing_proc = Proc.new do |object|
      object.some_value
    end
    index_instance.indexing_procs.push( indexing_proc )
    # test keys required for block with no returns
    index_instance.requires_keys = true
    Proc.new { index_instance.index_object( object ) }.should raise_error
    # test keys not required for block with no returns
    index_instance.requires_keys = false
    Proc.new { index_instance.index_object( object ) }.should_not raise_error
    
    # now to test indexing we want to require keys be generated
    index_instance.requires_keys = true
    
    object.some_value = :some_key
    object.persist!
    index_instance.index_object( object )
    index_instance.persisted?( :some_key ).should == true

    ::Persistence.disable_port( :mock )

  end

  ############################
  #  index_existing_objects  #
  ############################

  it 'can index an object by passing it to a block' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
      include ::Persistence::Cursor::Port::Bucket
      include ::Persistence::Cursor::Indexing::Port::Bucket
    end
    class ::Persistence::Port::Bucket::Index
      include ::Persistence::Cursor::Indexing::Port::Bucket::Index
    end
    class ::Persistence::Cursor
      include ::Persistence::Cursor::Indexing::Cursor
    end
    class ::Persistence::Port::Indexing::Bucket::Index::BlockIndex::Mock02
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      attr_accessor :some_value
    end

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    
    object = ::Persistence::Port::Indexing::Bucket::Index::BlockIndex::Mock02.new

    object.persist!
    
    ::Persistence::Port::Indexing::Bucket::Index::BlockIndex::Mock02.persist( object.persistence_id ).should == object

    index_instance = ::Persistence::Port::Indexing::Bucket::Index.new( :other_block_index, object.persistence_bucket, false )
    index_instance.extend( ::Persistence::Port::Indexing::Bucket::Index::BlockIndex )
    indexing_proc = Proc.new do |object|
      :some_key
    end
    index_instance.indexing_procs.push( indexing_proc )
    index_instance.persisted?( :some_key ).should == false
    
    index_instance.index_existing_objects
    index_instance.persisted?( :some_key ).should == true

    ::Persistence.disable_port( :mock )

  end

end
