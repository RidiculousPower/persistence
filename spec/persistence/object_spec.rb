
require_relative '../../lib/persistence.rb'

describe ::Persistence::Object do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    
		class ClassInstanceMock
		
		  include ::Persistence::Object::Complex
		
		  self.instance_persistence_port = ::Persistence.port( :mock )
		
		end
		
	  class ObjectInstanceMock

      include ::Persistence::Object::Complex

      self.instance_persistence_port = ::Persistence.port( :mock )

    end
    
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end
  
	let(:class_instance) { ClassInstanceMock.new}
	let(:object_instance) { ObjectInstanceMock.new}
  
  ################
  #  persist!    #
  #  persisted?  #
  #  persist     #
  #  count       #
  ################
  #can persist an object and test whether it has been persisted
	context "#new" do 
		it "instance should not have a persistence id" do 
      class_instance.persistence_id.should == nil
    end
  end
  
	context "#put_object!" do 	
    
    it "should persist instance and return its persistence id" do 
    #this also is testing nested we look recursive persisting.
      class_instance.persistence_port.put_object!( class_instance ).nil?.should == false
    end
    
  end
	
	context "#after put_object!" do
		before(:each) { @persistence_id = class_instance.persistence_port.put_object!( class_instance ) }
		
		
		it "persistence_id should not be nil" do 
			class_instance.persistence_id.nil?.should == false
		end	           
    
		context "#persisted?" do 
	    it "should return true if an instance has been persisted" do 
	      ClassInstanceMock.persisted?( @persistence_id ).should == true
	    end 
	    it "should return false if an instance has not been persisted" do 
	      ClassInstanceMock.persisted?( ClassInstanceMock.count+1 ).should == false
	    end 
	  end
	  context "#persist" do     
	    it "should return the instance linked to the persistence id" do 
	      ClassInstanceMock.persist( @persistence_id ).should == class_instance
	    end
	    
    end
  end

  context "#persist!" do 

	  it "should persist instance" do 
  		count = ClassInstanceMock.count  
    	ClassInstanceMock.new.persist!
      ClassInstanceMock.count.should == count + 1
    end    

  end

	###########
	#  Count  #
	###########  
  context "#count" do 
  	it "count should increment by one after an instance is persisted" do   
			count = ClassInstanceMock.count
			class_instance.persistence_port.put_object!( class_instance )
			ClassInstanceMock.count.should == count + 1
		end
  end
  


	
	############
	#  cease!  #
	############
	#'can persist an object and test whether it has been persisted'
	context "#cease!" do
	  
	  context "- on a class with object id as a parameter -" do 
	    it "should remove object from records" do 
	      class_instance.persistence_port.put_object!( class_instance )
	      global_id = class_instance.persistence_id
	      ClassInstanceMock.cease!( class_instance.persistence_id )
	      ( class_instance.persistence_port.get_bucket_name_for_object_id( global_id ) ? true : false ).should == false
	
	    end
	  end
	  
	  context "- on a object instance -" do
	    it "should remove object from records" do 
	
	      object_instance.persistence_port.put_object!( object_instance )
	      global_id = object_instance.persistence_id
	      object_instance.cease!
	      ( object_instance.persistence_port.get_bucket_name_for_object_id( global_id ) ? true : false ).should == false
	
	    end
	  end
  end

  #####################
  #  persistence_id=  #
  #  persistence_id   #
  #####################
  #can set and get a persistence id that uniquely identifies the object instance
  context "#persistence_id" do 
  	it 'should be able to set and get global_id' do
      class_instance.persistence_id = 1
      class_instance.persistence_id.should == 1
      
    end
  end


  ##################################
  #  instance_persistence_bucket   #
  #  instance_persistence_bucket=  #
  #  store_as                      #
  #  persists_in                   #
  ##################################
  #can set and return a persistence bucket to be used for instances
  context "#instance_persistence_bucket" do 
  
  	before :each do 
	    class ::Persistence::Port::Bucket::ClassInstance::Mock
	      include ::Persistence::Object
	    end  		
  	end
  	
  	after :each do 
    	::Persistence::Port::Bucket::ClassInstance.send(:remove_const, :Mock)
    end

  	it "should equal store_as method" do 
  		class ::Persistence::Port::Bucket::ClassInstance::Mock
  			method( :instance_persistence_bucket= ).should == method( :store_as )
  		end
  	end  	
  	
  	it "should equal persists_in method" do 
  		class ::Persistence::Port::Bucket::ClassInstance::Mock
	  		method( :instance_persistence_bucket= ).should == method( :persists_in )
  		end  	
  	end  	
  	
  	context "- from within its class definition -" do 
	  	it "name should equal it's class name" do 
	  		class ::Persistence::Port::Bucket::ClassInstance::Mock
	  			instance_persistence_bucket.name.to_s.should == ::Persistence::Port::Bucket::ClassInstance::Mock.to_s
	  		end  	
	  	end
	  	  	
	  	it "should allow name override" do 
	  		class ::Persistence::Port::Bucket::ClassInstance::Mock
		      self.instance_persistence_bucket = 'some other bucket'
		      instance_persistence_bucket.name.to_s.should == 'some other bucket'
		      
		      #MUST CLEAN UP! This test overrides class definition for all others tests.
		      self.instance_persistence_bucket = self.name
	  		end  	
	  	end
	  end
	  
		it "should allow name override" do
			mock = ::Persistence::Port::Bucket::ClassInstance::Mock
			
			mock.instance_persistence_bucket = 'some other bucket'
      mock.instance_persistence_bucket.name.to_s.should == 'some other bucket'
      		      
      #MUST CLEAN UP! This test overrides class definition for all others tests.
      mock.instance_persistence_bucket = mock.to_s
	  end
	  	  	
	  it "name should equal it's class name" do
	    ::Persistence::Port::Bucket::ClassInstance::Mock.instance_persistence_bucket.name.to_s.should == ::Persistence::Port::Bucket::ClassInstance::Mock.to_s
	  end
	  
  end
  #########################
  #  persistence_bucket   #
  #  persistence_bucket=  #
  #########################
  #can set and return a persistence bucket to be used for instances
  context "#persistence_bucket#name" do
		before :each do 
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
	    
	    @object_instance = ::Persistence::Object::PersistenceBucketMock.new
		end
		
		after :each do 
	  	::Persistence::Object.send(:remove_const, :PersistenceBucketMock)
	  end  	
		  		
	  it "should equal it's class name" do   
	    @object_instance.persistence_bucket.name.to_s.should == ::Persistence::Object::PersistenceBucketMock.to_s
	  end
	    
	  it "should allow override" do 
	    @object_instance.persistence_bucket = 'mock bucket'
	    @object_instance.persistence_bucket.name.to_s.should == 'mock bucket'
	    
	    #MUST CLEAN UP! This test overrides class definition for all others tests
	    @object_instance.persistence_bucket = @object_instance.class.to_s
	  end
  end
  
  ################################
  #  instance_persistence_port=  #
  #  instance_persistence_port   #
  #  store_using                 #
  #  persists_using              #
  ################################
  #can set and return a persistence port to be used for instances
  context '#instance_persistence_port' do
    
    before :each do 
	    class ::Persistence::Object::InstancePersistencePortMock
	      include ::Persistence::Object
	    end
    end
    
    after :each do 
    	::Persistence::Object.send(:remove_const, :InstancePersistencePortMock)
    end
    
    it "should equal store_using method" do 
    	class ::Persistence::Object::InstancePersistencePortMock
	      method( :instance_persistence_port= ).should == method( :store_using )
		  end
	  end

    it "should equal persists_in method" do 
    	class ::Persistence::Object::InstancePersistencePortMock
	      method( :instance_persistence_port= ).should == method( :persists_using )
		  end
	  end
	  
    it "should set and get a valid port" do 	
    	class ::Persistence::Object::InstancePersistencePortMock      
	      mock_port = ::Persistence.port( :mock )
	      self.instance_persistence_port = mock_port
	      instance_persistence_port.should == mock_port
		  end
	  end

    it "should throw exception if assigned non-existent port" do 
    	::Proc.new { ::Persistence::Object::InstancePersistencePortMock.instance_persistence_port = :another_mock }.should self.raise_error
    end
    
  end

  #######################
  #  persistence_port=  #
  #  persistence_port   #
  #######################
  #it can set and return a persistence port, either from an instance, a name, or another instance's persistence port, or from its class's instance persistence port by default
  context "#persistence_port" do
  	before :each do 
	    class ::Persistence::Object::PersistencePortMock
	      include ::Persistence::Object
	    end
	    @port_mock = ::Persistence::Object::PersistencePortMock.new
    end
    
    it "should throw exception if assigned non-existent port" do	  	
	      ::Proc.new { @port_mock.persistence_port = :another_mock }.should self.raise_error
    end
    
    it "should allow port to be reassigned" do	      
	      ::Persistence.enable_port( :another_mock, ::Persistence::Adapter::Mock.new )
	      @port_mock.persistence_port = :another_mock
	      @port_mock.persistence_port.name.should == :another_mock
	      
	      #Clean up! One time port should be closed
	      ::Persistence.disable_port( :another_mock )
    end
  end
      
  context "#index" do
  
  	before :each do 
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
    
	    @instance_one = ObjectIndexMock.new.persist! 
    	@instance_two = ObjectIndexMock.new.persist!( :explicit_index, :some_key )
    
	    @object_count = ObjectIndexMock.count 
    	@index_count	= ObjectIndexMock.count( :explicit_index )
    end
    
    #resolves duplicates in unique index issue but most index tests will fail should cease break
    after :each  do 
	  	ObjectIndexMock.each {|object| object.cease!}
    end
    
    it "should persist" do   
    	ObjectIndexMock.new.persist!
      ObjectIndexMock.count.should == @object_count + 1
    end
  
  	it "index count should not increment after an object is persisted, unless a new index is added" do  
  		ObjectIndexMock.new.persist! 
    	ObjectIndexMock.count( :explicit_index ).should == @index_count
    end
  
    context "#keys" do 
      
      it "should persist without an index key" do   
      	@instance_one.persistence_id.should_not == nil
      end
	    
	    it "should persist instance with keys" do   
	    	ObjectIndexMock.new.persist!
	    	ObjectIndexMock.new.persist!( :explicit_index, :key_one )
	      ObjectIndexMock.count.should == @object_count + 2
	    end
	    
	    it "with a key added count should not be 0" do   
		    ObjectIndexMock.count( :explicit_index ).should_not == 0
		  end
	    
	    it "explicit_index without keys should be retained with object when object is persisted" do   
	      persisted_instance = ObjectIndexMock.persist( @instance_one.persistence_id )
	      persisted_instance.should == @instance_one
	    end
	    
	    it "explicit_index and keys should be retained with object when object is persisted" do   
	      persisted_instance = ObjectIndexMock.persist( @instance_two.persistence_id )
	      persisted_instance.should == @instance_two
      end
    end
    
    context "#cease!" do 
      
      context "- on instance object -" do
      	before :each do 
      		@instance_two.cease!
      	end
		    
		    it "should remove index from records" do        
		      index = ObjectIndexMock.index( :explicit_index )
		      index.get_object_id( :some_key ).should == nil
		      
		    end
		    
		    it "should remove object with index from records, according to persist(index, key)" do 
		    	ObjectIndexMock.persist( :explicit_index, :some_key ).should == nil
		    end
		    
		    it "should remove object with index from records, according to persist(persistence_id)" do   
		      ObjectIndexMock.persist( @instance_two.persistence_id ).should == nil 
			  end
			  
	    end  
	    
      context "- with index and key as parameters -" do
      	before :each do 
      		ObjectIndexMock.cease!( :explicit_index, :some_key )
      	end
		    
		    it "should remove index from records" do        
		      index = ObjectIndexMock.index( :explicit_index )
		      index.get_object_id( :some_key ).should == nil
		      
		    end
		    
		    it "should remove object from index" do 
		    	ObjectIndexMock.persist( :explicit_index, :some_key ).should == nil
		    end
		    
		    it "should remove object with index from records" do   
		      ObjectIndexMock.persist( @instance_two.persistence_id ).should == nil
			  end
			  
	    end
    end
  end
end
