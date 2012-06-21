
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::PersistAndCease::ObjectInstance do

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
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject3
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :username, :firstname, :lastname
    end
    user = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject3.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    persisted_user = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject3.persist( user.persistence_id )
    persisted_user.should == user
    persisted_user_two = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject3.new
    persisted_user_two.persistence_id = persisted_user.persistence_id
    persisted_user_two.persist
    persisted_user_two.should == persisted_user
  end

  it "can persist an object to and from a default bucket with an arbitrary key variable" do
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject4
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :username, :firstname, :lastname
    end
    user = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject4.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject4.persist( user.persistence_id ).should == user
    persisted_user_two = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject4.new
    persisted_user_two.persistence_id = user.persistence_id
    persisted_user_two.persist
    persisted_user_two.should == user
  end

  it "can persist an object with other objects as members" do
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject5
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address
    end
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Address1
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :number, :street, :city, :state, :zipcode
    end

    user = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject5.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'

    user.address = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Address1.new
    user.address.number = 42
    user.address.street = 'Street'
    user.address.city = 'Some City'
    user.address.state = 'GA'
    user.address.zipcode = '30003'

    user.alternate_address = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Address1.new
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

    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject5.persist( user.persistence_id ).should == user

    user.alternate_address.number = 48

    user.alternate_address.persist!

    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject5.persist( user.persistence_id ).should == user

  end

  it "can persist an object with other objects as members that have atomic properties" do
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject6
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address
    end
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Address1
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :number, :street, :city, :state, :zipcode
      attr_atomic_accessor :number
      attrs_atomic!
    end
    
    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Address1.atomic_attribute?( :number ).should == true

    user = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject6.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'

    user.address = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Address1.new
    user.address.number = 42
    user.address.street = 'Street'
    user.address.city = 'Some City'
    user.address.state = 'GA'
    user.address.zipcode = '30003'

    user.alternate_address = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Address1.new
    user.alternate_address.number = 37
    user.alternate_address.street = 'Another Street'
    user.alternate_address.city = 'Some Other City'
    user.alternate_address.state = 'TX'
    user.alternate_address.zipcode = '70004'
    user.persist!

    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject6.persist( user.persistence_id ).should == user

    user.alternate_address.number = 48

    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::UserObject6.persist( user.persistence_id ).should == user

  end
  
  it "can persist an object with hash members" do
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::SubHash < Hash
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::PersistenceHash::HashInstance
      include ::Persistence::Object::Complex::Equality
    end
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::HashContainerClass1
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor :some_hash
    end

    hash_container = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::HashContainerClass1.new
    hash_container.some_hash = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::SubHash.new
    hash_container.some_hash[ :hash_key ] = :hash_data
    hash_container.persist!
    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::HashContainerClass1.persist( hash_container.persistence_id ).should == hash_container
    
  end

  it "can persist an object with array members" do
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::SubArray < Array
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::PersistenceHash::ArrayInstance
      include ::Persistence::Object::Complex::Equality
    end
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::ArrayContainerClass1
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Complex::Equality
      attr_non_atomic_accessor  :array, :storage_key
    end

    storage_key                         = :array_container
    array_data                          = :array_data
    array_container                     = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::ArrayContainerClass1.new
    array_container.storage_key         = storage_key
    array_container.array               = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::SubArray.new
    array_container.array.push( array_data )
    
    array_container.persist!
    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::ArrayContainerClass1.persist( array_container.persistence_id ).should == array_container
    
  end

  ############
  #  cease!  #
  ############

  it 'can delete an object' do
    class ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Mock
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
      include ::Persistence::Object::Complex::PersistAndCease::ObjectInstance
      include ::Persistence::Object::Equality
      include ::Persistence::Object::Complex::Equality
      extend ::Persistence::Object::Complex::PersistAndCease::ClassInstance
      attr_non_atomic_accessor :some_value, :some_other_value
    end
    instance = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Mock.new
    instance.some_value = :value
    instance.some_other_value = :other_value
    instance.persist!
    copy = ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Mock.persist( instance.persistence_id )
    copy.should == instance
    instance.cease!
    ::Persistence::Object::Complex::PersistAndCease::ObjectInstance::Mock.persist( instance.persistence_id ).should == nil
  end
    
end