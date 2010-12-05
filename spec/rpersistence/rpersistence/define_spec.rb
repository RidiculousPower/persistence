
describe Rpersistence::Define do

  ##############################
  #  self.persist_by           #
  #  self.persist_declared_by  #
  ##############################

  ##################
  #  self.atomic!  #
  ##################

  it "can declare all of its attributes atomic" do

    class TestClass
      attr_accessor   :unique_id, :atomic_value
      persist_by      :unique_id
      atomic!
    end
    test_instance = TestClass.new
    test_instance.unique_id = 'unique object id'
    test_instance.persist
    TestClass.persist( test_instance.unique_id ).atomic_value.should == nil
    test_instance.atomic_value = 'some value'
    TestClass.persist( test_instance.unique_id ).atomic_value.should == test_instance.atomic_value

  end

  ######################
  #  self.attr_atomic  #
  ######################

  it "can declare atomic accessors" do

    class TestClass
      attr_accessor   :unique_id, :atomic_value
      persist_by      :unique_id
      attr_atomic :atomic_value
    end
    test_instance = TestClass.new
    test_instance.unique_id = 'unique object id'
    test_instance.persist!
    TestClass.persist( test_instance.unique_id ).atomic_value.should == nil
    test_instance.atomic_value = 'some value'
    TestClass.persist( test_instance.unique_id ).atomic_value.should == test_instance.atomic_value
    
  end

  #############################
  #  self.attr_atomic_getter  #
  #############################

  it "can declare atomic getters" do

    class TestClass
      attr_accessor   :unique_id, :atomic_value
      persist_by      :unique_id
      attr_atomic_getter   :atomic_value
    end
    test_instance = TestClass.new
    test_instance.unique_id = 'unique object id'
    test_instance.persist!
    test_intance_two  = TestClass.persist( test_instance.unique_id )
    test_intance_two.atomic_value.should == nil
    test_instance.atomic_value = 'some value'
    test_intance_two.atomic_value.should == test_instance.atomic_value
    
  end
  
  #############################
  #  self.attr_atomic_setter  #
  #############################

  it "can declare atomic setters" do

    class TestClass
      attr_accessor   :unique_id, :atomic_value
      persist_by      :unique_id
      attr_atomic_setter   :atomic_value
    end
    test_instance = TestClass.new
    test_instance.unique_id = 'unique object id'
    test_instance.persist!
    test_intance_two  = TestClass.persist( test_instance.unique_id )
    test_intance_two.atomic_value.should == nil
    test_instance.atomic_value = 'some value'
    test_intance_two.atomic_value.should == nil
    TestClass.persist( test_instance.unique_id ).should == test_instance.atomic_value

  end

  ######################
  #  self.non_atomic!  #
  ######################

  it "can declare all of its attributes non-atomic" do

    class TestClass
      attr_accessor     :unique_id, :atomic_value
      persist_by        :unique_id
      attr_atomic   :atomic_value
      non_atomic!
    end
    test_instance = TestClass.new
    test_instance.unique_id = 'unique object id'
    test_instance.persist!
    test_intance_two  = TestClass.persist( test_instance.unique_id )
    test_intance_two.atomic_value.should == nil
    test_instance.atomic_value = 'some value'
    test_intance_two.atomic_value.should == nil

  end

  ##########################
  #  self.attr_non_atomic  #
  ##########################

  it "can declare non-atomic accessors" do

    class TestClass
      attr_accessor         :unique_id, :atomic_value
      persist_by            :unique_id
      attr_atomic_getter         :atomic_value
      attr_non_atomic   :atomic_value
    end
    test_instance = TestClass.new
    test_instance.unique_id = 'unique object id'
    test_instance.persist!
    test_intance_two  = TestClass.persist( test_instance.unique_id )
    test_intance_two.atomic_value.should == nil
    test_instance.atomic_value = 'some value'
    test_intance_two.atomic_value.should == nil

  end

  #################################
  #  self.attr_non_atomic_getter  #
  #################################

  it "can declare non-atomic getters" do

    class TestClass
      attr_accessor         :unique_id, :atomic_value
      persist_by            :unique_id
      attr_atomic_getter         :atomic_value
      attr_non_atomic_getter     :atomic_value
    end
    test_instance = TestClass.new
    test_instance.unique_id = 'unique object id'
    test_instance.persist!
    test_intance_two  = TestClass.persist( test_instance.unique_id )
    test_intance_two.atomic_value.should == nil
    test_instance.atomic_value = 'some value'
    test_intance_two.atomic_value.should == nil

  end
  
  #################################
  #  self.attr_non_atomic_setter  #
  #################################

  it "can declare non-atomic setters" do

    class TestClass
      attr_accessor       :unique_id, :atomic_value
      persist_by          :unique_id
      attr_atomic_setter       :atomic_value
      attr_non_atomic_setter   :atomic_value
    end
    test_instance = TestClass.new
    test_instance.unique_id = 'unique object id'
    test_instance.persist!
    test_intance_two  = TestClass.persist( test_instance.unique_id )
    test_intance_two.atomic_value.should == nil
    test_instance.atomic_value = 'some value'
    test_intance_two.atomic_value.should == nil
    TestClass.persist( test_instance.unique_id ).should == nil

  end
  
  ################################################################################
  #  self.attr_shared( class, attr_shared_name )                                 #
  #  self.attr_shared( class, attr_shared_name, local_attribute_alias )          #
  ################################################################################
  
  it "can share attributes between classes; this implies an atomic operation for both classes, even if not otherwise specified" do
    
  end
  
  ####################################################################################################################################
  #  self.attr_share( class, :attr_shared_name, ... )                                                                                #
  #  self.attr_share( class, :attr_shared_name => :local_attribute_alias, ... )                                                      #
  #  self.attr_share( class, :attr_shared_name, ... ) { { :attr_shared_name => :local_attribute_alias } }                            #
  #  self.attr_share( class, :attr_shared_name => :local_attribute_alias, ... ) { { :attr_shared_name => :local_attribute_alias } }  #
  ####################################################################################################################################

  it "can share multiple attributes between classes in a single call" do
    
  end

  it "can share multiple attributes between classes in a single call with in-line name mapping" do
    
  end

  it "can share multiple attributes between classes in a single call with name mapping provided by block iteration" do
    
  end

  it "can share multiple attributes between classes in a single call with name mapping provided by a hash returned in a block" do
    
  end

  #########################################################################################################
  #  self.attr_share!( class, ... )                                                                       #
  #  self.attr_share!( class ) { { :attr_shared_name => :local_attribute_alias } }                        #
  #  self.attr_share!( class, ... ) { { ClassName => { :attr_shared_name => :local_attribute_alias } } }  #
  #########################################################################################################
  
  it "can implicitly share all attributes from another class" do
    
  end

  ################################
  #  self.attr_merge_like_hash!  #
  ################################
  
  it "can auto-configure merge method to merge properties from B to A like Hash#merge" do
    
  end

  ########################
  #  delete_cascades_to  #
  ########################
  
  # * delete_cascades_to  :accessor

  it "" do
    
  end

  #####################
  #  delete_excludes  #
  #####################

  # * delete_excludes     :accessor

  it "" do
    
  end

  ###################
  #  attr_required  #
  ###################

  # * attr_required   :accessor

  it "" do
    
  end

  ####################
  #  attr_validator  #
  ####################

  # * attr_validator  :constraint_validation_method

  it "" do
    
  end

  ####################
  #  before_persist  #
  ####################

  it "" do
    
  end

  ###################
  #  after_persist  #
  ###################

  it "" do
    
  end

  #####################
  #  before_persist!  #
  #####################

  it "" do
    
  end

  ####################
  #  after_persist!  #
  ####################

  it "" do
    
  end


  ########################
  #  version_controller  #
  ########################
  
  it "can manage versions" do
    
  end
   
end




# view permissions for specific users (so certain content only shows up for certain users/groups)
