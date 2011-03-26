
Rpersistence::Specs::Configure  = 'Configure object persistence specs.'

describe Rpersistence do
  
  before( :all ) do
    rpersistence_open_for_spec
    rpersistence_enable_for_spec
  end

  after( :all ) do
    rpersistence_disable_for_spec
  end

  ##############################################  Basics  ###################################################

  ##################################
  #  Klass.persists_by              #
  #  persists_by                    #
  #  Klass.persistence_key_source  #
  #  persistence_key_source        #
  ##################################
  
  it "can be configured to persist using a key from an arbitrary source (method or ivar)" do
    # test 1: method
    class User1
      persists_by :username
    end
    # test 1.1: class
    User1.persistence_key_source.should == :username
    # test 1.2: instance
    User1.new.persistence_key_source.should == :username
    # test 2: variable
    class User01
      persists_by :@username
    end
    # test 2.1: class
    User01.persistence_key_source.should == :@username
    # test 2.2: instance
    User01.new.persistence_key_source.should == :@username
  end
  
  ##############################
  #  Klass.store_as            #
  #  store_as                  #
  #  Klass.persistence_bucket  #
  #  persistence_bucket        #
  ##############################

  it "can be configured to store in an arbitrary storage bucket" do
    $other_bucket  = 'BucketOtherThanUser'
    class User2
      store_as $other_bucket
      persists_by :username
    end
    # test 1: class
    User2.persistence_bucket.should == $other_bucket
    # test 2: instance
    User2.new.persistence_bucket.should == $other_bucket
    user = User2.new
    $another_bucket = 'YetAnotherBucket'
    user.persistence_bucket = $another_bucket
    user.persistence_bucket.should == $another_bucket
  end

  #############################################  Atomicity  #################################################

  #############################
  #  Klass.attr_atomic        #
  #  attr_atomic              #
  #  Klass.atomic_attribute?  #
  #  atomic_attribute?        #
  #  Klass.atomic_attributes  #
  #  atomic_attributes        #
  #############################

  it "can set one or more attributes to be atomic" do
    # Test 1: method
    class User3
      persists_by :username
      attr_atomic   :username
      attr_atomic   :@firstname
    end
    # test 1.1: class
    User3.atomic_attribute?( :username ).should == true
    User3.non_atomic_attribute?( :username ).should == false
    # test 1.2: instance
    user = User3.new
    user.atomic_attribute?( :username ).should == true    
    user.non_atomic_attribute?( :username ).should == false    
    # test 1.3: variable
    User3.atomic_attribute?( :@username ).should == true
    User3.non_atomic_attribute?( :@username ).should == false
    user.atomic_attribute?( :@username ).should == true    
    user.non_atomic_attribute?( :@username ).should == false    
    # test 2.1: class
    User3.atomic_attribute?( :firstname ).should == true
    User3.non_atomic_attribute?( :firstname ).should == false
    User3.atomic_attributes.should == [ :username, :firstname ]
    # test 2.2: instance
    user = User3.new
    user.atomic_attribute?( :firstname ).should == true    
    user.non_atomic_attribute?( :firstname ).should == false    
    user.atomic_attributes.should == [ :username, :firstname ]
    # test 2.3: variable
    user.atomic_attribute?( :@firstname ).should == true    
    user.non_atomic_attribute?( :@firstname ).should == false    
  end

  ####################################
  #  Klass.attr_atomic_reader        #
  #  attr_atomic_reader              #
  #  Klass.atomic_attribute_reader?  #
  #  atomic_attribute_reader?        #
  ####################################

  it "can set one or more attributes to read atomically" do
    class User4
      persists_by :username
      attr_atomic_reader  :username
      attr_atomic_reader  :@firstname
    end
    # test 1.1: class
    User4.atomic_attribute_reader?( :username ).should == true
    User4.atomic_attribute_writer?( :username ).should == false
    User4.non_atomic_attribute_reader?( :username ).should == false
    User4.non_atomic_attribute_writer?( :username ).should == false
    # test 1.2: instance
    user = User4.new
    user.atomic_attribute_reader?( :username ).should == true    
    user.atomic_attribute_writer?( :username ).should == false    
    user.non_atomic_attribute_reader?( :username ).should == false    
    user.non_atomic_attribute_writer?( :username ).should == false    
    # test 1.3: variable
    User4.atomic_attribute_reader?( :@username ).should == true
    User4.atomic_attribute_writer?( :@username ).should == false
    User4.non_atomic_attribute_reader?( :@username ).should == false
    User4.non_atomic_attribute_writer?( :@username ).should == false
    user.atomic_attribute_reader?( :@username ).should == true    
    user.atomic_attribute_writer?( :@username ).should == false    
    user.non_atomic_attribute_reader?( :@username ).should == false    
    user.non_atomic_attribute_writer?( :@username ).should == false    
    # test 2.1: class
    User4.atomic_attribute_reader?( :firstname ).should == true
    User4.atomic_attribute_writer?( :firstname ).should == false
    User4.non_atomic_attribute_reader?( :firstname ).should == false
    User4.non_atomic_attribute_writer?( :firstname ).should == false
    # test 2.2: instance
    user = User4.new
    user.atomic_attribute_reader?( :firstname ).should == true    
    user.atomic_attribute_writer?( :firstname ).should == false    
    user.non_atomic_attribute_reader?( :firstname ).should == false    
    user.non_atomic_attribute_writer?( :firstname ).should == false    
    # test 2.3: variable
    User4.atomic_attribute_reader?( :@firstname ).should == true
    User4.atomic_attribute_writer?( :@firstname ).should == false
    User4.non_atomic_attribute_reader?( :@firstname ).should == false
    User4.non_atomic_attribute_writer?( :@firstname ).should == false
    user.atomic_attribute_reader?( :@firstname ).should == true    
    user.atomic_attribute_writer?( :@firstname ).should == false    
    user.non_atomic_attribute_reader?( :@firstname ).should == false    
    user.non_atomic_attribute_writer?( :@firstname ).should == false    
  end

  ####################################
  #  Klass.attr_atomic_writer        #
  #  attr_atomic_writer              #
  #  Klass.atomic_attribute_writer?  #
  #  atomic_attribute_writer?        #
  ####################################

  it "can set one or more attributes to write atomically" do
    class User5
      persists_by :username
      attr_atomic_writer  :username
      attr_atomic_writer  :@firstname
    end
    # test 1.1: class
    User5.atomic_attribute_writer?( :username ).should == true
    User5.atomic_attribute_reader?( :username ).should == false
    User5.non_atomic_attribute_writer?( :username ).should == false
    User5.non_atomic_attribute_reader?( :username ).should == false
    # test 1.2: instance
    user = User5.new
    user.atomic_attribute_writer?( :username ).should == true    
    user.atomic_attribute_reader?( :username ).should == false
    user.non_atomic_attribute_writer?( :username ).should == false    
    user.non_atomic_attribute_reader?( :username ).should == false
    # test 1.3: variable
    user.atomic_attribute_writer?( :@username ).should == true    
    user.atomic_attribute_reader?( :@username ).should == false
    user.non_atomic_attribute_writer?( :@username ).should == false    
    user.non_atomic_attribute_reader?( :@username ).should == false
    User5.atomic_attribute_writer?( :@username ).should == true
    User5.atomic_attribute_reader?( :@username ).should == false
    User5.non_atomic_attribute_writer?( :@username ).should == false
    User5.non_atomic_attribute_reader?( :@username ).should == false
    # test 2..2.: class
    User5.atomic_attribute_writer?( :firstname ).should == true
    User5.atomic_attribute_reader?( :firstname ).should == false
    User5.non_atomic_attribute_writer?( :firstname ).should == false
    User5.non_atomic_attribute_reader?( :firstname ).should == false
    # test 2..2: instance
    user = User5.new
    user.atomic_attribute_writer?( :firstname ).should == true    
    user.atomic_attribute_reader?( :firstname ).should == false
    user.non_atomic_attribute_writer?( :firstname ).should == false    
    user.non_atomic_attribute_reader?( :firstname ).should == false
    # test 2..3: variable
    user.atomic_attribute_writer?( :@firstname ).should == true    
    user.atomic_attribute_reader?( :@firstname ).should == false
    user.non_atomic_attribute_writer?( :@firstname ).should == false    
    user.non_atomic_attribute_reader?( :@firstname ).should == false
    User5.atomic_attribute_writer?( :@firstname ).should == true
    User5.atomic_attribute_reader?( :@firstname ).should == false
    User5.non_atomic_attribute_writer?( :@firstname ).should == false
    User5.non_atomic_attribute_reader?( :@firstname ).should == false
  end

  #################################
  #  Klass.attr_non_atomic        #
  #  attr_non_atomic              #
  #  Klass.non_atomic_attribute?  #
  #  non_atomic_attribute?        #
  #  Klass.non_atomic_attributes  #
  #  non_atomic_attributes        #
  #################################

  it "can set one or more attributes to be non-atomic" do
    class User6
      persists_by :username
      attr_non_atomic   :username
      attr_non_atomic   :@firstname
    end
    # test 1.1: class
    User6.non_atomic_attribute?( :username ).should == true
    User6.atomic_attribute?( :username ).should == false
    # test 1.2: instance
    user = User6.new
    user.non_atomic_attribute?( :username ).should == true    
    user.atomic_attribute?( :username ).should == false    
    # test 1.3: variable
    User6.non_atomic_attribute?( :@username ).should == true
    User6.atomic_attribute?( :@username ).should == false
    user.non_atomic_attribute?( :@username ).should == true    
    user.atomic_attribute?( :@username ).should == false    
    # test 2.1: class
    User6.non_atomic_attribute?( :firstname ).should == true
    User6.atomic_attribute?( :firstname ).should == false
    # test 2.2: instance
    user = User6.new
    user.non_atomic_attribute?( :firstname ).should == true    
    user.atomic_attribute?( :firstname ).should == false    
    # test 2.3: variable
    User6.non_atomic_attribute?( :@firstname ).should == true
    User6.atomic_attribute?( :@firstname ).should == false
    User6.non_atomic_attributes.should == [ :username, :firstname ]
    user.non_atomic_attribute?( :@firstname ).should == true    
    user.atomic_attribute?( :@firstname ).should == false
    user.non_atomic_attributes.should == [ :username, :firstname ]
  end

  ########################################
  #  Klass.attr_non_atomic_reader        #
  #  attr_non_atomic_reader              #
  ########################################

  it "can set one or more attributes to read non-atomically" do
    class User7
      persists_by :username
      attr_non_atomic_reader  :username
      attr_non_atomic_reader  :@firstname
      non_atomic_attribute_writer?( :username ).should == false
    end
    # test 1.1: class
    User7.non_atomic_attribute_reader?( :username ).should == true
    User7.non_atomic_attribute_writer?( :username ).should == false
    User7.atomic_attribute_reader?( :username ).should == false
    User7.atomic_attribute_writer?( :username ).should == false
    # test 1.2: instance
    user = User7.new
    user.non_atomic_attribute_reader?( :username ).should == true 
    user.non_atomic_attribute_writer?( :username ).should == false 
    user.atomic_attribute_reader?( :username ).should == false    
    user.atomic_attribute_writer?( :username ).should == false    
    # test 1.3: variable
    user.non_atomic_attribute_reader?( :@username ).should == true 
    user.non_atomic_attribute_writer?( :@username ).should == false 
    user.atomic_attribute_reader?( :@username ).should == false    
    user.atomic_attribute_writer?( :@username ).should == false    
    User7.non_atomic_attribute_reader?( :@username ).should == true
    User7.non_atomic_attribute_writer?( :@username ).should == false
    User7.atomic_attribute_reader?( :@username ).should == false
    User7.atomic_attribute_writer?( :@username ).should == false
    # test 2.1: class
    User7.non_atomic_attribute_reader?( :firstname ).should == true
    User7.non_atomic_attribute_writer?( :firstname ).should == false
    User7.atomic_attribute_reader?( :firstname ).should == false
    User7.atomic_attribute_writer?( :firstname ).should == false
    # test 2.2: instance
    user = User7.new
    user.non_atomic_attribute_reader?( :firstname ).should == true 
    user.non_atomic_attribute_writer?( :firstname ).should == false 
    user.atomic_attribute_reader?( :firstname ).should == false    
    user.atomic_attribute_writer?( :firstname ).should == false    
    # test 2.3: variable
    user.non_atomic_attribute_reader?( :@firstname ).should == true 
    user.non_atomic_attribute_writer?( :@firstname ).should == false 
    user.atomic_attribute_reader?( :@firstname ).should == false    
    user.atomic_attribute_writer?( :@firstname ).should == false    
    User7.non_atomic_attribute_reader?( :@firstname ).should == true
    User7.non_atomic_attribute_writer?( :@firstname ).should == false
    User7.atomic_attribute_reader?( :@firstname ).should == false
    User7.atomic_attribute_writer?( :@firstname ).should == false
  end

  ########################################
  #  Klass.attr_non_atomic_writer        #
  #  attr_non_atomic_writer              #
  ########################################

  it "can set one or more attributes to write non-atomically" do
    class User8
      persists_by :username
      attr_non_atomic_writer  :username
      attr_non_atomic_writer  :@firstname
    end
    # test 1.1: class
    User8.non_atomic_attribute_writer?( :username ).should == true
    User8.non_atomic_attribute_reader?( :username ).should == false
    User8.atomic_attribute_reader?( :username ).should == false
    User8.atomic_attribute_writer?( :username ).should == false
    # test 1.2: instance
    user = User8.new
    user.non_atomic_attribute_writer?( :username ).should == true 
    user.non_atomic_attribute_reader?( :username ).should == false 
    user.atomic_attribute_reader?( :username ).should == false    
    user.atomic_attribute_writer?( :username ).should == false    
    # test 1.3: variable
    user.non_atomic_attribute_writer?( :@username ).should == true 
    user.non_atomic_attribute_reader?( :@username ).should == false 
    user.atomic_attribute_reader?( :@username ).should == false    
    user.atomic_attribute_writer?( :@username ).should == false    
    User8.non_atomic_attribute_writer?( :@username ).should == true
    User8.non_atomic_attribute_reader?( :@username ).should == false
    User8.atomic_attribute_reader?( :@username ).should == false
    User8.atomic_attribute_writer?( :@username ).should == false
    # test 2.1: class
    User8.non_atomic_attribute_writer?( :firstname ).should == true
    User8.non_atomic_attribute_reader?( :firstname ).should == false
    User8.atomic_attribute_reader?( :firstname ).should == false
    User8.atomic_attribute_writer?( :firstname ).should == false
    # test 2.2: instance
    user = User8.new
    user.non_atomic_attribute_writer?( :firstname ).should == true 
    user.non_atomic_attribute_reader?( :firstname ).should == false 
    user.atomic_attribute_reader?( :firstname ).should == false    
    user.atomic_attribute_writer?( :firstname ).should == false    
    # test 2.3: variable
    user.non_atomic_attribute_writer?( :@firstname ).should == true 
    user.non_atomic_attribute_reader?( :@firstname ).should == false 
    user.atomic_attribute_reader?( :@firstname ).should == false    
    user.atomic_attribute_writer?( :@firstname ).should == false    
    User8.non_atomic_attribute_writer?( :@firstname ).should == true
    User8.non_atomic_attribute_reader?( :@firstname ).should == false
    User8.atomic_attribute_reader?( :@firstname ).should == false
    User8.atomic_attribute_writer?( :@firstname ).should == false
  end

  #############################
  #  Klass.attrs_atomic!      #
  #  attrs_atomic!            #
  #############################

  it "can set all attributes to be atomic" do
    class User9
      persists_by      :username
      attr_atomic     :firstname
      attr_non_atomic :username
      attrs_atomic!
    end
    # test 1: class
    User9.atomic_attribute?( :username ).should == true
    User9.non_atomic_attribute?( :username ).should == false
    # test 2: instance
    user = User9.new
    user.atomic_attribute?( :username ).should == true    
    user.non_atomic_attribute?( :username ).should == false

    user.username   = 'someusername'
    user.firstname  = 'somename'

    user.persist!

    user.firstname  = 'anothername'
    
    stored_user     = User9.persist( user.username )
    stored_user.should == user
    
  end

  #############################
  #  Klass.attrs_non_atomic!  #
  #  attrs_non_atomic!        #
  #  Klass.persisted?         #
  #  persisted?               #
  #############################

  it "can set all attributes to be non-atomic" do
    class User10
      persists_by    :username
      attr_accessor :username, :firstname
      attr_atomic   :username, :firstname
      attrs_non_atomic!
    end
    # test 1: class
    User10.non_atomic_attribute?( :username ).should == true
    User10.atomic_attribute?( :username ).should == false
    # test 2: instance
    user = User10.new
    user.non_atomic_attribute?( :username ).should == true    
    user.atomic_attribute?( :username ).should == false    

    user.username   = 'someusername'
    user.firstname  = 'somename'
    user.persist!
    user.firstname  = 'anothername'
    User10.persisted?( user.username ).should == true
    stored_user     = User10.persist( user.username )
    stored_user.persisted?.should == true
    stored_user.should_not == user

  end

  #####################################
  #  Klass.attr_non_persistent        #
  #  attr_non_persistent              #
  #  Klass.non_persistent_attribute?  #
  #  non_persistent_attribute?        #
  #  Klass.persistent_attributes      #
  #  persistent_attributes            #
  #  Klass.non_persistent_attributes  #
  #  non_persistent_attributes        #
  #####################################

  it "can set one or more attributes to be non-persistent" do

    class User11
      persists_by            :username
      attr_atomic           :username, :firstname
      attr_non_persistent   :firstname
      attr_accessor         :firstname
    end
    # test 1: class
    User11.non_persistent_attribute?( :username ).should == false
    User11.persistent_attribute?( :username ).should == true
    User11.non_persistent_attribute?( :firstname ).should == true
    User11.persistent_attribute?( :firstname ).should == false
    User11.non_persistent_attributes.should == [ :firstname ]
    User11.persistent_attributes.should == [ :username ]
    # test 2: instance
    user = User11.new
    user.non_persistent_attribute?( :username ).should == false    
    user.persistent_attribute?( :username ).should == true    
    user.non_persistent_attribute?( :firstname ).should == true    
    user.persistent_attribute?( :firstname ).should == false    
    user.non_persistent_attributes.should == [ :firstname ]
    user.persistent_attributes.should == [ :username ]

    user.username   = 'someusername'
    user.firstname  = 'somename'
    user.persist!
    stored_user     = User11.persist( user.username )
    stored_user.should == user

  end

  #######################################
  #  Klass.persists_atomic_by_default   #
  #  persists_atomic_by_default!        #
  #  Klass.persists_atomic_by_default?  #
  #  persists_atomic_by_default?        #
  #######################################

  it "can set all attributes to be atomic" do

    class User12
      persists_atomic_by_default!
      persists_by                 :username
      attr_accessor               :firstname, :username
    end
    # test 1: class
    User12.persists_atomic_by_default?.should == true
    # test 2: instance
    user = User12.new
    user.persists_atomic_by_default?.should == true

    user.username   = 'someusername'
    user.firstname  = 'somename'

    user.persist!

    user.firstname  = 'anothername'
    
    stored_user     = User12.persist( user.username )
    stored_user.should == user
  
  end

  ############################################  Constraints  ################################################

  ########################
  #  self.attr_required  #
  ########################

  # * attr_required   :accessor
  it "can set one or more attributes to be required (an error will be thrown at persist! if missing)" do

    
  end

  ##########################
  #  self.attr_constraint  #
  ##########################

  # * attr_constraint  :constraint_validation_method
  it "can set one or more attributes to have a validation method (an error will be thrown at persist! if validation method fails)" do
    
  end

  ##############################################  Hooks  ####################################################

  ####################
  #  before_persist  #
  ####################

  it "can set a hook that will be called before persisting to a storage port" do
    
  end

  ###################
  #  after_persist  #
  ###################

  it "can set a hook that will be called after persisting to a storage port" do
    
  end

  ############################
  #  before_atomic_accessor  #
  ############################

  it "can set a hook that will be called before persisting to a storage port" do
    
  end

  ##########################
  #  before_atomic_reader  #
  ##########################

  it "can set a hook that will be called before persisting to a storage port" do
    
  end

  ##########################
  #  before_atomic_writer  #
  ##########################

  it "can set a hook that will be called before persisting to a storage port" do
    
  end

  ###########################
  #  after_atomic_accessor  #
  ###########################

  it "can set a hook that will be called before persisting to a storage port" do
    
  end

  #########################
  #  after_atomic_reader  #
  #########################

  it "can set a hook that will be called before persisting to a storage port" do
    
  end

  #########################
  #  after_atomic_writer  #
  #########################

  it "can set a hook that will be called after persisting to a storage port" do
    
  end

	
end