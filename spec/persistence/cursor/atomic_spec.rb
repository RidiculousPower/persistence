
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Cursor::Atomic do

  before :all  do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Cursor::Atomic::Mock
      include ::Persistence
      attr_non_atomic_accessor :name
    end

    @objects = [ ]
    5.times do |this_number|
      instance = ::Persistence::Cursor::Atomic::Mock.new
      instance.name = 'Number ' << this_number.to_s
      instance.persist!
      @objects.push( instance )
    end    

    @cursor = ::Persistence::Cursor::Atomic::Mock.instance_persistence_bucket.atomic_cursor
    
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  before :each do
  	@objects.first
  	@cursor.first
  end


  

  ################
  #  persisted?  #
  ################
  context "#persisted?" do 
	  it "with persistence_id should a return true if the object is in the cursor" do
	    @cursor.persisted?( @objects[ 0 ].persistence_id ).should == true
	  end

  end
    
  #########
  #  any  #
  #########
  context "#any" do 
	  it "should return a object in the cursor" do
	    @objects.include?( @cursor.any ).should == true
	  end
	 	
	 	it "with 2 should return two objects in the cursor" do 	    
	    @cursor.any( 2 ).each do |this_object|
	      @objects.include?( this_object ).should == true
	    end
	  end
	  
	  it "should return a random value"
	  
  end
  
  #################
  #  first, last  #
  #################
  [:first, :last].each do |method|
		context "##{method}" do
		  it "should return the #{method} object" do
		    @cursor.send(method).should == @objects.send(method)
		  end
		 	
		 	it "should return the #{method} 2 object" do 	    
		    @cursor.send(method, 2 ).should == @objects.send(method, 2 )
		  end				  
	  end
  end
  
  ##########
  #  next  #
  ##########
  context "#next" do 
  	#can set its position to the next key
	  it "first call should return the 0th object" do 
	   @cursor.next.should == @objects.first
	  end
	 	
	 	it "should return the next object in the sequence" do 
	   	5.times do |index|  
		    @cursor.next.should == @objects[index]
	    end
	  end
	 	
	 	it "first call with numaric argument should return the next number of objects in the sequence equal to the numaric argument" do 
	 		5.times do |index|
	 			@cursor.first
	    	@cursor.next( index ).should == @objects[ 0..index-1 ] if index > 1 # next of 0 or 1 is not an array
	    end
	  end
	  
	  it "with the argument of 1 should return the next object in the sequence" do 
	 		@cursor.next( 1 ).should == @objects.first 
	 	end
	 	
	 	it "with the argument of 0 should return nil" do 
	 		@cursor.next( 0 ).should == nil 
	 	end

	 	it "with the argumenta of -1 should return the next object in the sequence" do 
	 		@cursor.next( -1 ).should == @objects.first 
	 	end
  end
  
  #############
  #  current  #
  #############
  context "#current" do 
		it 'should return the current key' do
		  @cursor.current.should == @objects.first
		end
		
		it 'should return the current key' do
			@cursor.next(2)
		  @cursor.current.should == @objects[1]
		end
  end
  
  ##########
  #  each  #
  ##########
  context "#each" do 
  	#can iterate each record
  	let(:enum) {@cursor.each}
	 	
	 	it "should return an enumerator" do 	    
	    enum.is_a?( Enumerator ).should == true
	 	end
	 	
	 	context "returned enumerator" do 
		 	it "with next should return the first object" do 
		    enum.next.should == @objects[ 0 ]
		 	end
		 	
		 	it "with next twice should return the second object" do 
		 		enum.next
		    enum.next.should == @objects[ 1 ]
		 	end
	 	end			 	
  end
  
  #####################
  #  each_with_index  #
  #####################
  
  context "#each_with_index" do 
		#can iterate each record
 		it "should return each object and index key pair" do
	  	@cursor.each_with_index do |this_object, this_index|
	    	this_object.should == @objects[ this_index ]
	    end
		end
	end
  
end

