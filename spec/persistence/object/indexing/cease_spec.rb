
if $__persistence__spec__development__
  require_relative '../../../../../lib/persistence-object-indexing.rb'
  require_relative '../../../../../../../port/indexing/lib/persistence-port-indexing.rb'
  require_relative '../../../../../../../adapters/mock/lib/persistence-adapter-mock.rb'
else
  require 'persistence-object-indexing'
  require 'persistence-port-indexing'
  require 'persistence-adapter-mock'
end

describe ::Persistence::Object::Indexing::Persist do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ##############
  #  cease!    #
  ##############

  it 'can persist with an index and explicit key' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Object::Indexing::Cease::Mock
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
      include ::Persistence::Object::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Indexing::Persist::ClassInstance      
      include ::Persistence::Object::Indexing::Cease::ObjectInstance
      extend ::Persistence::Object::Indexing::Cease::ClassInstance      
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
    instance_one = ::Persistence::Object::Indexing::Cease::Mock.new.persist!
    instance_one.persistence_id.should_not == nil
    instance_one.cease!
    ::Persistence::Object::Indexing::Cease::Mock.persist( instance_one.persistence_id ).should == nil
    instance_two = ::Persistence::Object::Indexing::Cease::Mock.new.persist!
    instance_two.persistence_id.should_not == nil
    ::Persistence::Object::Indexing::Cease::Mock.cease!( instance_two.persistence_id )
    ::Persistence::Object::Indexing::Cease::Mock.persist( instance_two.persistence_id ).should == nil    
    instance_three = ::Persistence::Object::Indexing::Cease::Mock.new.persist!( :explicit_index, :some_key )
    instance_three.persistence_id.should_not == nil
    instance_three.cease!
    index = ::Persistence::Object::Indexing::Cease::Mock.index( :explicit_index )
    index.get_object_id( :some_key ).should == nil
    ::Persistence::Object::Indexing::Cease::Mock.persist( :explicit_index, :some_key ).should == nil
    ::Persistence::Object::Indexing::Cease::Mock.persist( instance_three.persistence_id ).should == nil
    instance_four = ::Persistence::Object::Indexing::Cease::Mock.new.persist!( :explicit_index, :some_key )
    instance_four.persistence_id.should_not == nil
    ::Persistence::Object::Indexing::Cease::Mock.cease!( :explicit_index, :some_key )
    index = ::Persistence::Object::Indexing::Cease::Mock.index( :explicit_index )
    index.get_object_id( :some_key ).should == nil
    ::Persistence::Object::Indexing::Cease::Mock.persist( :explicit_index, :some_key ).should == nil
    ::Persistence::Object::Indexing::Cease::Mock.persist( instance_four.persistence_id ).should == nil
  end

end