
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Index::BlockIndex do

  #################################
  #  block_index                  #
  #  block_index_with_duplicates  #
  #  has_block_index?             #
  #  index                        #
  #################################
  
  it 'can declare an arbitrary key/value index on an object' do
    class ::Persistence::Object::Index::BlockIndex::Mock
  
      include ::Persistence::Object::Complex

      block_index :block_index do |key, value|
        return value
      end
  
      block_index_with_duplicates :block_index_with_duplicates do |key, value|
        return value
      end
      
      has_block_index?( :block_index ).should == true
      has_index?( :block_index ).should == true
      has_block_index?( :block_index_with_duplicates ).should == true
      has_index?( :block_index_with_duplicates ).should == true
      index( :block_index ).is_a?( ::Persistence::Object::Index ).should == true
      index( :block_index_with_duplicates ).is_a?( ::Persistence::Object::Index ).should == true
      
    end    
  end
  
  ##################
  #  index_object  #
  ##################

  it 'can index an object by passing it to a block' do
    # we want this test without port enabled to start
    ::Persistence.disable_port( :mock )

    ::Persistence::Object::Index::BlockIndex::IndexExistingObjects = ::Module.new
    rspec = self
    ::Persistence::Object::Index::BlockIndex::IndexExistingObjects.module_eval do
      
      class IndexMock
        include ::Persistence::Object::Complex
        attr_accessor :some_value
      end
        
      object = IndexMock.new
  
      ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  
      indexing_proc = Proc.new do |object|
        object.some_value
      end
      
      index_instance = ::Persistence::Object::Index::BlockIndex.new( :block_index, object.persistence_bucket, false, & indexing_proc )
  
      # test keys required for block with no returns
      index_instance.requires_keys = true
      Proc.new { index_instance.index_object( object ) }.should rspec.raise_error
      # test keys not required for block with no returns
      index_instance.requires_keys = false
      Proc.new { index_instance.index_object( object ) }.should_not rspec.raise_error
    
      # now to test indexing we want to require keys be generated
      index_instance.requires_keys = true
    
      object.some_value = :some_key
      object.persist!
      index_instance.index_object( object )
      index_instance.persisted?( :some_key ).should == true
  
      ::Persistence.disable_port( :mock )
  
    end
  end

  ############################
  #  index_existing_objects  #
  ############################

  it 'can index an object by passing it to a block' do
    module ::Persistence::Object::Index::BlockIndex::IndexExistingObjects
      
      class ObjectInstance
        include ::Persistence::Object::Complex
        attr_accessor :some_value
      end

      ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    
      object = ObjectInstance.new

      object.persist!
    
      ObjectInstance.persist( object.persistence_id ).should == object

      indexing_proc = Proc.new do |object|
        :some_key
      end

      index_instance = ::Persistence::Object::Index::BlockIndex.new( :other_block_index, object.persistence_bucket, false, & indexing_proc )

      index_instance.persisted?( :some_key ).should == false
    
      index_instance.index_existing_objects
      index_instance.persisted?( :some_key ).should == true

      ::Persistence.disable_port( :mock )

    end
  end
  
end
