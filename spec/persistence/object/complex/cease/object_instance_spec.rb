
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Cease::ObjectInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ############
  #  cease!  #
  ############

  it 'can delete an object' do
    class ::Persistence::Object::Complex::Cease::ObjectInstance::Mock
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
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      extend ::Persistence::Object::Complex::Cease::ClassInstance
      attr_non_atomic_accessor :some_value, :some_other_value
    end
    instance = ::Persistence::Object::Complex::Cease::ObjectInstance::Mock.new
    instance.some_value = :value
    instance.some_other_value = :other_value
    instance.persist!
    copy = ::Persistence::Object::Complex::Cease::ObjectInstance::Mock.persist( instance.persistence_id )
    copy.should == instance
    instance.cease!
    ::Persistence::Object::Complex::Cease::ObjectInstance::Mock.persist( instance.persistence_id ).should == nil
  end

end