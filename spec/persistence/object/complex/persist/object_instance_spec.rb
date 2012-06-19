
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Persist::ObjectInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ##############
  #  persist!  #
  #  persist   #
  ##############

  it "can persist an object to and from a default bucket with an arbitrary key method" do
    class UserObject3
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :username, :firstname, :lastname
    end
    user = UserObject3.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    persisted_user = UserObject3.persist( user.persistence_id )
    persisted_user.should == user
    persisted_user_two = UserObject3.new
    persisted_user_two.persistence_id = persisted_user.persistence_id
    persisted_user_two.persist
    persisted_user_two.should == persisted_user
  end

  it "can persist an object to and from a default bucket with an arbitrary key variable" do
    class UserObject4
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :username, :firstname, :lastname
    end
    user = UserObject4.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    UserObject4.persist( user.persistence_id ).should == user
    persisted_user_two = UserObject4.new
    persisted_user_two.persistence_id = user.persistence_id
    persisted_user_two.persist
    persisted_user_two.should == user
  end

  it "can persist an object with other objects as members" do
    class UserObject5
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address
    end
    class Address1
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :number, :street, :city, :state, :zipcode
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

    UserObject5.persist( user.persistence_id ).should == user

    user.alternate_address.number = 48

    user.alternate_address.persist!

    UserObject5.persist( user.persistence_id ).should == user

  end

  it "can persist an object with other objects as members that have atomic properties" do
    class UserObject6
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address
    end
    class Address1
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :number, :street, :city, :state, :zipcode
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

    UserObject6.persist( user.persistence_id ).should == user

    user.alternate_address.number = 48

    UserObject6.persist( user.persistence_id ).should == user

  end
  
  it "can persist an object with hash members" do
    class Hash
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::PersistenceHash::HashInstance
      include ::Persistence::Object::Complex::Equality
    end
    class HashContainerClass1
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :some_hash
    end

    hash_container = HashContainerClass1.new
    hash_container.some_hash = { }
    hash_container.some_hash[ :hash_key ] = :hash_data
    hash_container.persist!
    HashContainerClass1.persist( hash_container.persistence_id ).should == hash_container
    
  end

  it "can persist an object with array members" do
    class Array
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::PersistenceHash::ArrayInstance
      include ::Persistence::Object::Complex::Equality
    end
    class ArrayContainerClass1
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Persist::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor  :array, :storage_key
    end

    storage_key                         = :array_container
    array_data                          = :array_data
    array_container                     = ArrayContainerClass1.new
    array_container.storage_key         = storage_key
    array_container.array               = [ ]
    array_container.array.push( array_data )
    
    array_container.persist!
    ArrayContainerClass1.persist( array_container.persistence_id ).should == array_container
    
  end
    
end
