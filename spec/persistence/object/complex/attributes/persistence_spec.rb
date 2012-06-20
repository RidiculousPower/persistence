
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Attributes::Persistence do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ###########################################################################################################
  #   private ###############################################################################################
  ###########################################################################################################

  ####################################
  #  remove_atomic_attribute_values  #
  ####################################
  
  it 'can remove any instance variables that are defined as atomic attributes' do
    class ::Persistence::Object::Complex::Attributes::Persistence::PrivateMock
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      attr_atomic_accessor :attribute1, :attribute2
    end
    ::Persistence::Object::Complex::Attributes::Persistence::PrivateMock.new.instance_eval do
      self.attribute1 = :value1
      self.attribute2 = :value2
      remove_atomic_attribute_values
      self.class::Controller.default_encapsulation.has_configuration_value?( self, :attribute1 ).should == false
      self.class::Controller.default_encapsulation.has_configuration_value?( self, :attribute2 ).should == false
    end
  end
  ########################
  #  is_complex_object?  #
  ########################

  it 'can report whether an object should be treated as complex' do
    class ::Persistence::Object::Complex::Attributes::Persistence::Mock
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      attr_atomic_accessor :attribute1, :attribute2
    end
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      is_complex_object?( 2**64 ).should == false                                                                          # Bignum
      is_complex_object?( 2 ).should == false                                                                              # Fixnum
      is_complex_object?( Complex( 2, 3 ) ).should == false                                                                # Complex
      is_complex_object?( Rational( 2, 3 ) ).should == false                                                               # Rational
      is_complex_object?( true ).should == false                                                                           # TrueClass
      is_complex_object?( false ).should == false                                                                          # FalseClass
      is_complex_object?( 'some string' ).should == false                                                                  # String
      is_complex_object?( :some_symbol ).should == false                                                                   # Symbol
      is_complex_object?( /some_string/ ).should == false                                                                  # Regexp
      is_complex_object?( File.new( '.' ) ).should == false                                                                # File
      is_complex_object?( ::Persistence::Object::Flat::File::Path.new( '/some/path' ) ).should == false                         # File::Path
      is_complex_object?( ::Persistence::Object::Flat::File::Contents.new( 'some file contents' ) ).should == false            # File::Contents
      is_complex_object?( nil ).should == false                                                                            # NilClass
      is_complex_object?( Object.new ).should == true                                                                      # Object
    end
  end

  ###########################################################################################################
  #   public ################################################################################################
  ###########################################################################################################

  ###################
  #  get_attribute  #
  #  set_attribute  #
  ###################

  it 'can get a variable atomically if appropriate' do
    class ::Persistence::Object::Complex::Attributes::Persistence::Mock
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      attr_atomic_accessor :atomic_attribute
      attr_non_atomic_accessor :non_atomic_attribute
    end
    # test without persistence id
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      get_attribute( :atomic_attribute ).should == nil
      set_attribute( :atomic_attribute, :some_value )
      get_attribute( :atomic_attribute ).should == :some_value
    end
    
    # test with persistence id and non-atomic
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      self.persistence_id = 0
      get_attribute( :non_atomic_attribute ).should == nil
      set_attribute( :non_atomic_attribute, :some_value )
      get_attribute( :non_atomic_attribute ).should == :some_value
    end
    
    # test with persistence id and atomic
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      atomic_attribute?( :atomic_attribute ).should == true
      self.persistence_id = 1
      get_attribute( :atomic_attribute ).should == nil
      persistence_bucket.put_attribute!( self, :atomic_attribute, :some_value )
      get_attribute( :atomic_attribute ).should == :some_value
    end

    # test with persistence id and atomic
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      atomic_attribute?( :atomic_attribute ).should == true
      self.persistence_id = 2
      get_attribute( :atomic_attribute ).should == nil
      instance = ::Persistence::Object::Complex::Attributes::Persistence::Mock.new
      # we don't want our port value; we give it the wrong value to make sure
      persistence_port.persistence_bucket( persistence_bucket.name ).put_attribute!( self, :atomic_attribute, instance )
      get_attribute( :atomic_attribute ).should == instance
      get_attribute( :non_atomic_attribute ).should == nil
      set_attribute( :non_atomic_attribute, :some_other_value )
      # we don't want our port value; we give it the wrong value to make sure
      persistence_port.persistence_bucket( persistence_bucket.name ).put_attribute!( self, :non_atomic_attribute, :not_some_other_value )
      get_attribute( :non_atomic_attribute ).should == :some_other_value
    end
    
  end

  ###################
  #  set_attribute  #
  ###################

  it 'can set a variable atomically if appropriate' do
    class ::Persistence::Object::Complex::Attributes::Persistence::Mock
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Persistence
      include ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      attr_atomic_accessor :atomic_attribute
      attr_non_atomic_accessor :non_atomic_attribute
    end

    # test without persistence id and non-atomic
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      attr_non_atomic_accessor :some_var
      get_attribute( :some_var ).should == nil
      set_attribute( :some_var, :some_value )
      get_attribute( :some_var ).should == :some_value
    end

    # test without persistence id and atomic
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      attr_atomic_accessor :some_var
      get_attribute( :some_var ).should == nil
      set_attribute( :some_var, :some_value )
      get_attribute( :some_var ).should == :some_value
    end
    
    # test with persistence id and non-atomic
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      attr_non_atomic_accessor :some_var
      self.persistence_id = 0
      get_attribute( :some_var ).should == nil
      set_attribute( :some_var, :some_value )
      persistence_port.persistence_bucket( persistence_bucket.name ).get_attribute( self, :some_other_var ).should == nil
      get_attribute( :some_var ).should == :some_value
    end
    
    # test with persistence id and atomic
    ::Persistence::Object::Complex::Attributes::Persistence::Mock.new.instance_eval do
      attr_atomic_accessor :some_var
      self.persistence_id = 0
      get_attribute( :some_var ).should == nil
      set_attribute( :some_var, :some_value )
      persistence_port.persistence_bucket( persistence_bucket.name ).get_attribute( self, :some_var ).should == :some_value
      get_attribute( :some_var ).should == :some_value
    end
    
  end

  #######################
  #  load_atomic_state  #
  #######################

  it 'can load values for atomic state ' do
    class ::Persistence::Object::Complex::Attributes::Persistence::PrivateMock
      # mock get_attribute
      def get_attribute( variable )
        instance_variable_value = nil
        case variable
          when :attribute1
            instance_variable_value = :value1
          when :attribute2
            instance_variable_value = :value2
        end
        return instance_variable_value
      end
    end
    ::Persistence::Object::Complex::Attributes::Persistence::PrivateMock.new.instance_eval do
      load_atomic_state
      @attribute1.should == :value1
      @attribute2.should == :value2
    end
  end

end
