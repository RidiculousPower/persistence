
require_relative '../../lib/persistence.rb'

describe ::Persistence::Object do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end
  
  ################
  #  persist!    #
  #  persisted?  #
  #  persist     #
  #  count       #
  ################
  
  it 'can persist an object and test whether it has been persisted' do
    module ::Persistence::Object::PersistMock

      class ClassInstanceMock

        include ::Persistence::Object::Complex

        self.instance_persistence_port = ::Persistence.port( :mock )

      end

      instance = ClassInstanceMock.new

      ClassInstanceMock.count.should == 0

      instance.persistence_port.put_object!( instance )
      instance.persistence_id.nil?.should == false
      ClassInstanceMock.persisted?( 0 ).should == true
      ClassInstanceMock.persist( 0 ).should == instance
      ClassInstanceMock.count.should == 1

      class ObjectInstanceMock

        include ::Persistence::Object::Complex

        self.instance_persistence_port = ::Persistence.port( :mock )

      end

      instance = ObjectInstanceMock.new
      instance.persistence_id.should == nil
      instance.persist!
      instance.persistence_id.nil?.should == false
      instance.persisted?.should == true

      class ObjectIndexMock
      
        include ::Persistence::Object::Complex

        explicit_index :explicit_index
        
      end

      encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default )

      ObjectIndexMock.count.should == 0
      ObjectIndexMock.count( :explicit_index ).should == 0
      instance_one = ObjectIndexMock.new.persist!
      instance_one.persistence_id.should_not == nil
      ObjectIndexMock.count.should == 1
      ObjectIndexMock.count( :explicit_index ).should == 0
      
      instance_two = ObjectIndexMock.new.persist!( :explicit_index, :some_key )
      instance_two.persistence_id.should_not == nil
      ObjectIndexMock.count.should == 2
      ObjectIndexMock.count( :explicit_index ).should == 1
      persisted_instance_two_a = ObjectIndexMock.persist( instance_two.persistence_id )
      persisted_instance_two_a.should == instance_two
      persisted_instance_two_b = ObjectIndexMock.persist( :explicit_index, :some_key )
      persisted_instance_two_b.should == instance_two

    end
  end

  ############
  #  cease!  #
  ############
  
  it 'can persist an object and test whether it has been persisted' do
    module ::Persistence::Object::CeaseMock
      
      class ClassInstanceMock

        include ::Persistence::Object::Complex

        self.instance_persistence_port = ::Persistence.port( :mock )

      end

      instance = ClassInstanceMock.new
      instance.persistence_port.put_object!( instance )
      instance.persistence_id.nil?.should == false
      ClassInstanceMock.cease!( 0 )
      ( instance.persistence_port.get_bucket_name_for_object_id( 0 ) ? true : false ).should == false
    
      class ObjectInstanceMock

        include ::Persistence::Object::Complex

        self.instance_persistence_port = ::Persistence.port( :mock )

      end

      instance = ObjectInstanceMock.new
      instance.persistence_port.put_object!( instance )
      global_id = instance.persistence_id
      instance.persistence_id.nil?.should == false
      instance.cease!
      instance.persistence_id.should == nil
      ( instance.persistence_port.get_bucket_name_for_object_id( global_id ) ? true : false ).should == false
    
      class ObjectIndexMock

        include ::Persistence::Object::Complex
        
        explicit_index :explicit_index
        
        # mock - not relevant to explicit indexing
        def self.non_atomic_attribute_readers
          return [ ]
        end
        
        def persistence_hash_to_port
        end
        
      end
      instance_one = ObjectIndexMock.new.persist!
      instance_one.persistence_id.should_not == nil
      instance_one.cease!
      ObjectIndexMock.persist( instance_one.persistence_id ).should == nil
      instance_two = ObjectIndexMock.new.persist!
      instance_two.persistence_id.should_not == nil
      ObjectIndexMock.cease!( instance_two.persistence_id )
      ObjectIndexMock.persist( instance_two.persistence_id ).should == nil    
      instance_three = ObjectIndexMock.new.persist!( :explicit_index, :some_key )
      instance_three.persistence_id.should_not == nil
      instance_three.cease!
      index = ObjectIndexMock.index( :explicit_index )
      index.get_object_id( :some_key ).should == nil
      ObjectIndexMock.persist( :explicit_index, :some_key ).should == nil
      ObjectIndexMock.persist( instance_three.persistence_id ).should == nil
      instance_four = ObjectIndexMock.new.persist!( :explicit_index, :some_key )
      instance_four.persistence_id.should_not == nil
      ObjectIndexMock.cease!( :explicit_index, :some_key )
      index = ObjectIndexMock.index( :explicit_index )
      index.get_object_id( :some_key ).should == nil
      ObjectIndexMock.persist( :explicit_index, :some_key ).should == nil
      ObjectIndexMock.persist( instance_four.persistence_id ).should == nil
    
    end
  end

  #####################
  #  persistence_id=  #
  #  persistence_id   #
  #####################
  
  it 'can set and get a persistence id that uniquely identifies the object instance' do
    module ::Persistence::Object::PersistenceIDMock

      class ObjectInstance
        include ::Persistence::Object::Complex
      end
      
      instance = ObjectInstance.new

      instance.persistence_id.should == nil
      instance.persistence_id = 1
      instance.persistence_id.should == 1
      
    end
  end


  ##################################
  #  instance_persistence_bucket   #
  #  instance_persistence_bucket=  #
  #  store_as                      #
  #  persists_in                   #
  ##################################

  it 'can set and return a persistence bucket to be used for instances' do
    class ::Persistence::Port::Bucket::ClassInstance::Mock
      include ::Persistence::Object
      method( :instance_persistence_bucket= ).should == method( :store_as )
      method( :instance_persistence_bucket= ).should == method( :persists_in )
      instance_persistence_bucket.name.to_s.should == ::Persistence::Port::Bucket::ClassInstance::Mock.to_s
      self.instance_persistence_bucket = 'some other bucket'
      instance_persistence_bucket.name.to_s.should == 'some other bucket'
    end
    ::Persistence::Port::Bucket::ClassInstance::Mock.instance_persistence_bucket = ::Persistence::Port::Bucket::ClassInstance::Mock.to_s
    ::Persistence::Port::Bucket::ClassInstance::Mock.instance_persistence_bucket.name.to_s.should == ::Persistence::Port::Bucket::ClassInstance::Mock.to_s
  end

  #########################
  #  persistence_bucket   #
  #  persistence_bucket=  #
  #########################

  it 'can set and return a persistence bucket to be used for instances' do
    class ::Persistence::Object::PersistenceBucketMock
      include ::Persistence::Object
      def self.instance_persistence_port
        @persistence_port ||= ::Persistence::Port.new( :mock_port, ::Persistence::Adapter::Mock.new )        
      end
      def persistence_port
        return self.class.instance_persistence_port
      end
      # mock function
      def self.instance_persistence_bucket
        return instance_persistence_port.persistence_bucket( to_s )
      end
    end
    object_instance = ::Persistence::Object::PersistenceBucketMock.new
    object_instance.persistence_bucket.name.to_s.should == ::Persistence::Object::PersistenceBucketMock.to_s
    object_instance.persistence_bucket = 'mock bucket'
    object_instance.persistence_bucket.name.to_s.should == 'mock bucket'
  end

  ################################
  #  instance_persistence_port=  #
  #  instance_persistence_port   #
  #  store_using                 #
  #  persists_using              #
  ################################

  it 'can set and return a persistence port to be used for instances' do
    class ::Persistence::Object::InstancePersistencePortMock
      include ::Persistence::Object
      method( :instance_persistence_port= ).should == method( :store_using )
      method( :instance_persistence_port= ).should == method( :persists_using )
      mock_port = ::Persistence.port( :mock )
      self.instance_persistence_port = mock_port
      instance_persistence_port.should == mock_port
      self.instance_persistence_port = nil
      ::Persistence.disable_port( :mock )
      instance_persistence_port.should == nil
      self.instance_persistence_port = nil
      instance_persistence_port.should == nil
      self.instance_persistence_port = :mock
      instance_persistence_port.should == mock_port
      ::Persistence.enable_port( :mock )
    end
  end

  #######################
  #  persistence_port=  #
  #  persistence_port   #
  #######################

  it "it can set and return a persistence port, either from an instance, a name, or another instance's persistence port, or from its class's instance persistence port by default" do
    class ::Persistence::Object::PersistencePortMock
      include ::Persistence::Object
    end
    rspec = self
    ::Persistence::Object::PersistencePortMock.new.instance_eval do
      persistence_port.name.should == :mock
      ::Proc.new { self.persistence_port = :another_mock }.should rspec.raise_error
      ::Persistence.enable_port( :another_mock, ::Persistence::Adapter::Mock.new )
      self.persistence_port = :another_mock
      persistence_port.name.should == :another_mock
      ::Persistence.disable_port( :another_mock )
    end
  end
      
end
