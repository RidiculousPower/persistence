
require_relative '../../../../lib/persistence.rb'

require_relative '../mock_helpers.rb'

describe ::Persistence::Adapter do
  
  before :all do

    @adapter = $__persistence__spec__adapter__ || ::Persistence::Adapter::Mock.new( '/tmp/persistence_home' )

    ::Persistence.enable_port( :mock, @adapter )

    class ::Persistence::Adapter::MockCursorObject
      include ::Persistence
      attr_non_atomic_accessor :attribute
      attr_index :attribute
    end
    
    @bucket = ::Persistence::Adapter::MockCursorObject.instance_persistence_bucket.adapter_bucket
    @index = @bucket.index( :attribute )

    @objects = [ ]
    ::Persistence::Adapter::Abstract::Mock::Object.instance_persistence_bucket = @bucket
    5.times do |this_number|
      this_attribute = 'Number ' << this_number.to_s
      unless instance = ::Persistence::Adapter::MockCursorObject.persist( :attribute, this_attribute )
        instance = ::Persistence::Adapter::MockCursorObject.new
        instance.attribute = this_attribute
        instance.persist!
      end
      @objects[ this_number ] = instance
    end    

  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  ################
  #  first       #
  #  get_key     #
  #  persisted?  #
  #  current     #
  #  next        #
  ################
  before :each do 
   @bucket_cursor = @bucket.cursor 
   @index_cursor = @index.cursor 
  end
  
  after :each do 
  	@bucket_cursor.close
  	@index_cursor.close
  end
  
  context "#bucket_cursor"  do
  	#it can return an object ID for persistence ID
    context ".persisted?" do 
	    it "should return true if cursor contains object" do 
	    	5.times do |index |
			    @bucket_cursor.persisted?( @objects[ index ].persistence_id ).should == true
		    end
	    end
	    it "should return false if cursor does not contain object" do 
	    	#assumes simple ID
	    	@bucket_cursor.persisted?( @objects.count ).should == false
	    end
    end
    
    context ".first" do 
	    it "should return the first object in the cursor" do 
	    	@bucket_cursor.first.should == @objects[ 0 ].persistence_id
	    end
	  end

		context ".current" do 	    
	    it "should return the current object in the cursor" do 
		  	@bucket_cursor.first
		    @bucket_cursor.current.should == @objects[ 0 ].persistence_id
	    end
		end    

  end
  
  context "#index_cursor" do 
    #it can return an object ID for key  
    context ".persisted?" do 
	    it "should return true if cursor contains object" do 
	    	5.times do |index |
		    	@index_cursor.persisted?( @objects[ index ].attribute ).should == true
		    end
		  end
		  it "should return false if cursor does not contain object" do 
	    	@index_cursor.persisted?( :garbage_attr ).should == false
	    end
		end
    context ".first" do     
	    it "should return the first object in the cursor" do 
		    @index_cursor.first.should == @objects[ 0 ].persistence_id
	    end
	  end
		context ".current" do     
	    it "should return the current object in the cursor" do 
		    @index_cursor.first
		    @index_cursor.current.should == @objects[ 0 ].persistence_id
	    end
    end
  end

end
