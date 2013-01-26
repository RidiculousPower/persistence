
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Cursor do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Cursor::ClassInstanceMock
      include ::Persistence
      attr_non_atomic_accessor :name
      explicit_index :key
    end

    @objects = [ ]
    @index = ::Persistence::Cursor::ClassInstanceMock.index( :key )
    5.times do |this_number|
      instance = ::Persistence::Cursor::ClassInstanceMock.new
      instance.name = 'Number ' << this_number.to_s
      instance.persist!
      @index.index_object( instance, instance.name )
      @index.get_object_id( instance.name ).should == instance.persistence_id
      @objects.push( instance )
    end

    @cursor = @index.cursor

  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  ###########
  #  count  #
  ###########
  context "#count" do 
  	
  	context "on class" do 
	  	it "should return the number of objects" do
		    ::Persistence::Cursor::ClassInstanceMock.count.should == 5
		  end
		  
		  it "should pass the objects as to a block and return the number of objects" do 
		  	::Persistence::Cursor::ClassInstanceMock.count { |object| object }.should == 5
		  end
		  
		  it "should pass the objects as to a block and the block should be able to filter the count" do 
		  	::Persistence::Cursor::ClassInstanceMock.count { |object| object == @objects[ 2 ]  }.should == 1
		  end
	  end 
	  	
  	context "on instance_persistence_bucket" do 
		  it 'should return the number of objects' do
		    ::Persistence::Cursor::ClassInstanceMock.instance_persistence_bucket.count.should == 5
		  end
		  
		  it "should pass the objects as to a block and return the number of objects" do 
		  	::Persistence::Cursor::ClassInstanceMock.instance_persistence_bucket.count { |object| object }.should == 5
		  end
		  
		  it "should pass the objects as to a block and the block should be able to filter the count" do 
		    ::Persistence::Cursor::ClassInstanceMock.instance_persistence_bucket.count { |object|  object == @objects[ 2 ] }.should == 1
		  end
	
	  end
	  
	  context "on index with key" do 
			  it 'should return the number of objects' do
			    ::Persistence::Cursor::ClassInstanceMock.index( :key ).count.should == 5
			  end
			  
			  it "should pass the objects as to a block and return the number of objects" do 
			    ::Persistence::Cursor::ClassInstanceMock.index( :key ).count { |object| object }.should == 5
			  end
			  
			  it "should pass the objects as to a block and the block should be able to filter the count" do 
			    ::Persistence::Cursor::ClassInstanceMock.index( :key ).count { |object| object == @objects[ 2 ] }.should == 1
			  end
			  
		  end
	  
	  context "with arguments" do 
	  	context "on class" do 
			  it "with nil index, should test if object is in the bucket" do  
			    ::Persistence::Cursor::ClassInstanceMock.count( nil, @objects[ 2 ] ).should == 1
			  end
			  context "with key" do 
			  	it "should return the number of objects" do 
				    ::Persistence::Cursor::ClassInstanceMock.count( :key ).should == 5
				  end
				  
				  it "should pass the object(s) to a block and return the number of object(s)" do 
				    ::Persistence::Cursor::ClassInstanceMock.count( :key ) { |object| object == @objects[ 2 ] }.should == 1
				  end
			  	it "and object should test if object is in the bucket" do 
				    ::Persistence::Cursor::ClassInstanceMock.count( :key, @objects[ 2 ] ).should == 1
				  end
			  end
		  end
		  context "on instance_persistence_bucket" do
			  it "should test if object is in the bucket" do 
			    ::Persistence::Cursor::ClassInstanceMock.instance_persistence_bucket.count( @objects[ 2 ] ).should == 1
			  end
		  end
		  context "on index with key" do 
	  		it "should test if object is in the bucket" do 
		  		::Persistence::Cursor::ClassInstanceMock.index( :key ).count( @objects[ 2 ] ).should == 1
		    end
			end
	  end
	 end
end

