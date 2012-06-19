
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Port::Bucket do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ##################
  #  get_attribute  #
  ##################
  
  it 'can serve as an adapter to a persistence bucket instance in an adapter instance' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Object::Complex::Port::Bucket
    end
    class ::Persistence::Object::Complex::Port::Bucket::Mock
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      attr_non_atomic_accessor :simple_var, :complex_var
    end
    sub_object = ::Persistence::Object::Complex::Port::Bucket::Mock.new.instance_eval do
      self.simple_var = :value
      self
    end
    object = ::Persistence::Object::Complex::Port::Bucket::Mock.new.instance_eval do
      self.simple_var = :some_value
      self.complex_var = sub_object
      self
    end
    bucket_instance = object.persistence_port.persistence_bucket( :some_bucket )
    bucket_instance.put_object!( object )
    object.persistence_id.should_not == nil
    bucket_instance.get_attribute( object, :simple_var ).should == :some_value
    bucket_instance.get_attribute( object, :complex_var ).persistence_hash_to_port.should == sub_object.persistence_hash_to_port
    bucket_instance.delete_attribute!( object, :complex_var )
    bucket_instance.get_attribute( object, :complex_var ).should == nil
    bucket_instance.put_attribute!( object, :complex_var, sub_object )
    bucket_instance.get_attribute( object, :complex_var ).persistence_hash_to_port.should == sub_object.persistence_hash_to_port
  end

end
