
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::PersistAndCease::ObjectInstance do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end
  
  ################
  #  persist!    #
  #  persisted?  #
  ################
  
  it 'can persist an object and test whether it has been persisted' do
    module ::Persistence::Object::PersistAndCease::ObjectInstance::PersistMock
      
      class ObjectInstanceMock

        extend ::Persistence::Port::ClassInstance
        include ::Persistence::Port::ObjectInstance
        include ::Persistence::Object::PersistenceID
        include ::Persistence::Object::Equality
        include ::Persistence::Object::PersistAndCease::ObjectInstance
        extend ::Persistence::Object::PersistAndCease::ClassInstance

        self.instance_persistence_port = ::Persistence.port( :mock )

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

      instance = ObjectInstanceMock.new
      instance.persistence_id.should == nil
      instance.persist!
      instance.persistence_id.nil?.should == false
      instance.persisted?.should == true
      
    end
  end

  ############
  #  cease!  #
  ############
  
  it 'can persist an object and test whether it has been persisted' do
    module ::Persistence::Object::PersistAndCease::ObjectInstance::CeaseMock

      class ObjectInstanceMock

        extend ::Persistence::Port::ClassInstance
        include ::Persistence::Port::ObjectInstance
        include ::Persistence::Object::PersistenceID
        include ::Persistence::Object::Equality
        include ::Persistence::Object::PersistAndCease::ObjectInstance

        self.instance_persistence_port = ::Persistence.port( :mock )

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

      instance = ObjectInstanceMock.new
      instance.persistence_port.put_object!( instance )
      global_id = instance.persistence_id
      instance.persistence_id.nil?.should == false
      instance.cease!
      instance.persistence_id.should == nil
      ( instance.persistence_port.get_bucket_name_for_object_id( global_id ) ? true : false ).should == false
      
    end
  end
    
end
