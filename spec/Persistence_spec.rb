
require_relative '../lib/persistence.rb'

describe ::Persistence do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can persist an object to and from a default bucket with an arbitrary key method" do
    class ::Persistence::MockUserObject3
      include ::Persistence
      attr_accessor :username, :firstname, :lastname
      attr_index    :username
    end
    user = ::Persistence::MockUserObject3.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    ::Persistence::MockUserObject3.persist( :username => 'user' ).should == user
  end

  it "can persist an object to and from a default bucket with an arbitrary key variable" do
    class ::Persistence::MockUserObject4
      include ::Persistence
      attr_accessor :username, :firstname, :lastname
      attr_index  :username
    end
    user = ::Persistence::MockUserObject4.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    ::Persistence::MockUserObject4.persist( :username => 'user' ).should == user
  end
  
  it "can persist an object with other objects as members" do
    class ::Persistence::MockUserObject5
      include ::Persistence
      attr_accessor :username, :firstname, :lastname, :address, :alternate_address
      attr_index  :username
    end
    class ::Persistence::MockAddress1
      include ::Persistence
      attr_accessor :number, :street, :city, :state, :zipcode
    end
  
    user = ::Persistence::MockUserObject5.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
  
    user.address = ::Persistence::MockAddress1.new
    user.address.number = 42
    user.address.street = 'Street'
    user.address.city = 'Some City'
    user.address.state = 'GA'
    user.address.zipcode = '30003'
  
    user.alternate_address = ::Persistence::MockAddress1.new
    user.alternate_address.number = 37
    user.alternate_address.street = 'Another Street'
    user.alternate_address.city = 'Some Other City'
    user.alternate_address.state = 'TX'
    user.alternate_address.zipcode = '70004'
    user.persist!
  
    # here we should be looking for:
    # * username            => 'user' => looks for 'user' with bucket (should find it and replace it)
    # * address             => should get ID from existing user if user exists => needs to check if existing user address is same ID
    # * alternate_ddress    => should also get ID from existing user if user exists => needs to check if existing alternate address is same ID
  
    ::Persistence::MockUserObject5.persist( :username => 'user' ).should == user
  
    user.alternate_address.number = 48
  
    user.alternate_address.persist!
  
    ::Persistence::MockUserObject5.persist( :username => 'user' ).should == user
  
  end
  
  it "can persist an object with other objects as members that have atomic properties" do
    class ::Persistence::MockUserObject6
      include ::Persistence
      attr_accessor :username, :firstname, :lastname, :address, :alternate_address
      attr_index  :username
    end
    class ::Persistence::MockAddress1
      include ::Persistence
      attr_accessor :number, :street, :city, :state, :zipcode
      attr_atomic_accessor :number
      attrs_atomic!
    end
    
    ::Persistence::MockAddress1.atomic_attribute?( :number ).should == true
  
    user = ::Persistence::MockUserObject6.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
  
    user.persist!
  
    user.address = ::Persistence::MockAddress1.new
    user.address.number = 42
    user.address.street = 'Street'
    user.address.city = 'Some City'
    user.address.state = 'GA'
    user.address.zipcode = '30003'
  
    user.alternate_address = ::Persistence::MockAddress1.new
    user.alternate_address.number = 37
    user.alternate_address.street = 'Another Street'
    user.alternate_address.city = 'Some Other City'
    user.alternate_address.state = 'TX'
    user.alternate_address.zipcode = '70004'
  
    persisted_user = ::Persistence::MockUserObject6.persist( :username => 'user' )
    persisted_user.should == user
  
    user.alternate_address.number = 48
  
    ::Persistence::MockUserObject6.persist( :username => 'user' ).should == user
  
  end
  
  it "can persist an object with hash members" do
    class ::Persistence::MockHashContainerClass1
      include ::Persistence
      attr_accessor  :some_hash, :storage_key
      attr_index     :storage_key
    end
    class ::Persistence::MockHash < Hash
      include ::Persistence
    end
  
    hash_container                  = ::Persistence::MockHashContainerClass1.new
    hash_container.storage_key      = :hash_container
    hash_container.some_hash             = ::Persistence::MockHash.new
    hash_container.some_hash[ :hash_key ] = :hash_data
    
    hash_container.persist!
    ::Persistence::MockHashContainerClass1.persist( :storage_key => :hash_container ).should == hash_container
    
  end
  
  it "can persist an object with array members" do
    class ::Persistence::MockArrayContainerClass1
      include ::Persistence
      attr_accessor  :array, :storage_key
      attr_index     :storage_key
    end
    class ::Persistence::MockSubArray < Array
      include ::Persistence
    end
  
    storage_key                         = :array_container
    array_data                          = :array_data
    array_container                     = ::Persistence::MockArrayContainerClass1.new
    array_container.storage_key         = storage_key
    array_container.array               = ::Persistence::MockSubArray.new
    array_container.array.push( array_data )
    
    array_container.persist!
    ::Persistence::MockArrayContainerClass1.persist( :storage_key => storage_key ).should == array_container
    
  end
  
end
