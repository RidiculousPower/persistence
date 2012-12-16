
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Adapter do

	#define mock class once and keep it loaded for all test.
	before :all do 
		class ::Persistence::Adapter::MockObject
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::CascadingConfiguration::Setting
      attr_non_atomic_accessor :non_atomic_attribute
    end
	end

	#let, more efficient then before :each as it is recreated only when refrence.
  let(:adapter) {$__persistence__spec__adapter__ || ::Persistence::Adapter::Mock.new( '/tmp/persistence_home' )}
  let(:bucket) {adapter.persistence_bucket( @object.persistence_bucket.name )}

	#create a new connection for every test. This __should__ keep test from passing as a result of prior test.
  before :each do

    ::Persistence.enable_port( :mock, adapter )

    @object = ::Persistence::Adapter::MockObject.new
    
    @object.non_atomic_attribute = :some_value

  end
  
  #always clean up after every test.
  after :each do
    ::Persistence.disable_port( :mock )
  end
  

  ################
  #  initialize  #
  #  enable      #
  #  disable     #
  #  enabled?    #
  ################
  
  context "#persistence-port" do 
    
  	it 'will enable' do 
  		@object.persistence_port.enabled?.should == true
  	end
  	
  	it 'will disable' do
  		@object.persistence_port.instance_eval do
  			disable
  			enabled?.should == false
  		end
  	end
  
	  it 'will re-enable' do
	  	@object.persistence_port.instance_eval do 
	  		disable
	  		enable
	  		enabled?.should == true
	  	end
	  end
  
  end

  #################
  #  put_object!  #
  #################
  
  context "#put_object!" do 

	  it "will put an object with simple properties and sub objects" do  
	  
	    # put_object!
	    bucket.put_object!( @object )
	    @object.persistence_id.should_not == nil
	    
	  end
	end
	
	context "after put_object!" do
	
		before :each do 
			bucket.put_object!( @object )
		end
	
	  it "will get an object with simple properties and sub objects" do
	  
	    # put_object!
	    retrieved_object_hash = bucket.get_object( @object.persistence_id )
	    retrieved_object_hash.should == {:non_atomic_attribute=>:some_value}
	    
	  end
  end

  context "with persisted object" do 
	  before :each do 
	  	bucket.put_object!( @object )
	  end
	
	  ###########
	  #  count  #
	  ###########
	  
	  it 'will report how many objects are persisted' do
	
	    bucket.count.should == 1
	    
	  end
	
	  ####################
	  #  delete_object!  #
	  ####################
	
	  context "#delete_object!" do 
	
		  it "will delete an object" do
		  
			  # delete_object!
		    bucket.delete_object!( @object.persistence_id )
		    bucket.get_object( @object.persistence_id ).should == nil
	
	    end
	  end
	  
	  
	  context "that was deleted" do 
	  
	  	before :each do 
	  		bucket.delete_object!( @object.persistence_id )
	  	end
	
			it "put_object! will put the deleted object" do
			
			  @object.persistence_id = nil
			  bucket.put_object!( @object )
			  retrieved_object_hash = bucket.get_object( @object.persistence_id )
			  retrieved_object_hash.should == {:non_atomic_attribute=>:some_value}
			end
	  end
	
	  ###################################
	  #  get_bucket_name_for_object_id  #
	  ###################################
	
	  it "will get a bucket for a given object ID" do
	
	    # get_bucket_name_for_object_id
	    adapter.get_bucket_name_for_object_id( @object.persistence_id ).should == @object.persistence_bucket.name
	  
	  end
	
	  #############################
	  #  get_class_for_object_id  #
	  #############################
	
	  it "will get a class for a given object ID" do
	
	    # get_class_for_object_id
	    adapter.get_class_for_object_id( @object.persistence_id ).should == @object.class
	  
	  end

	  context "and non_atomic_attribute" do 
	  	
	  	let(:primary_key) { bucket.primary_key_for_attribute_name( @object, :non_atomic_attribute )}


		  ####################
		  #  put_attribute!  #
		  ####################
		
		  it "will put a attribute for an object" do
		  
		    # put_attribute!
		    bucket.put_attribute!( @object, primary_key, 'attribute!' )
		    #this is tricky, we are not sure it worked even if it passed. All we will do is check for exceptions.
		  end
		
		  it "will not put attribute if attribute name is invalid" do 
		  	bucket.put_attribute!( @object, primary_key, :garbage )
		  	bucket.get_attribute( @object, primary_key ).should == nil
		  end
		
		  ###################
		  #  get_attribute  #
		  ###################
		
		  it "will get a attribute for an object" do
		
		    # get_attribute
		    
		    bucket.put_attribute!( @object, primary_key, 'attribute!' ) #dependant on put_attribute!
		    bucket.get_attribute( @object, primary_key ).should == 'attribute!' #dependant on get_attribute!
		  
		  end
		
		  #######################
		  #  delete_attribute!  #
		  #######################
		
		  it "will delete a attribute on an object" do
		
		    # delete_attribute!
		    primary_key = bucket.primary_key_for_attribute_name( @object, :non_atomic_attribute )
		    bucket.put_attribute!( @object, primary_key, 'attribute!' ) #dependant on put_attribute!
		    bucket.delete_attribute!( @object, primary_key )
		    bucket.get_attribute( @object, primary_key ).should == nil #dependant on get_attribute!
		  
		  end
		  
		  #######################
		  #  overwrite_attribute!  #
		  #######################
		  
		  it "will overwrite a given attribute" do 

		  	bucket.put_attribute!( @object, primary_key, 'some_attribute' )
		    
		    bucket.put_attribute!( @object, primary_key, 'some_other_attribute' )
		    
		    bucket.get_attribute( @object, primary_key ).should == 'some_other_attribute'
		  	
		  end
	  end
	end
	  
  ##################
  #  create_index  #
  #  has_index?    #
  #  index         #
  ##################

  context '#index' do
   
  	it "with key should be created on a class" do 
    	bucket.create_index( :key, false )
    	bucket.has_index?( :key ).should == true
    end
   
		it "with duplicate_key should be created on a class" do 
			bucket.create_index( :duplicate_key, true )
			bucket.has_index?( :duplicate_key ).should == true
		end 
   
		context "after created with duplicatable key" do 
		
			before :each do 
	   		 bucket.create_index( :duplicate_key, true )
	   	end 
	   		   	
	   	it "will not be null" do 
		   	bucket.index( :duplicate_key ).should_not == nil
		  end 
		  
		  #########################
		  #  permits_duplicates?  #
		  #########################
		  
		  it 'will permit duplicate entries' do
		  	bucket.index( :duplicate_key ).permits_duplicates?.should == true
		  end
		
		end
		
		context "after created with non-duplicatable key" do 
   	
	   	before :each do 
	   		 bucket.create_index( :key, false )
	   	end 

	   	it "will not be null" do 
		   	bucket.index( :key ).should_not == nil
		  end 
  
		  #########################
		  #  permits_duplicates?  #
		  #########################
		
		  it 'will not permit duplicate entries' do
		    bucket.index( :key ).permits_duplicates?.should == false
		  end
 
		  ##################
		  #  index_object  #
		  ##################
		
		  it 'will index an object based on a created index so that the object ID will be retrieved by key' do
		    bucket.index( :key ).index_object_id( @object.persistence_id, @object.non_atomic_attribute )
		    #this is tricky, we are not sure it worked even if it passed. All we will do is check for exceptions.
		  end

		  context "with indexed object" do 
		  
				before :each do 
					bucket.index( :key ).index_object_id( @object.persistence_id, @object.non_atomic_attribute )
				end

			  ###########
			  #  count  #
			  ###########
			  
			  #changed from "will report how many objects are persisted"
			  it 'will report how many objects are index' do
			    bucket.index( :key ).count.should == 1
			    
			  end
				
			  ###################
			  #  get_object_id  #
			  ###################
			
			  it "will get the object ID corresponding to a key in a bucket" do
			    # get_object_id_for_index_and_key
			    bucket.index( :key ).get_object_id( @object.non_atomic_attribute ).should == @object.persistence_id
			
			  end
			
			  ################################
			  #  delete_keys_for_object_id!  #
			  ################################
			
			  it 'will delete index values for an object' do
			    bucket.index( :key ).delete_keys_for_object_id!( @object.persistence_id )
			    ( bucket.index( :key ).get_object_id( @object.non_atomic_attribute ) ? true : false ).should == false
			  end
			
			  ##################
			  #  delete_index  #
			  ##################
			
			  it 'will delete an index that has been created on a class attribute' do
			    bucket.delete_index( :key )
			    bucket.has_index?( :key ).should == false
		    end
	    end
	  end
  end
end	  
