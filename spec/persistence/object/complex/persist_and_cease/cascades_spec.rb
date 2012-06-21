
require_relative '../../../../../lib/persistence.rb'

require_relative '../../../adapter/mock_helpers.rb'

describe ::Persistence::Object::Complex::PersistAndCease::Cascades do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ###################################
  #  attr_delete_cascades           #
  #  attr_delete_does_not_cascade   #
  #  delete_cascades?               #
  #  attr_delete_cascades!          #
  #  attr_delete_does_not_cascade!  #
  ###################################

  it 'can set an attribute to be deleted if self is deleted' do
    class ::Persistence::Object::Complex::PersistAndCease::Mock
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
      include ::Persistence::Object::Complex::PersistAndCease::Cascades
      extend ::Persistence::Object::Complex::PersistAndCease::Cascades
      include ::Persistence::Object::Complex::PersistAndCease::Cascades::ObjectInstance
      extend ::Persistence::Object::Complex::PersistAndCease::Cascades::ClassInstance
      attr_non_atomic_accessor :some_attribute, :cascading_attribute, :non_cascading_attribute, :complex_attribute
      attr_delete_cascades :some_attribute
      delete_cascades?( :some_attribute ).should == true
      attr_delete_does_not_cascade :some_attribute
      delete_cascades?( :some_attribute ).should == false
      attr_delete_cascades!
      delete_cascades?( :some_attribute ).should == true
      attr_delete_does_not_cascade!
      delete_cascades?( :some_attribute ).should == false
      attr_delete_cascades :cascading_attribute
      attr_delete_does_not_cascade :non_cascading_attribute
      delete_cascades?( :cascading_attribute ).should == true
      delete_cascades?( :non_cascading_attribute ).should == false
    end
    ::Persistence::Object::Complex::PersistAndCease::Mock.new.instance_eval do
      delete_cascades?( :cascading_attribute ).should == true
      delete_cascades?( :non_cascading_attribute ).should == false
      object = ::Persistence::Adapter::Abstract::Mock::Object.new
      object.persistence_bucket = persistence_bucket
      persistence_bucket.put_object!( self )
      persistence_bucket.put_attribute!( self, :complex_attribute, object )
      # FIX - still have to figure out details of this
#      delete_cascades?( :complex_attribute ).should == true
    end
  end
  
end
