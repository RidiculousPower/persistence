
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Indexing::Indexes::Explicit do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ####################################
  #  explicit_index                  #
  #  explicit_index_with_duplicates  #
  #  has_explicit_index?             #
  #  index                           #
  ####################################
  
  it 'can declare an arbitrary key/value index on an object' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Object::Indexing::Indexes::Explicit::Mock

      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Indexing::Indexes
      extend ::Persistence::Object::Indexing::Indexes
      include ::Persistence::Object::Indexing::Indexes::Explicit::ObjectInstance
      extend ::Persistence::Object::Indexing::Indexes::Explicit::ClassInstance

      # mock - not relevant to explicit indexing
      def persistence_hash_to_port
      end
      
      explicit_index                 :explicit_index
      explicit_index_with_duplicates :explicit_index_with_duplicates
      
      has_explicit_index?( :explicit_index ).should == true
      has_index?( :explicit_index ).should == true
      has_explicit_index?( :explicit_index_with_duplicates ).should == true
      has_index?( :explicit_index_with_duplicates ).should == true
      index( :explicit_index ).is_a?( ::Persistence::Port::Indexing::Bucket::Index ).should == true
      index( :explicit_index_with_duplicates ).is_a?( ::Persistence::Port::Indexing::Bucket::Index ).should == true
      
    end    
  end
  
end
