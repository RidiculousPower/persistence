
if $__persistence__spec__development__
  require_relative '../../../../../../lib/persistence-object-indexing.rb'
  require_relative '../../../../../../../../port/indexing/lib/persistence-port-indexing.rb'
  require_relative '../../../../../../../../adapters/mock/lib/persistence-adapter-mock.rb'
else
  require 'persistence-object-indexing'
  require 'persistence-port-indexing'
  require 'persistence-adapter-mock'
end

describe ::Persistence::Object::Indexing::Indexes::Block do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  #################################
  #  block_index                  #
  #  block_index_with_duplicates  #
  #  has_block_index?             #
  #  index                        #
  #################################
  
  it 'can declare an arbitrary key/value index on an object' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Object::Indexing::Indexes::Block::Mock

      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Indexing::Indexes
      extend ::Persistence::Object::Indexing::Indexes
      include ::Persistence::Object::Indexing::Indexes::Block::ObjectInstance
      extend ::Persistence::Object::Indexing::Indexes::Block::ClassInstance

      # mock - not relevant to explicit indexing
      def persistence_hash_to_port
      end
      
      block_index                 :block_index do |key, value|
        return value
      end
      block_index_with_duplicates :block_index_with_duplicates do |key, value|
        return value
      end
      
      has_block_index?( :block_index ).should == true
      has_index?( :block_index ).should == true
      has_block_index?( :block_index_with_duplicates ).should == true
      has_index?( :block_index_with_duplicates ).should == true
      index( :block_index ).is_a?( ::Persistence::Port::Indexing::Bucket::Index ).should == true
      index( :block_index_with_duplicates ).is_a?( ::Persistence::Port::Indexing::Bucket::Index ).should == true
      
    end    
  end
  
end
