
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Object::Complex::UserObject
      include ::Persistence::Object
      attr_accessor :username, :firstname, :lastname
      attr_index    :username
    end

    class ::Persistence::Object::Complex::Address
      include ::Persistence::Object
      attr_accessor :number, :street, :city, :state, :zipcode
    end

    class ::Persistence::Object::Complex::HashContainerClass
      include ::Persistence::Object
      attr_accessor  :some_hash, :storage_key
      attr_index     :storage_key
    end

    class ::Persistence::Object::Complex::ArrayContainerClass
      include ::Persistence::Object
      attr_accessor  :array, :storage_key
      attr_index     :storage_key
    end

  end

  after :all do

    ::Persistence.disable_port( :mock )

  end

  it 'can persist complex objects' do
    class ::Persistence::Object::Complex::UserMock
      include ::Persistence::Object::Complex
      attr_non_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address
    end
    class ::Persistence::Object::Complex::AddressMock
      include ::Persistence::Object::Complex
      attr_non_atomic_accessor :number, :street, :city, :state, :zipcode
    end
    
    user = ::Persistence::Object::Complex::UserMock.new
    user.username   = 'user'
    user.firstname = 'first'
    user.lastname  = 'last'
  
    user.address = ::Persistence::Object::Complex::AddressMock.new
    user.address.number = 42
    user.address.street = 'Street'
    user.address.city = 'Some City'
    user.address.state = 'GA'
    user.address.zipcode = '30003'
  
    user.alternate_address = ::Persistence::Object::Complex::AddressMock.new
    user.alternate_address.number = 37
    user.alternate_address.street = 'Another Street'
    user.alternate_address.city = 'Some Other City'
    user.alternate_address.state = 'TX'
    user.alternate_address.zipcode = '70004'
    user.persist!
    
    ::Persistence::Object::Complex::UserMock.persist( user.persistence_id ).should == user
  
    user.alternate_address.number = 48
  
    user.alternate_address.persist!
  
    ::Persistence::Object::Complex::UserMock.persist( user.persistence_id ).should == user
    
  end
  
  ####################
  #  attr_flat       #
  #  persists_flat?  #
  #  attr_flat!      #
  ####################
  
  it 'can force storing a attribute as a flat object' do
    class ::Persistence::Object::Complex::AttrFlatMock
      
      class ClassInstance
        
        include ::Persistence::Object::Complex
  
        persists_flat?( :some_attribute ).should == nil
        attr_flat :some_attribute
        persists_flat?( :some_attribute ).should == true
        non_atomic_attributes[ :some_other_attribute ] = :accessor
        non_atomic_attributes[ :another_attribute ] = :accessor
        attr_flat!
        persists_flat?( :some_attribute ).should == true
        persists_flat?( :some_other_attribute ).should == true
        persists_flat?( :another_attribute ).should == true
        
      end
    end
  end
  
  ############
  #  cease!  #
  ############
  
  it 'can delete an object by ID' do
    module ::Persistence::Object::Complex::CeaseClassMock
  
      class ClassInstance
        include ::Persistence::Object::Complex
        attr_non_atomic_accessor :some_value, :some_other_value
      end
      
      instance = ClassInstance.new
      instance.some_value = :value
      instance.some_other_value = :other_value
      instance.persist!
      copy = ClassInstance.persist( instance.persistence_id )
      copy.should == instance
      ClassInstance.cease!( instance.persistence_id )
      ClassInstance.persist( instance.persistence_id ).should == nil
      
    end
  end
  
  ################################
  #  attr_index                  #
  #  attr_index_with_duplicates  #
  ################################
  
  it 'can create an index on a attribute' do
    class ::Persistence::Object::Complex::AttrIndexMock
  
      class ClassInstance
  
        include ::Persistence::Object::Complex
      
        attr_index  :attribute_index
        attr_index_with_duplicates  :attribute_index_with_duplicates
      
        has_attribute_index?( :attribute_index ).should == true
        has_index?( :attribute_index ).should == true
        has_attribute_index?( :attribute_index_with_duplicates ).should == true
        has_index?( :attribute_index_with_duplicates ).should == true
        index( :attribute_index ).is_a?( ::Persistence::Object::Index ).should == true
        index( :attribute_index_with_duplicates ).is_a?( ::Persistence::Object::Index ).should == true
  
      end
      
    end
  end
  
  ###################################
  #  attr_delete_cascades           #
  #  attr_delete_does_not_cascade   #
  #  delete_cascades?               #
  #  attr_delete_cascades!          #
  #  attr_delete_does_not_cascade!  #
  ###################################
  
  it 'can set an attribute to be deleted if self is deleted' do
    module ::Persistence::Object::Complex::DeleteCascadesMock
      
      class ObjectInstance
        include ::Persistence::Object::Complex
        attr_non_atomic_accessor :some_attribute, :cascading_attribute, :non_cascading_attribute, :complex_attribute
        attr_delete_cascades :some_attribute
        delete_cascades?( :some_attribute ).should == true
        attr_delete_does_not_cascade :some_attribute
        delete_cascades?( :some_attribute ).should == false
        attr_delete_cascades!
        delete_cascades?( :some_attribute ).should == true
        attr_delete_does_not_cascade!
        delete_cascades?( :some_attribute ).should == false
        attr_delete_cascades :cascading_attribute
        attr_delete_does_not_cascade :non_cascading_attribute
        delete_cascades?( :cascading_attribute ).should == true
        delete_cascades?( :non_cascading_attribute ).should == false
      end
      ObjectInstance.new.instance_eval do
        delete_cascades?( :cascading_attribute ).should == true
        delete_cascades?( :non_cascading_attribute ).should == false
        object = ObjectInstance.new
        object.persistence_bucket = persistence_bucket
        persistence_bucket.put_object!( self )
        persistence_bucket.put_attribute!( self, :complex_attribute, object )
        # FIX - still have to figure out details of this
  #      delete_cascades?( :complex_attribute ).should == true
      end
    
    end
  end
  
  ########
  #  ==  # 
  ########
  
  it 'can compare objects' do
    module ::Persistence::Object::Complex::EqualsMock
  
      class ObjectInstance
        include ::Persistence::Object::Complex
        attr_non_atomic_accessor :some_var, :some_other_var
      end
  
      # if we have the same ruby instance
      instance = ObjectInstance.new
      instance.persistence_id = 0
      ( instance == instance ).should == true
    
      # or if we have an id for both objects and the ids are not the same
      other_instance = ObjectInstance.new
      other_instance.persistence_id = 0
      yet_other_instance = ObjectInstance.new
      yet_other_instance.persistence_id = 1
      ( instance == other_instance ).should == true
      ( instance == yet_other_instance ).should == false
    
      # or if the classes are not the same
      ( instance == Object.new ).should == false
    
      # otherwise if we have instance variables, compare
      instance.instance_eval do
        self.some_var = :some_value
        self.persistence_id = nil
      end
      yet_other_instance.instance_eval do
        self.some_var = :some_value
        self.persistence_id = nil
      end
      ( instance == yet_other_instance ).should == true
      yet_other_instance.instance_eval do
        self.some_other_var = :some_other_value
      end
      ( instance == yet_other_instance ).should == false    
    
    end
  end
  
  ##############################
  #  persistence_hash_to_port  #
  ##############################
  
  it "can create a persistence hash to correspond to persistence state" do
    module ::Persistence::Object::Complex::PersistenceHashToPortMock
    
      class ObjectInstance
      
        include ::Persistence::Object::Complex
  
        attr_atomic_accessor           :flat_atomic_attribute
        attr_atomic_accessor           :complex_atomic_attribute
        attr_non_atomic_accessor       :flat_non_atomic_attribute
        attr_non_atomic_accessor       :complex_non_atomic_attribute
        attr_accessor                  :flat_non_persistent_attribute
        attr_accessor                  :complex_non_persistent_attribute
        attr_flat                      :flat_attribute
        attr_accessor                  :flat_non_persistent_attribute, :complex_non_persistent_attribute, :flat_attribute
            
        def persist!
          persistence_port.put_object!( self )
          return self
        end
      
      end
    
      instance = ObjectInstance.new
  
      # flat object for attribute and for variable
      instance.flat_atomic_attribute = 'flat atomic_attribute value'
      complex_atomic_element = ObjectInstance.new
      complex_atomic_element.flat_atomic_attribute = 'flat sub-atomic attribute'
      instance.complex_atomic_attribute = complex_atomic_element
  
      # complex object for attribute and for variable
      instance.flat_non_atomic_attribute = 'flat non_atomic_attribute value'
      complex_non_atomic_element = ObjectInstance.new
      complex_non_atomic_element.flat_atomic_attribute = 'flat sub-atomic attribute'
      instance.complex_non_atomic_attribute = complex_non_atomic_element
    
      # non-persistent value
      instance.flat_non_persistent_attribute = 'flat_non_persistent_attribute value'
      instance.complex_non_persistent_attribute = 'complex_non_persistent_attribute value'
    
      # flat complex object for attribute and for variable
      instance.flat_attribute = 'flat_attribute value'
    
      # get hash
      hash_to_port = instance.persistence_hash_to_port
  
      # make sure that flat atomic elements and non-atomic elements are included
      hash_to_port[ :flat_atomic_attribute ].should == 'flat atomic_attribute value'
      hash_to_port[ :flat_non_atomic_attribute ].should == 'flat non_atomic_attribute value'
    
      # make sure that complex objects are stored by ID
      hash_to_port[ :complex_atomic_attribute ].persistence_id.should == complex_atomic_element.persistence_id
      hash_to_port[ :complex_non_atomic_attribute ].persistence_id.should == complex_non_atomic_element.persistence_id
  
   end 
  end
  
  ###################
  #  get_attribute  #
  ###################
  
  it 'can serve as an adapter to a persistence bucket instance in an adapter instance' do
    module ::Persistence::Object::Complex::GetAttributeMock
  
      class ObjectInstance
        include ::Persistence::Object::Complex
        attr_non_atomic_accessor :simple_var, :complex_var
      end
      sub_object = ObjectInstance.new.instance_eval do
        self.simple_var = :value
        self
      end
      object = ObjectInstance.new.instance_eval do
        self.simple_var = :some_value
        self.complex_var = sub_object
        self
      end
      bucket_instance = object.persistence_port.persistence_bucket( :some_bucket )
      bucket_instance.put_object!( object )
      object.persistence_id.should_not == nil
      bucket_instance.get_attribute( object, :simple_var ).should == :some_value
      bucket_instance.get_attribute( object, :complex_var ).persistence_hash_to_port.should == sub_object.persistence_hash_to_port
      bucket_instance.delete_attribute!( object, :complex_var )
      bucket_instance.get_attribute( object, :complex_var ).should == nil
      bucket_instance.put_attribute!( object, :complex_var, sub_object )
      bucket_instance.get_attribute( object, :complex_var ).persistence_hash_to_port.should == sub_object.persistence_hash_to_port
  
    end
  end
  
  ####################################
  #  remove_atomic_attribute_values  #
  ####################################
  
  it 'can remove any instance variables that are defined as atomic attributes' do
    class ::Persistence::Object::Complex::PrivateMock
      include ::Persistence::Object::Complex
      attr_atomic_accessor :attribute1, :attribute2
    end
    ::Persistence::Object::Complex::PrivateMock.new.instance_eval do
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
    class ::Persistence::Object::Complex::Mock
      include ::Persistence::Object::Complex
      attr_atomic_accessor :attribute1, :attribute2
    end
    ::Persistence::Object::Complex::Mock.new.instance_eval do
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
    class ::Persistence::Object::Complex::Mock
      include ::Persistence::Object::Complex
      attr_atomic_accessor :atomic_attribute
      attr_non_atomic_accessor :non_atomic_attribute
    end
    # test without persistence id
    ::Persistence::Object::Complex::Mock.new.instance_eval do
      get_attribute( :atomic_attribute ).should == nil
      set_attribute( :atomic_attribute, :some_value )
      get_attribute( :atomic_attribute ).should == :some_value
    end
    
    # test with persistence id and non-atomic
    ::Persistence::Object::Complex::Mock.new.instance_eval do
      self.persistence_id = 0
      get_attribute( :non_atomic_attribute ).should == nil
      set_attribute( :non_atomic_attribute, :some_value )
      get_attribute( :non_atomic_attribute ).should == :some_value
    end
    
    # test with persistence id and atomic
    ::Persistence::Object::Complex::Mock.new.instance_eval do
      atomic_attribute?( :atomic_attribute ).should == true
      self.persistence_id = 1
      get_attribute( :atomic_attribute ).should == nil
      persistence_bucket.put_attribute!( self, :atomic_attribute, :some_value )
      get_attribute( :atomic_attribute ).should == :some_value
    end
  
    # test with persistence id and atomic
    ::Persistence::Object::Complex::Mock.new.instance_eval do
      atomic_attribute?( :atomic_attribute ).should == true
      self.persistence_id = 2
      get_attribute( :atomic_attribute ).should == nil
      instance = ::Persistence::Object::Complex::Mock.new
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
    class ::Persistence::Object::Complex::Mock
      include ::Persistence::Object::Complex
      attr_atomic_accessor :atomic_attribute
      attr_non_atomic_accessor :non_atomic_attribute
    end
  
    # test without persistence id and non-atomic
    ::Persistence::Object::Complex::Mock.new.instance_eval do
      attr_non_atomic_accessor :some_var
      get_attribute( :some_var ).should == nil
      set_attribute( :some_var, :some_value )
      get_attribute( :some_var ).should == :some_value
    end
  
    # test without persistence id and atomic
    ::Persistence::Object::Complex::Mock.new.instance_eval do
      attr_atomic_accessor :some_var
      get_attribute( :some_var ).should == nil
      set_attribute( :some_var, :some_value )
      get_attribute( :some_var ).should == :some_value
    end
    
    # test with persistence id and non-atomic
    ::Persistence::Object::Complex::Mock.new.instance_eval do
      attr_non_atomic_accessor :some_var
      self.persistence_id = 0
      get_attribute( :some_var ).should == nil
      set_attribute( :some_var, :some_value )
      persistence_port.persistence_bucket( persistence_bucket.name ).get_attribute( self, :some_other_var ).should == nil
      get_attribute( :some_var ).should == :some_value
    end
    
    # test with persistence id and atomic
    ::Persistence::Object::Complex::Mock.new.instance_eval do
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
    class ::Persistence::Object::Complex::PrivateMock
      include ::Persistence::Object::Complex
      attr_atomic_accessor :attribute1, :attribute2
    end
    ::Persistence::Object::Complex::PrivateMock.new.instance_eval do
      self.attribute1 = :value1
      self.attribute2 = :value2
      load_atomic_state
      @attribute1.should == :value1
      @attribute2.should == :value2
    end
  end
  
  it "can persist an object to and from a default bucket with an arbitrary key method" do
    module ::Persistence::Object::Complex::ArbitraryKeyMethodMock
      
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
      
      user = UserObject.new
      user.username   = 'user'
      user.firstname = 'first'
      user.lastname  = 'last'
      user.persist!
      UserObject.persist( :username => 'user' ).should == user
    
    end
  end
  
  it "can persist an object to and from a default bucket with an arbitrary key variable" do
    module ::Persistence::Object::Complex::ArbitraryKeyVariableMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
  
      user = UserObject.new
      user.username   = 'user'
      user.firstname = 'first'
      user.lastname  = 'last'
      user.persist!
      UserObject.persist( :username => 'user' ).should == user
    
    end
  end
  
  it "can persist an object with other objects as members" do
    module ::Persistence::Object::Complex::ArbitraryNestedObjectMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
        attr_accessor :username, :firstname, :lastname, :address, :alternate_address
        attr_index  :username
      end
      
      class Address < ::Persistence::Object::Complex::Address
        attr_accessor :number, :street, :city, :state, :zipcode
      end
  
      user = UserObject.new
      user.username   = 'user'
      user.firstname = 'first'
      user.lastname  = 'last'
  
      user.address = Address.new
      user.address.number = 42
      user.address.street = 'Street'
      user.address.city = 'Some City'
      user.address.state = 'GA'
      user.address.zipcode = '30003'
  
      user.alternate_address = Address.new
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
  
      UserObject.persist( :username => 'user' ).should == user
  
      user.alternate_address.number = 48
  
      user.alternate_address.persist!
  
      UserObject.persist( :username => 'user' ).should == user
  
    end
  end
  
  it "can persist an object with other objects as members that have atomic properties" do
    module ::Persistence::Object::Complex::NestedAtomicObjectsMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
        attr_accessor :username, :firstname, :lastname, :address, :alternate_address
        attr_index  :username
      end
  
      class Address < ::Persistence::Object::Complex::Address
        attr_accessor :number, :street, :city, :state, :zipcode
        attr_atomic_accessor :number
        attrs_atomic!
      end
  
      Address.atomic_attribute?( :number ).should == true
  
      user = UserObject.new
      user.username   = 'user'
      user.firstname = 'first'
      user.lastname  = 'last'
  
      user.address = Address.new
      user.address.number = 42
      user.address.street = 'Street'
      user.address.city = 'Some City'
      user.address.state = 'GA'
      user.address.zipcode = '30003'
  
      user.alternate_address = Address.new
      user.alternate_address.number = 37
      user.alternate_address.street = 'Another Street'
      user.alternate_address.city = 'Some Other City'
      user.alternate_address.state = 'TX'
      user.alternate_address.zipcode = '70004'
      user.persist!
  
      UserObject.persist( :username => 'user' ).should == user
  
      user.alternate_address.number = 48
  
      UserObject.persist( :username => 'user' ).should == user
    
    end
  end
  
  it "can persist an object with hash members" do
    module ::Persistence::Object::Complex::NestedHashesMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
      
      class HashContainerClass < ::Persistence::Object::Complex::HashContainerClass
      end
      
      class HashMock < ::Hash
      end
  
      hash_container                        = HashContainerClass.new
      hash_container.storage_key            = :hash_container
      hash_container.some_hash              = HashMock.new
      hash_container.some_hash[ :hash_key ] = :hash_data
    
      hash_container.persist!
      HashContainerClass.persist( :storage_key => :hash_container ).should == hash_container
    
    end
  end
  
  it "can persist an object with array members" do
    module ::Persistence::Object::Complex::NestedArraysMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
  
      class ArrayContainerClass < ::Persistence::Object::Complex::ArrayContainerClass
      end
      
      class ArrayMock < ::Array
      end
  
      storage_key                         = :array_container
      array_data                          = :array_data
      array_container                     = ArrayContainerClass.new
      array_container.storage_key         = storage_key
      array_container.array               = ArrayMock.new
      array_container.array.push( array_data )
    
      array_container.persist!
      ArrayContainerClass.persist( :storage_key => storage_key ).should == array_container
    
    end
  end
  
  ##############
  #  persist!  #
  #  persist   #
  ##############
  
  it "can persist an object to and from a default bucket with an arbitrary key method" do
    module ::Persistence::Object::Complex::PersistArbitraryKeyMethodMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
  
      user = UserObject.new
      user.username   = 'user'
      user.firstname = 'first'
      user.lastname  = 'last'
      user.persist!
      persisted_user = UserObject.persist( user.persistence_id )
      persisted_user.should == user
      persisted_user_two = UserObject.new
      persisted_user_two.persistence_id = persisted_user.persistence_id
      persisted_user_two.persist
      persisted_user_two.should == persisted_user
    end
    
  end
  
  it "can persist an object to and from a default bucket with an arbitrary key variable" do
    module ::Persistence::Object::Complex::PersistArbitraryKeyVariableMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
  
      user = UserObject.new
      user.username   = 'user'
      user.firstname = 'first'
      user.lastname  = 'last'
      user.persist!
      UserObject.persist( user.persistence_id ).should == user
      persisted_user_two = UserObject.new
      persisted_user_two.persistence_id = user.persistence_id
      persisted_user_two.persist
      persisted_user_two.should == user
  
    end
  end
  
  it "can persist an object with other objects as members" do
    module ::Persistence::Object::Complex::PersistNestedObjectsMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
        attr_non_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address
      end
  
      class Address < ::Persistence::Object::Complex::Address
        attr_non_atomic_accessor :number, :street, :city, :state, :zipcode
      end
  
      user = UserObject.new
      user.username   = 'user'
      user.firstname = 'first'
      user.lastname  = 'last'
  
      user.address = Address.new
      user.address.number = 42
      user.address.street = 'Street'
      user.address.city = 'Some City'
      user.address.state = 'GA'
      user.address.zipcode = '30003'
  
      user.alternate_address = Address.new
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
  
      UserObject.persist( user.persistence_id ).should == user
  
      user.alternate_address.number = 48
  
      user.alternate_address.persist!
  
      UserObject.persist( user.persistence_id ).should == user
  
    end
  end
  
  it "can persist an object with other objects as members that have atomic properties" do
    module ::Persistence::Object::Complex::PersistAtomicMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
        attr_non_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address
      end
  
      class Address < ::Persistence::Object::Complex::Address
        attr_non_atomic_accessor :number, :street, :city, :state, :zipcode
        attr_atomic_accessor :number
        attrs_atomic!
      end
    
      Address.atomic_attribute?( :number ).should == true
  
      user = UserObject.new
      user.username   = 'user'
      user.firstname = 'first'
      user.lastname  = 'last'
  
      user.address = Address.new
      user.address.number = 42
      user.address.street = 'Street'
      user.address.city = 'Some City'
      user.address.state = 'GA'
      user.address.zipcode = '30003'
  
      user.alternate_address = Address.new
      user.alternate_address.number = 37
      user.alternate_address.street = 'Another Street'
      user.alternate_address.city = 'Some Other City'
      user.alternate_address.state = 'TX'
      user.alternate_address.zipcode = '70004'
      user.persist!
  
      UserObject.persist( user.persistence_id ).should == user
  
      user.alternate_address.number = 48
  
      UserObject.persist( user.persistence_id ).should == user
  
    end
  end
  
  it "can persist an object with hash members" do
    module ::Persistence::Object::Complex::PersistNestedHashMembersMock

      class HashContainerClass < ::Persistence::Object::Complex::HashContainerClass
        attr_non_atomic_accessor :some_hash
      end

      class HashMock < ::Hash
        include ::Persistence::Object::Complex::Hash
      end

      hash_container = HashContainerClass.new
      hash_container.some_hash = HashMock.new
      hash_container.some_hash[ :hash_key ] = :hash_data
      hash_container.persist!
      HashContainerClass.persist( hash_container.persistence_id ).should == hash_container
    
    end
  end

  it "can persist an object with array members" do
    module ::Persistence::Object::Complex::PersistNestedArrayMembersMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
      
      class ArrayContainerClass < ::Persistence::Object::Complex::ArrayContainerClass
        attr_non_atomic_accessor :some_hash
      end
      
      class ArrayMock < ::Array
      end
  
      storage_key                         = :array_container
      array_data                          = :array_data
      array_container                     = ArrayContainerClass.new
      array_container.storage_key         = storage_key
      array_container.array               = ArrayMock.new
      array_container.array.push( array_data )
    
      array_container.persist!
      ArrayContainerClass.persist( array_container.persistence_id ).should == array_container
    
    end
  end
  
  ############
  #  cease!  #
  ############
  
  it 'can delete an object' do
    module ::Persistence::Object::Complex::CeaseObjectMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
  
      class MockObject
        include ::Persistence
        attr_non_atomic_accessor :some_value, :some_other_value
      end
      instance = MockObject.new
      instance.some_value = :value
      instance.some_other_value = :other_value
      instance.persist!
      copy = MockObject.persist( instance.persistence_id )
      copy.should == instance
      instance.cease!
      MockObject.persist( instance.persistence_id ).should == nil
  
    end
  end
  
  ######################
  #  persist!          #
  #  index_attributes  #
  #  persist           #
  ######################
  
  it 'indexes attributes during persist' do
    module ::Persistence::Object::Complex::PersistAndIndexAttributesMock
  
      class UserObject < ::Persistence::Object::Complex::UserObject
      end
  
      class MockObject
        include ::Persistence
        attr_non_atomic_accessor :attribute_index
        attr_index  :attribute_index
      end
      instance = MockObject.new
      instance.attribute_index = :some_value
      # should call index_attributes
      instance.persist!
      instance_copy = MockObject.persist( :attribute_index, :some_value )
      instance_copy.should == instance
      instance_copy_two = MockObject.new
      instance_copy_two.persist( :attribute_index, :some_value )
      instance_copy_two.should == instance
    
    end
  end

end
