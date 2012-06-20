
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Persist::ObjectInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can persist an object to and from a default bucket with an arbitrary key method" do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class UserObject3
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_accessor :username, :firstname, :lastname
      attr_index    :username
    end
    user = UserObject3.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    UserObject3.persist( :username => 'user' ).should == user
  end

  it "can persist an object to and from a default bucket with an arbitrary key variable" do
    class UserObject4
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_accessor :username, :firstname, :lastname
      attr_index  :username
    end
    user = UserObject4.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    UserObject4.persist( :username => 'user' ).should == user
  end

  it "can persist an object with other objects as members" do
    class UserObject5
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_accessor :username, :firstname, :lastname, :address, :alternate_address
      attr_index  :username
    end
    class Address1
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_accessor :number, :street, :city, :state, :zipcode
    end

    user = UserObject5.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'

    user.address = Address1.new
    user.address.number = 42
    user.address.street = 'Street'
    user.address.city = 'Some City'
    user.address.state = 'GA'
    user.address.zipcode = '30003'

    user.alternate_address = Address1.new
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

    UserObject5.persist( :username => 'user' ).should == user

    user.alternate_address.number = 48

    user.alternate_address.persist!

    UserObject5.persist( :username => 'user' ).should == user

  end

  it "can persist an object with other objects as members that have atomic properties" do
    class UserObject6
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_accessor :username, :firstname, :lastname, :address, :alternate_address
      attr_index  :username
    end
    class Address1
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_accessor :number, :street, :city, :state, :zipcode
      attr_atomic_accessor :number
      attrs_atomic!
    end
    
    Address1.atomic_attribute?( :number ).should == true

    user = UserObject6.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'

    user.address = Address1.new
    user.address.number = 42
    user.address.street = 'Street'
    user.address.city = 'Some City'
    user.address.state = 'GA'
    user.address.zipcode = '30003'

    user.alternate_address = Address1.new
    user.alternate_address.number = 37
    user.alternate_address.street = 'Another Street'
    user.alternate_address.city = 'Some Other City'
    user.alternate_address.state = 'TX'
    user.alternate_address.zipcode = '70004'
    user.persist!

    UserObject6.persist( :username => 'user' ).should == user

    user.alternate_address.number = 48

    UserObject6.persist( :username => 'user' ).should == user

  end
  
  it "can persist an object with hash members" do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class HashContainerClass1
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_accessor  :some_hash, :storage_key
      attr_index     :storage_key
    end
    class Hash
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::PersistenceHash::HashInstance
    end

    hash_container                  = HashContainerClass1.new
    hash_container.storage_key      = :hash_container
    hash_container.some_hash             = { }
    hash_container.some_hash[ :hash_key ] = :hash_data
    
    hash_container.persist!
    HashContainerClass1.persist( :storage_key => :hash_container ).should == hash_container
    
  end

  it "can persist an object with array members" do
    class ArrayContainerClass1
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Persist::ObjectInstance
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance
      include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      extend ::Persistence::Object::Complex::Indexing::Indexes::Attributes
      attr_accessor  :array, :storage_key
      attr_index     :storage_key
    end
    class Array
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::PersistenceHash::ArrayInstance
    end

    storage_key                         = :array_container
    array_data                          = :array_data
    array_container                     = ArrayContainerClass1.new
    array_container.storage_key         = storage_key
    array_container.array               = [ ]
    array_container.array.push( array_data )
    
    array_container.persist!
    ArrayContainerClass1.persist( :storage_key => storage_key ).should == array_container
    
  end
    
end
