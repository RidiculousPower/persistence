
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::PersistAndCease::ClassInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end
  
  ################
  #  persisted?  #
  #  persist     #
  #  count       #
  ################
  
  it 'can persist an object and test whether it has been persisted' do
    module ::Persistence::Object::PersistAndCease::ClassInstance::PersistMock

      class ClassInstanceMock

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

      instance = ClassInstanceMock.new

      ClassInstanceMock.count.should == 0

      instance.persistence_port.put_object!( instance )
      instance.persistence_id.nil?.should == false
      ClassInstanceMock.persisted?( 0 ).should == true
      ClassInstanceMock.persist( 0 ).should == instance
      ClassInstanceMock.count.should == 1

    end
  end

  ############
  #  cease!  #
  ############
  
  it 'can persist an object and test whether it has been persisted' do
    module ::Persistence::Object::PersistAndCease::ClassInstance::CeaseMock
      
      class ClassInstanceMock

        extend ::Persistence::Port::ClassInstance
        include ::Persistence::Port::ObjectInstance
        include ::Persistence::Object::PersistenceID
        include ::Persistence::Object::Equality
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

      instance = ClassInstanceMock.new
      instance.persistence_port.put_object!( instance )
      instance.persistence_id.nil?.should == false
      ClassInstanceMock.cease!( 0 )
      ( instance.persistence_port.get_bucket_name_for_object_id( 0 ) ? true : false ).should == false
    
    end
  end
    
end
