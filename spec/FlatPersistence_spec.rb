
Rpersistence::Specs::Flat  = 'Flat object specs.'

describe Rpersistence::Specs::Flat do
  
  before( :all ) do
    rpersistence_open_for_spec
    rpersistence_enable_for_spec
  end

  after( :all ) do
    rpersistence_disable_for_spec
  end

  ###################
  #  persist!       #
  #  Klass.persist  #
  ###################

  it "can put a string object to a persistence port and get it back" do
    string_object = "some string"
    storage_key   = "string storage key"
    # test 1: default bucket
    string_object.persist!( storage_key )
    String.persist( storage_key ).should == string_object
    # test 2: specifying bucket
    string_object.persist!( 'Other Bucket', storage_key )
    String.persist( 'Other Bucket', storage_key ).should == string_object
  end

  it "can put a symbol object to a persistence port and get it back" do
    symbol_object = :symbol
    storage_key   = :symbol_storage_key
    # test 1: default bucket
    symbol_object.persist!( storage_key )
    Symbol.persist( storage_key ).should == symbol_object
    # test 2: specifying bucket
    symbol_object.persist!( 'Other Bucket', storage_key )
    Symbol.persist( storage_key ).should == symbol_object
  end

  it "can put a regexp object to a persistence port and get it back" do
    regexp_object = /some_regexp_([A-Za-z])/
    storage_key   = /regexp_storage_key/
    # test 1: default bucket
    regexp_object.persist!( storage_key )
    Regexp.persist( storage_key ).should == regexp_object
    # test 2: specifying bucket
    regexp_object.persist!( 'Other Bucket', storage_key )
    Regexp.persist( 'Other Bucket', storage_key ).should == regexp_object
  end

  it "can put a fixnum number object to a persistence port and get it back" do
    fixnum_object = 420
    storage_key   = 12
    # test 1: default bucket
    fixnum_object.persist!( storage_key )
    Fixnum.persist( storage_key ).should == fixnum_object
    # test 2: specifying bucket
    fixnum_object.persist!( 'Other Bucket', storage_key )
    Fixnum.persist( 'Other Bucket', storage_key ).should == fixnum_object
  end

  it "can put a bignum number object to a persistence port and get it back" do
    bignum_object = 10**20
    storage_key   = 10**40
    # test 1: default bucket
    bignum_object.persist!( storage_key )
    Bignum.persist( storage_key ).should == bignum_object
    # test 2: specifying bucket
    bignum_object.persist!( 'Other Bucket', storage_key )
    Bignum.persist( 'Other Bucket', storage_key ).should == bignum_object
  end

  it "can put a float number object to a persistence port and get it back" do
    float_object  = 42.020
    storage_key   = 37.0012
    # test 1: default bucket
    float_object.persist!( storage_key )
    Float.persist( storage_key ).should == float_object
    # test 2: specifying bucket
    float_object.persist!( 'Other Bucket', storage_key )
    Float.persist( 'Other Bucket', storage_key ).should == float_object
  end

  it "can put a complex number object to a persistence port and get it back" do
    complex_object  = Complex( 42, 1 )
    storage_key     = Complex( 37, 12 )
    # test 1: default bucket
    complex_object.persist!( storage_key )
    Complex.persist( storage_key ).should == complex_object
    # test 2: specifying bucket
    complex_object.persist!( 'Other Bucket', storage_key )
    Complex.persist( 'Other Bucket', storage_key ).should == complex_object
  end

  it "can put a rational number object to a persistence port and get it back" do
    rational_object = Rational( 42, 37 )
    storage_key     = Rational( 42, 420 )
    # test 1: default bucket
    rational_object.persist!( storage_key )
    Rational.persist( storage_key ).should == rational_object
    # test 2: specifying bucket
    rational_object.persist!( 'Other Bucket', storage_key )
    Rational.persist( 'Other Bucket', storage_key ).should == rational_object
  end

  it "can put a file object to a persistence port and get it back" do
    file_object_path  = 'lib/rpersistence/Rpersistence/Klass/Flat.rb'
    key_path          = 'lib/rpersistence/Rpersistence/Klass/Object.rb'
    file_object = File.open( file_object_path )
    storage_key = File.open( key_path )
    # test 1: default bucket
    file_object.persist!( storage_key )
    File.persist( storage_key ).should == File.open( file_object_path ).readlines.join( "\n" )
    # test 2: specifying bucket
    file_object.persist!( 'Other Bucket', storage_key )
    File.persist( 'Other Bucket', storage_key ).should == File.open( file_object_path ).readlines.join( "\n" )
  end

  it "can put a true object to a persistence port and get it back" do
    true_object = true
    storage_key = false
    # test 1: default bucket
    true_object.persist!( storage_key )
    TrueClass.persist( storage_key ).should == true_object
    # test 2: specifying bucket
    true_object.persist!( 'Other Bucket', storage_key )
    TrueClass.persist( 'Other Bucket', storage_key ).should == true_object
  end

  it "can put a false object to a persistence port and get it back" do
    false_object  = false
    storage_key   = true
    # test 1: default bucket
    false_object.persist!( storage_key )
    FalseClass.persist( storage_key ).should == false_object
    # test 2: specifying bucket
    false_object.persist!( 'Other Bucket', storage_key )
    FalseClass.persist( 'Other Bucket', storage_key ).should == false_object
  end

  # FIX - struct not yet supported

end