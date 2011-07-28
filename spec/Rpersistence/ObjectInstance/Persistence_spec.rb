require_relative '../../../lib/rpersistence.rb'

describe Rpersistence::ObjectInstance::Persistence do

  $__rpersistence__spec__adapter_test_class__       ||= Rpersistence::Adapter::Mock
  $__rpersistence__spec__adapter_home_directory__   ||= nil

  before( :all ) do
    Rpersistence.enable_port( :test, $__rpersistence__spec__adapter_test_class__.new( $__rpersistence__spec__adapter_home_directory__ ) )    
  end
  
  after( :all ) do
    Rpersistence.current_port.disable
  end

  ####################
  #  persistence_id  #
  ####################

  #####################
  #  persistence_id=  #
  #####################

  ########################
  #  persistence_locale  #
  ########################
  
  #########################
  #  persistence_version  #
  #########################
  
  ################
  #  persist!    #
  #  persist     #
  #  persisted?  #
  #  cease!      #
  ################

  #########################################  Flat Persistence  ##############################################

  it "can put a string object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    string_object = "some string"
    storage_key   = "string storage key"
    string_object.persist!( storage_key )
    String.persist( storage_key ).should == string_object
    String.cease!( storage_key )
    String.persist( storage_key ).should == nil
  end

  it "can put a symbol object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    symbol_object = :symbol
    storage_key   = :symbol_storage_key
    symbol_object.persist!( storage_key )
    Symbol.persist( storage_key ).should == symbol_object
    Symbol.cease!( storage_key )
    Symbol.persist( storage_key ).should == nil
  end

  it "can put a regexp object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    regexp_object = /some_regexp_([A-Za-z])/
    storage_key   = /regexp_storage_key/
    regexp_object.persist!( storage_key )
    Regexp.persist( storage_key ).should == regexp_object
    Regexp.cease!( storage_key )
    Regexp.persist( storage_key ).should == nil
  end

  it "can put a fixnum number object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    fixnum_object = 420
    storage_key   = 12
    fixnum_object.persist!( storage_key )
    Fixnum.persist( storage_key ).should == fixnum_object
    Fixnum.cease!( storage_key )
    Fixnum.persist( storage_key ).should == nil
  end

  it "can put a bignum number object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    bignum_object = 10**20
    storage_key   = 10**40
    bignum_object.persist!( storage_key )
    Bignum.persist( storage_key ).should == bignum_object
    Bignum.cease!( storage_key )
    Bignum.persist( storage_key ).should == nil
  end

  it "can put a float number object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    float_object  = 42.020
    storage_key   = 37.0012
    float_object.persist!( storage_key )
    Float.persist( storage_key ).should == float_object
    Float.cease!( storage_key )
    Float.persist( storage_key ).should == nil
  end

  it "can put a complex number object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    complex_object  = Complex( 42, 1 )
    storage_key     = Complex( 37, 12 )
    complex_object.persist!( storage_key )
    Complex.persist( storage_key ).should == complex_object
    Complex.cease!( storage_key )
    Complex.persist( storage_key ).should == nil
  end

  it "can put a rational number object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    rational_object = Rational( 42, 37 )
    storage_key     = Rational( 42, 420 )
    rational_object.persist!( storage_key )
    Rational.persist( storage_key ).should == rational_object
    Rational.cease!( storage_key )
    Rational.persist( storage_key ).should == nil
  end

  it "can put a file object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    key_path          = File.expand_path( File.dirname( __FILE__ ) + '/Persistence_file_key.rb' )
    file_object_path  = File.expand_path( File.dirname( __FILE__ ) + '/Persistence_file_data.rb' )
    file_object = File.open( file_object_path )
    storage_key = File.open( key_path )
    file_object.persist!( storage_key )
    # if the storage key is a file then we need to get either the path or the contents
    persisted_file = File.persist( storage_key )
    persisted_file.should == File.open( file_object_path ).readlines.join
    File.cease!( storage_key )
    File.persist( storage_key ).should == nil
  end

  it "can put a true object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    true_object = true
    storage_key = false
    true_object.persist!( storage_key )
    TrueClass.persist( storage_key ).should == true_object
    TrueClass.cease!( storage_key )
    TrueClass.persist( storage_key ).should == nil
  end

  it "can put a false object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    false_object  = false
    storage_key   = true
    false_object.persist!( storage_key )
    FalseClass.persist( storage_key ).should == false_object
    FalseClass.cease!( storage_key )
    FalseClass.persist( storage_key ).should == nil
  end

  it "can put a class object to a persistence port and get it back" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    class_object  = Object
    storage_key   = Class
    class_object.persist!( storage_key )
    Class.persist( storage_key ).should == class_object
    Class.cease!( storage_key )
    Class.persist( storage_key ).should == nil
  end

  #######################################  Complex Persistence  #############################################

  it "can persist an object to and from a default bucket with an arbitrary key method" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    class UserObject3
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
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    class UserObject4
      attr_accessor :username, :firstname, :lastname
      attr_index  :@username
    end
    user = UserObject4.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    UserObject4.persist( :@username => 'user' ).should == user
  end

  it "can persist an object with other objects as members" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    class UserObject5
      attr_accessor :username, :firstname, :lastname, :address, :alternate_address
      attr_index  :@username
    end
    class Address1
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

    UserObject5.persist( :@username => 'user' ).should == user

    user.alternate_address.number = 48

    user.alternate_address.persist!

    UserObject5.persist( :@username => 'user' ).should == user

  end

  it "can persist an object with other objects as members that have atomic properties" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    class UserObject6
      attr_accessor :username, :firstname, :lastname, :address, :alternate_address
      attr_index  :username
    end
    class Address1
      attr_accessor :number, :street, :city, :state, :zipcode
      attr_atomic :number
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
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    class HashContainerClass1
      attr_accessor  :hash, :storage_key
      attr_index     :storage_key
    end

    storage_key                     = :hash_container
    hash_key                        = :hash_key
    hash_data                       = :hash_data
    hash_container                  = HashContainerClass1.new
    hash_container.storage_key      = storage_key
    hash_container.hash             = Hash.new
    hash_container.hash[ hash_key ] = hash_data
    
    hash_container.persist!
    HashContainerClass1.persist( :storage_key => storage_key ).should == hash_container
    
  end

  it "can persist an object with array members" do
    Rpersistence.enable_port( :adapter, Rpersistence::Adapter::Mock.new )
    class ArrayContainerClass1
      attr_accessor  :array, :storage_key
      attr_index     :storage_key
    end

    storage_key                         = :array_container
    array_data                          = :array_data
    array_container                     = ArrayContainerClass1.new
    array_container.storage_key         = storage_key
    array_container.array               = Array.new
    array_container.array.push( array_data )
    
    array_container.persist!
    ArrayContainerClass1.persist( :storage_key => storage_key ).should == array_container
    
  end

  #######################
  #  stop_persistence!  #
  #######################

  ##########################
  #  suspend_persistence!  #
  ##########################

  #########################
  #  resume_persistence!  #
  #########################

  #############################
  #  instance_variables_hash  #
  #############################

  ########################
  #  instance_variables  #
  ########################
  
  ###########################
  #  instance_variable_get  #
  ###########################

  ###########################
  #  instance_variable_set  #
  ###########################
  
end
