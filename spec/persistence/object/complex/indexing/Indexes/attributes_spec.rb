
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Indexing::Indexes::Attributes do
  
  ################################
  #  attr_index                  #
  #  attr_index_with_duplicates  #
  ################################

  it 'can create an index on a attribute' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    
    class ::Persistence::Object::Complex::Indexing::Indexes::Attributes::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Indexing::Indexes
      extend ::Persistence::Object::Indexing::Indexes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes

      # mock - not relevant to explicit indexing
      def persistence_hash_to_port
      end
      
      attr_index                 :attribute_index
      attr_index_with_duplicates :attribute_index_with_duplicates
      
      has_attribute_index?( :attribute_index ).should == true
      has_index?( :attribute_index ).should == true
      has_attribute_index?( :attribute_index_with_duplicates ).should == true
      has_index?( :attribute_index_with_duplicates ).should == true
      index( :attribute_index ).is_a?( ::Persistence::Port::Indexing::Bucket::Index ).should == true
      index( :attribute_index_with_duplicates ).is_a?( ::Persistence::Port::Indexing::Bucket::Index ).should == true

    end
  end

end

