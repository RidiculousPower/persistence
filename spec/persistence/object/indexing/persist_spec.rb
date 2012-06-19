
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

  ################
  #  persist!    #
  #  persisted?  #
  #  persist     #
  ################

  it 'can persist with an index and explicit key' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Object::Indexing::Persist::Mock
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
      include ::Persistence::Object::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Indexing::Persist::ClassInstance      
      explicit_index :explicit_index
      # mock - not relevant to explicit indexing
      def self.non_atomic_attribute_readers
        return [ ]
      end
      def persistence_hash_to_port
      end
    end
    ::Persistence::Object::Indexing::Persist::Mock.count.should == 0
    ::Persistence::Object::Indexing::Persist::Mock.count( :explicit_index ).should == 0
    instance_one = ::Persistence::Object::Indexing::Persist::Mock.new.persist!
    instance_one.persistence_id.should_not == nil
    ::Persistence::Object::Indexing::Persist::Mock.count.should == 1
    ::Persistence::Object::Indexing::Persist::Mock.count( :explicit_index ).should == 0
    instance_two = ::Persistence::Object::Indexing::Persist::Mock.new.persist!( :explicit_index, :some_key )
    instance_two.persistence_id.should_not == nil
    ::Persistence::Object::Indexing::Persist::Mock.count.should == 2
    ::Persistence::Object::Indexing::Persist::Mock.count( :explicit_index ).should == 1
    persisted_instance_two_a = ::Persistence::Object::Indexing::Persist::Mock.persist( instance_two.persistence_id )
    persisted_instance_two_a.should == instance_two
    persisted_instance_two_b = ::Persistence::Object::Indexing::Persist::Mock.persist( :explicit_index, :some_key )
    persisted_instance_two_b.should == instance_two
  end

end