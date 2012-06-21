
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::PersistAndCease::ClassInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ############
  #  cease!  #
  ############

  it 'can delete an object by ID' do
    class ::Persistence::Object::Complex::PersistAndCease::ClassInstance::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Equality
      include ::Persistence::Object::Complex::Equality
      extend ::Persistence::Object::Complex::PersistAndCease::ClassInstance
      attr_non_atomic_accessor :some_value, :some_other_value
    end
    instance = ::Persistence::Object::Complex::PersistAndCease::ClassInstance::Mock.new
    instance.some_value = :value
    instance.some_other_value = :other_value
    instance.persist!
    copy = ::Persistence::Object::Complex::PersistAndCease::ClassInstance::Mock.persist( instance.persistence_id )
    copy.should == instance
    ::Persistence::Object::Complex::PersistAndCease::ClassInstance::Mock.cease!( instance.persistence_id )
    ::Persistence::Object::Complex::PersistAndCease::ClassInstance::Mock.persist( instance.persistence_id ).should == nil
  end

end
