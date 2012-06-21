
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Indexing::PersistAndCease do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end

  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ################
  #  persist!    #
  #  persisted?  #
  #  persist     #
  ################

  it 'can persist with an index and explicit key' do
    module ::Persistence::Object::Indexing::PersistAndCease::PersistMock
    
      class ObjectMock
      
        include ::Persistence::Port::ObjectInstance
        extend ::Persistence::Port::ClassInstance
        include ::Persistence::Object::ObjectInstance
        extend ::Persistence::Object::ClassInstance
        include ::Persistence::Object::Indexing::Indexes
        extend ::Persistence::Object::Indexing::Indexes
        include ::Persistence::Object::Indexing::Indexes::Explicit::ObjectInstance
        extend ::Persistence::Object::Indexing::Indexes::Explicit::ClassInstance      
        include ::Persistence::Object::Indexing::Indexes::Block::ObjectInstance
        extend ::Persistence::Object::Indexing::Indexes::Block::ClassInstance      
        include ::Persistence::Object::Indexing::ParsePersistenceArgs
        extend ::Persistence::Object::Indexing::ParsePersistenceArgs
        include ::Persistence::Object::Indexing::PersistAndCease::ObjectInstance
        extend ::Persistence::Object::Indexing::PersistAndCease::ClassInstance      
        include ::Persistence::Object::Equality

        explicit_index :explicit_index

        # mock - not relevant to explicit indexing
        def self.non_atomic_attribute_readers
          return [ ]
        end

        def persistence_hash_to_port
        end
        
      end

      encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default )

      ObjectMock.count.should == 0
      ObjectMock.count( :explicit_index ).should == 0
      instance_one = ObjectMock.new.persist!
      instance_one.persistence_id.should_not == nil
      ObjectMock.count.should == 1
      ObjectMock.count( :explicit_index ).should == 0
      
      instance_two = ObjectMock.new.persist!( :explicit_index, :some_key )
      instance_two.persistence_id.should_not == nil
      ObjectMock.count.should == 2
      ObjectMock.count( :explicit_index ).should == 1
      persisted_instance_two_a = ObjectMock.persist( instance_two.persistence_id )
      persisted_instance_two_a.should == instance_two
      persisted_instance_two_b = ObjectMock.persist( :explicit_index, :some_key )
      persisted_instance_two_b.should == instance_two
    
    end
  end

  ############
  #  cease!  #
  ############

  it 'can persist with an index and explicit key' do
    module ::Persistence::Object::Indexing::PersistAndCease::CeaseMock

      class ObjectMock

        include ::Persistence::Port::ObjectInstance
        extend ::Persistence::Port::ClassInstance
        include ::Persistence::Object::ObjectInstance
        extend ::Persistence::Object::ClassInstance
        include ::Persistence::Object::Indexing::Indexes
        extend ::Persistence::Object::Indexing::Indexes
        include ::Persistence::Object::Indexing::Indexes::Explicit::ObjectInstance
        extend ::Persistence::Object::Indexing::Indexes::Explicit::ClassInstance      
        include ::Persistence::Object::Indexing::ParsePersistenceArgs
        extend ::Persistence::Object::Indexing::ParsePersistenceArgs
        include ::Persistence::Object::Indexing::PersistAndCease::ObjectInstance
        extend ::Persistence::Object::Indexing::PersistAndCease::ClassInstance      
        include ::Persistence::Object::Indexing::PersistAndCease::ObjectInstance
        extend ::Persistence::Object::Indexing::PersistAndCease::ClassInstance      
        include ::Persistence::Object::Indexing::Indexes::Block::ObjectInstance
        extend ::Persistence::Object::Indexing::Indexes::Block::ClassInstance
        
        explicit_index :explicit_index
        
        # mock - not relevant to explicit indexing
        def self.non_atomic_attribute_readers
          return [ ]
        end
        
        def persistence_hash_to_port
        end
        
      end
      instance_one = ObjectMock.new.persist!
      instance_one.persistence_id.should_not == nil
      instance_one.cease!
      ObjectMock.persist( instance_one.persistence_id ).should == nil
      instance_two = ObjectMock.new.persist!
      instance_two.persistence_id.should_not == nil
      ObjectMock.cease!( instance_two.persistence_id )
      ObjectMock.persist( instance_two.persistence_id ).should == nil    
      instance_three = ObjectMock.new.persist!( :explicit_index, :some_key )
      instance_three.persistence_id.should_not == nil
      instance_three.cease!
      index = ObjectMock.index( :explicit_index )
      index.get_object_id( :some_key ).should == nil
      ObjectMock.persist( :explicit_index, :some_key ).should == nil
      ObjectMock.persist( instance_three.persistence_id ).should == nil
      instance_four = ObjectMock.new.persist!( :explicit_index, :some_key )
      instance_four.persistence_id.should_not == nil
      ObjectMock.cease!( :explicit_index, :some_key )
      index = ObjectMock.index( :explicit_index )
      index.get_object_id( :some_key ).should == nil
      ObjectMock.persist( :explicit_index, :some_key ).should == nil
      ObjectMock.persist( instance_four.persistence_id ).should == nil
    
    end
  end

end
