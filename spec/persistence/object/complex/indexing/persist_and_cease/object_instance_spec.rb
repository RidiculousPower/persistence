
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Indexing::PersistAndCease::ObjectInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ######################
  #  persist!          #
  #  index_attributes  #
  #  persist           #
  ######################

  it 'indexes attributes during persist' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Object::Complex::Indexing::PersistAndCease::ObjectInstance::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::PersistAndCease::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_non_atomic_accessor :attribute_index
      attr_index  :attribute_index
    end
    instance = ::Persistence::Object::Complex::Indexing::PersistAndCease::ObjectInstance::Mock.new
    instance.attribute_index = :some_value
    # should call index_attributes
    instance.persist!
    instance_copy = ::Persistence::Object::Complex::Indexing::PersistAndCease::ObjectInstance::Mock.persist( :attribute_index, :some_value )
    instance_copy.should == instance
    instance_copy_two = ::Persistence::Object::Complex::Indexing::PersistAndCease::ObjectInstance::Mock.new
    instance_copy_two.persist( :attribute_index, :some_value )
    instance_copy_two.should == instance
  end
  
end
