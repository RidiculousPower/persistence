
Rpersistence::Specs::Configure  = 'Configure object persistence specs.'

describe Rpersistence do
  
  before( :all ) do
    rpersistence_open_for_spec
    rpersistence_enable_for_spec
  end

  after( :all ) do
    rpersistence_disable_for_spec
  end

  ##################################
  #  Klass.persist_by              #
  #  persist_by                    #
  #  Klass.persistence_key_source  #
  #  persistence_key_source        #
  ##################################
  
  it "can be configured to persist using a key from an arbitrary source (method or ivar)" do
    # test 1: method
    class User1
      persist_by :username
    end
    # test 1.1: class
    User1.persistence_key_source.should == :username
    # test 1.2: instance
    User1.new.persistence_key_source.should == :username
    # test 2: variable
    class User01
      persist_by :@username
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
      persist_by :username
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

  #############################
  #  Klass.attr_atomic        #
  #  attr_atomic              #
  #  Klass.atomic_attribute?  #
  #  atomic_attribute?        #
  #############################

  it "can set one or more attributes to be atomic" do
    class User3
      persist_by :username
      attr_atomic   :username
    end
    # test 1: class
    User3.atomic_attribute?( :username ).should == true
    User3.non_atomic_attribute?( :username ).should == false
    # test 2: instance
    user = User3.new
    user.atomic_attribute?( :username ).should == true    
    user.non_atomic_attribute?( :username ).should == false    
    # clear performs cleanup so tests don't stack
    User3.attr_clear( :username )
  end

  ####################################
  #  Klass.attr_atomic_reader        #
  #  attr_atomic_reader              #
  #  Klass.atomic_attribute_reader?  #
  #  atomic_attribute_reader?        #
  ####################################

  it "can set one or more attributes to read atomically" do
    class User4
      persist_by :username
      attr_atomic_reader  :username
    end
    # test 1: class
    User4.atomic_attribute_reader?( :username ).should == true
    # test 2: instance
    user = User4.new
    user.atomic_attribute_reader?( :username ).should == true    
    # clear performs cleanup so tests don't stack
    User4.attr_clear( :username )
  end

  ####################################
  #  Klass.attr_atomic_writer        #
  #  attr_atomic_writer              #
  #  Klass.atomic_attribute_writer?  #
  #  atomic_attribute_writer?        #
  ####################################

  it "can set one or more attributes to write atomically" do
    class User5
      persist_by :username
      attr_atomic_writer  :username
    end
    # test 1: class
    User5.atomic_attribute_writer?( :username ).should == true
    # test 2: instance
    user = User5.new
    user.atomic_attribute_writer?( :username ).should == true    
    # clear performs cleanup so tests don't stack
    User5.attr_clear( :username )
  end

  #################################
  #  Klass.attr_non_atomic        #
  #  attr_non_atomic              #
  #  Klass.non_atomic_attribute?  #
  #  non_atomic_attribute?        #
  #################################

  it "can set one or more attributes to be non-atomic" do
    class User6
      persist_by :username
      attr_non_atomic   :username
    end
    # test 1: class
    User6.non_atomic_attribute?( :username ).should == true
    User6.atomic_attribute?( :username ).should == false
    # test 2: instance
    user = User6.new
    user.non_atomic_attribute?( :username ).should == true    
    user.atomic_attribute?( :username ).should == false    
    # clear performs cleanup so tests don't stack
    User6.attr_clear( :username )
  end

  ########################################
  #  Klass.attr_non_atomic_reader        #
  #  attr_non_atomic_reader              #
  ########################################

  it "can set one or more attributes to read non-atomically" do
    class User7
      persist_by :username
      attr_non_atomic_reader  :username
    end
    # test 1: class
    User7.atomic_attribute_reader?( :username ).should == false
    # test 2: instance
    user = User7.new
    user.atomic_attribute_reader?( :username ).should == false    
    # clear performs cleanup so tests don't stack
    User7.attr_clear( :username )
  end

  ########################################
  #  Klass.attr_non_atomic_writer        #
  #  attr_non_atomic_writer              #
  ########################################

  it "can set one or more attributes to write non-atomically" do
    class User8
      persist_by :username
      attr_non_atomic_writer  :username
    end
    # test 1: class
    User8.atomic_attribute?( :username ).should == false
    # test 2: instance
    user = User8.new
    user.atomic_attribute?( :username ).should == false    
    # clear performs cleanup so tests don't stack
    User8.attr_clear( :username )
  end

  #############################
  #  Klass.attrs_atomic!      #
  #  attrs_atomic!            #
  #############################

  it "can set all attributes to be atomic" do
    class User9
      persist_by      :username
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
    
    # clear performs cleanup so tests don't stack
    User9.attr_clear( :username )
  end

  #############################
  #  Klass.attrs_non_atomic!  #
  #  attrs_non_atomic!        #
  #############################

  it "can set all attributes to be non-atomic" do
    class User10
      persist_by    :username
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
    stored_user     = User10.persist( user.username )
    stored_user.should_not == user

    # clear performs cleanup so tests don't stack
    User10.attr_clear( :username )
  end

  #####################################
  #  Klass.attr_non_persistent        #
  #  attr_non_persistent              #
  #  Klass.non_persistent_attribute?  #
  #  non_persistent_attribute?        #
  #####################################

  it "can set one or more attributes to be non-persistent" do
    class User11
      persist_by :username
      attr_accessor :username, :firstname
      attr_non_persistent  :username
    end
    # test 1: class
    User11.non_persistent_attribute?( :username ).should == true
    User11.persistent_attribute?( :username ).should == false
    # test 2: instance
    user = User11.new
    user.non_persistent_attribute?( :username ).should == true    
    user.persistent_attribute?( :username ).should == false    

    user.username   = 'someusername'
    user.firstname  = 'somename'
    user.persist!
    stored_user     = User11.persist( user.username )
    stored_user.should == user

    # clear performs cleanup so tests don't stack
    User11.attr_clear( :username )
  end

  ########################
  #  self.attr_required  #
  ########################

  # * attr_required   :accessor
  it "can set one or more attributes to be required (an error will be thrown at persist! if missing)" do

    
  end

  #########################
  #  self.attr_validator  #
  #########################

  # * attr_validator  :constraint_validation_method
  it "can set one or more attributes to have a validation method (an error will be thrown at persist! if validation method fails)" do
    
  end

  #######################################  Configuration Status  ############################################

  ######################
  #  Klass.persisted?  #
  #  persisted?        #
  ######################

  it "can report whether object has been persisted to a storage port" do
    
  end

  ######################
  #  Klass.is_atomic?  #
  #  is_atomic?        #
  ######################
  
  it "can report whether an attribute is atomic" do
    
  end

  ###############################
  #  Klass.persists_all_ivars?  #
  #  persists_all_ivars?        #
  ###############################

  it "can report whether object persists all instance variables" do
    
  end

  #################################
  #  Klass.non_atomic_attributes  #
  #  non_atomic_attributes        #
  #################################

  it "can return all non-atomic attributes" do
    
  end

  #################################
  #  Klass.persistent_attributes  #
  #  persistent_attributes        #
  #################################

  it "can return all persistent attributes (atomic or non-atomic)" do
    
  end

  ##############################################  Hooks  ####################################################

  #########################
  #  self.before_persist  #
  #########################

  it "can set a hook that will be called before persisting to a storage port" do
    
  end

  ########################
  #  self.after_persist  #
  ########################

  it "can set a hook that will be called after persisting to a storage port" do
    
  end

  ##############################################  Cease  ####################################################

  ##################
  #  Klass.cease!  #
  #  cease!        #
  ##################

  it "can cease persisting a persisted object" do
    
  end

	
end