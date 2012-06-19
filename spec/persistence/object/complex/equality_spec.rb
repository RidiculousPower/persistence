
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Equality do

  ########
  #  ==  # 
  ########

  it 'can compare objects' do
  
    class ::Persistence::Object::Complex::Equality::Mock
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
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :some_var, :some_other_var
    end

    # if we have the same ruby instance
    instance = ::Persistence::Object::Complex::Equality::Mock.new
    instance.persistence_id = 0
    ( instance == instance ).should == true
    
    # or if we have an id for both objects and the ids are not the same
    other_instance = ::Persistence::Object::Complex::Equality::Mock.new
    other_instance.persistence_id = 0
    yet_other_instance = ::Persistence::Object::Complex::Equality::Mock.new
    yet_other_instance.persistence_id = 1
    ( instance == other_instance ).should == true
    ( instance == yet_other_instance ).should == false
    
    # or if the classes are not the same
    ( instance == Object.new ).should == false
    
    # otherwise if we have instance variables, compare
    instance.instance_eval do
      self.some_var = :some_value
      self.persistence_id = nil
    end
    yet_other_instance.instance_eval do
      self.some_var = :some_value
      self.persistence_id = nil
    end
    ( instance == yet_other_instance ).should == true
    yet_other_instance.instance_eval do
      self.some_other_var = :some_other_value
    end
    ( instance == yet_other_instance ).should == false    
    
  end
  
end
