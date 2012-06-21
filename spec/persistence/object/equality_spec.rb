
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Object::Equality do

  ########
  #  ==  # 
  ########

  it 'can compare objects' do
  
    class ::Persistence::Object::Equality::Mock
      include ::Persistence::Object::PersistenceID
      include ::Persistence::Object::Equality
      def persistence_hash_to_port
        return { }
      end
      def self.non_atomic_attribute_readers
        return [ ]
      end
      def non_atomic_attribute_readers
        return [ ]
      end
      def atomic_attribute_readers
        return [ ]
      end
    end

    # if we have the same ruby instance
    instance = ::Persistence::Object::Equality::Mock.new
    instance.persistence_id = 0
    ( instance == instance ).should == true
    
    # or if we have an id for both objects and the ids are not the same
    other_instance = ::Persistence::Object::Equality::Mock.new
    other_instance.persistence_id = 0
    yet_other_instance = ::Persistence::Object::Equality::Mock.new
    yet_other_instance.persistence_id = 1
    ( instance == other_instance ).should == true
    ( instance == yet_other_instance ).should == false
    
    # or if the classes are not the same
    ( instance == Object.new ).should == false
    
  end
  
end
