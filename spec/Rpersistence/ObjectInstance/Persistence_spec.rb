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

  #############################
  #  reset_persistence_id_to  #
  #############################

  #####################
  #  persistence_key  #
  #####################
  
  ########################
  #  persistence_locale  #
  ########################
  
  #########################
  #  persistence_version  #
  #########################
  
  ##########################
  #  has_persistence_key!  #
  ##########################

  ##########################
  #  has_persistence_key?  #
  ##########################
  
  ################
  #  persist!    #
  #  persist     #
  #  persisted?  #
  #  cease!      #
  ################

  #########################################  Flat Persistence  ##############################################

  it "can put a string object to a persistence port and get it back" do
    string_object = "some string"
    storage_key   = "string storage key"
    # test 1: default bucket
    string_object.persist!( storage_key )
    String.persist( storage_key ).should == string_object
    String.cease!( storage_key )
    String.persist( storage_key ).should == nil
    # test 2: specifying bucket
    string_object = "some string"
    string_object.persist!( 'Other Bucket', storage_key )
    String.persist( 'Other Bucket', storage_key ).should == string_object
    string_object.cease!( 'Other Bucket', storage_key )
    String.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a symbol object to a persistence port and get it back" do
    symbol_object = :symbol
    storage_key   = :symbol_storage_key
    # test 1: default bucket
    symbol_object.persist!( storage_key )
    Symbol.persist( storage_key ).should == symbol_object
    Symbol.cease!( storage_key )
    Symbol.persist( storage_key ).should == nil
    # test 2: specifying bucket
    symbol_object.persist!( 'Other Bucket', storage_key )
    persisted_object = Symbol.persist( 'Other Bucket', storage_key )
    persisted_object.should == symbol_object
    symbol_object.cease!( 'Other Bucket', storage_key )
    Symbol.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a regexp object to a persistence port and get it back" do
    regexp_object = /some_regexp_([A-Za-z])/
    storage_key   = /regexp_storage_key/
    # test 1: default bucket
    regexp_object.persist!( storage_key )
    Regexp.persist( storage_key ).should == regexp_object
    Regexp.cease!( storage_key )
    Regexp.persist( storage_key ).should == nil
    # test 2: specifying bucket
    regexp_object.persist!( 'Other Bucket', storage_key )
    Regexp.persist( 'Other Bucket', storage_key ).should == regexp_object
    regexp_object.cease!( 'Other Bucket', storage_key )
    Regexp.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a fixnum number object to a persistence port and get it back" do
    fixnum_object = 420
    storage_key   = 12
    # test 1: default bucket
    fixnum_object.persist!( storage_key )
    Fixnum.persist( storage_key ).should == fixnum_object
    Fixnum.cease!( storage_key )
    Fixnum.persist( storage_key ).should == nil
    # test 2: specifying bucket
    fixnum_object.persist!( 'Other Bucket', storage_key )
    Fixnum.persist( 'Other Bucket', storage_key ).should == fixnum_object
    fixnum_object.cease!( 'Other Bucket', storage_key )
    Fixnum.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a bignum number object to a persistence port and get it back" do
    bignum_object = 10**20
    storage_key   = 10**40
    # test 1: default bucket
    bignum_object.persist!( storage_key )
    Bignum.persist( storage_key ).should == bignum_object
    Bignum.cease!( storage_key )
    Bignum.persist( storage_key ).should == nil
    # test 2: specifying bucket
    bignum_object.persist!( 'Other Bucket', storage_key )
    Bignum.persist( 'Other Bucket', storage_key ).should == bignum_object
    bignum_object.cease!( 'Other Bucket', storage_key )
    Bignum.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a float number object to a persistence port and get it back" do
    float_object  = 42.020
    storage_key   = 37.0012
    # test 1: default bucket
    float_object.persist!( storage_key )
    Float.persist( storage_key ).should == float_object
    Float.cease!( storage_key )
    Float.persist( storage_key ).should == nil
    # test 2: specifying bucket
    float_object.persist!( 'Other Bucket', storage_key )
    Float.persist( 'Other Bucket', storage_key ).should == float_object
    float_object.cease!( 'Other Bucket', storage_key )
    Float.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a complex number object to a persistence port and get it back" do
    complex_object  = Complex( 42, 1 )
    storage_key     = Complex( 37, 12 )
    # test 1: default bucket
    complex_object.persist!( storage_key )
    Complex.persist( storage_key ).should == complex_object
    Complex.cease!( storage_key )
    Complex.persist( storage_key ).should == nil
    # test 2: specifying bucket
    complex_object.persist!( 'Other Bucket', storage_key )
    Complex.persist( 'Other Bucket', storage_key ).should == complex_object
    complex_object.cease!( 'Other Bucket', storage_key )
    Complex.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a rational number object to a persistence port and get it back" do
    rational_object = Rational( 42, 37 )
    storage_key     = Rational( 42, 420 )
    # test 1: default bucket
    rational_object.persist!( storage_key )
    Rational.persist( storage_key ).should == rational_object
    Rational.cease!( storage_key )
    Rational.persist( storage_key ).should == nil
    # test 2: specifying bucket
    rational_object.persist!( 'Other Bucket', storage_key )
    Rational.persist( 'Other Bucket', storage_key ).should == rational_object
    Rational.cease!( 'Other Bucket', storage_key )
    Rational.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a file object to a persistence port and get it back" do
    key_path          = File.expand_path( File.dirname( __FILE__ ) + '/Persistence_file_key.rb' )
    file_object_path  = File.expand_path( File.dirname( __FILE__ ) + '/Persistence_file_data.rb' )
    file_object = File.open( file_object_path )
    storage_key = File.open( key_path )
    # test 1: default bucket
    file_object.persist!( storage_key )
    # if the storage key is a file then we need to get either the path or the contents
    persisted_file = File.persist( storage_key )
    persisted_file.should == File.open( file_object_path ).readlines.join
    File.cease!( storage_key )
    File.persist( storage_key ).should == nil

    # test 2: specifying bucket
    file_object.persist!( 'Other Bucket', storage_key )
    File.persist( 'Other Bucket', storage_key ).should == File.open( file_object_path ).readlines.join
    file_object_path.cease!( 'Other Bucket', storage_key )
    File.persist( storage_key ).should == nil
  end

  it "can put a true object to a persistence port and get it back" do
    true_object = true
    storage_key = false
    # test 1: default bucket
    true_object.persist!( storage_key )
    TrueClass.persist( storage_key ).should == true_object
    TrueClass.cease!( storage_key )
    TrueClass.persist( storage_key ).should == nil
    # test 2: specifying bucket
    true_object.persist!( 'Other Bucket', storage_key )
    TrueClass.persist( 'Other Bucket', storage_key ).should == true_object
    true_object.cease!( 'Other Bucket', storage_key )
    TrueClass.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a false object to a persistence port and get it back" do
    false_object  = false
    storage_key   = true
    # test 1: default bucket
    false_object.persist!( storage_key )
    FalseClass.persist( storage_key ).should == false_object
    FalseClass.cease!( storage_key )
    FalseClass.persist( storage_key ).should == nil
    # test 2: specifying bucket
    false_object.persist!( 'Other Bucket', storage_key )
    FalseClass.persist( 'Other Bucket', storage_key ).should == false_object
    false_object.cease!( 'Other Bucket', storage_key )
    FalseClass.persist( 'Other Bucket', storage_key ).should == nil
  end

  it "can put a class object to a persistence port and get it back" do
    class_object  = Object
    storage_key   = Class
    # test 1: default bucket
    class_object.persist!( storage_key )
    Class.persist( storage_key ).should == class_object
    Class.cease!( storage_key )
    Class.persist( storage_key ).should == nil
    # test 2: specifying bucket
    class_object.persist!( 'Other Bucket', storage_key )
    Class.persist( 'Other Bucket', storage_key ).should == class_object
    class_object.cease!( 'Other Bucket', storage_key )
    Class.persist( 'Other Bucket', storage_key ).should == nil
  end

  #######################################  Complex Persistence  #############################################

  it "can persist an object to and from an arbitrary bucket with an arbitrary key" do
    class UserObject1
      attr_accessor :username, :firstname, :lastname
    end
    user = UserObject1.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!( 'Misc Objects', 'object storage key' )
    
    persisted_user = UserObject1.persist( 'Misc Objects', 'object storage key' )
    persisted_user.should == user
    
  end

  it "can persist an object to and from a default bucket with an arbitrary key" do
    class UserObject2
      attr_accessor :username, :firstname, :lastname
    end
    user = UserObject2.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!( 'object storage key' )
    UserObject2.persist( 'object storage key' ).should == user
  end

  it "can persist an object to and from a default bucket with an arbitrary key method" do
    class UserObject3
      attr_accessor :username, :firstname, :lastname
      persists_by  :username
    end
    user = UserObject3.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    UserObject3.persist( 'user' ).should == user
  end

  it "can persist an object to and from a default bucket with an arbitrary key variable" do
    class UserObject4
      attr_accessor :username, :firstname, :lastname
      persists_by  :@username
    end
    user = UserObject4.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
    user.persist!
    UserObject4.persist( 'user' ).should == user
  end

  it "can persist an object with other objects as members" do

    class UserObject5
      attr_accessor :username, :firstname, :lastname, :address, :alternate_address
      persists_by  :@username
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

    UserObject5.persist( 'user' ).should == user

    user.alternate_address.number = 48

    user.alternate_address.persist!

    UserObject5.persist( 'user' ).should == user

  end

  it "can persist an object with other objects as members that have atomic properties" do

    class UserObject6
      attr_accessor :username, :firstname, :lastname, :address, :alternate_address
      persists_by  :@username
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

    UserObject6.persist( 'user' ).should == user

    user.alternate_address.number = 48

    UserObject6.persist( 'user' ).should == user

  end
  
  it "can persist an object with hash members" do
    
    class HashContainerClass1
      persists_by     :storage_key
      attr_accessor   :storage_key, :hash
    end

    storage_key                     = :hash_container
    hash_key                        = :hash_key
    hash_data                       = :hash_data
    hash_container                  = HashContainerClass1.new
    hash_container.storage_key      = storage_key
    hash_container.hash             = Hash.new
    hash_container.hash[ hash_key ] = hash_data
    
    hash_container.persist!
    HashContainerClass1.persist( storage_key ).should == hash_container
    
  end

  it "can persist an object with array members" do

    class ArrayContainerClass1
      persists_by     :storage_key
      attr_accessor   :storage_key, :array
    end

    storage_key                         = :array_container
    array_data                          = :array_data
    array_container                     = ArrayContainerClass1.new
    array_container.storage_key         = storage_key
    array_container.array               = Array.new
    array_container.array.push( array_data )
    
    array_container.persist!
    ArrayContainerClass1.persist( storage_key ).should == array_container
    
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

  ####################################################
  #  instance_variables_minus_persistence_variables  #
  ####################################################

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
