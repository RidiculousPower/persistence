
require_relative '../../../../../lib/persistence.rb'

describe Class do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a class object to a persistence port and get it back" do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class Class
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Flat::Indexing::ClassInstance
      include ::Persistence::Object::Flat::Indexing::ObjectInstance
      explicit_index :explicit_index
    end
    class_object  = Object
    storage_key   = String
    class_object.persist!( :explicit_index, storage_key )
    Class.persist( :explicit_index, storage_key ).should == class_object
    Class.cease!( :explicit_index, storage_key )
    Class.persist( :explicit_index, storage_key ).should == nil
    ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default ).remove_configuration( Class, :instance_persistence_port )
    ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default ).remove_configuration( Class, :instance_persistence_bucket )
  end
  
end
