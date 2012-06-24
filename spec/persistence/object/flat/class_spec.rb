
require_relative '../../../../lib/persistence.rb'

describe Class do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a class object to a persistence port and get it back" do
    class Class
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end

    class_object = Object
    class_object.persist!
    Class.persist( class_object.persistence_id ).should == class_object
    class_object.cease!
    Class.persist( class_object.persistence_id ).should == nil
    ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default ).remove_configuration( Class, :instance_persistence_port )
    ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default ).remove_configuration( Class, :instance_persistence_bucket )

    storage_key   = String
    class_object.persist!( :explicit_index, storage_key )
    Class.persist( :explicit_index, storage_key ).should == class_object
    Class.cease!( :explicit_index, storage_key )
    Class.persist( :explicit_index, storage_key ).should == nil
    ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default ).remove_configuration( Class, :instance_persistence_port )
    ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default ).remove_configuration( Class, :instance_persistence_bucket )

  end
  
end
