
describe Rpersistence::Define do

  ##############################
  #  self.persist_by           #
  #  self.persist_declared_by  #
  ##############################

  ########################
  #  self.attrs_atomic!  #
  ########################

  it "can declare all of its attributes atomic" do

    class TestClass
      attr_accessor   :unique_id, :atomic_value
      persist_by      :unique_id
      attrs_atomic!
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
  #  self.attr_atomic_reader  #
  #############################

  it "can declare atomic readers" do

    class TestClass
      attr_accessor   :unique_id, :atomic_value
      persist_by      :unique_id
      attr_atomic_reader   :atomic_value
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
  #  self.attr_atomic_writer  #
  #############################

  it "can declare atomic writers" do

    class TestClass
      attr_accessor   :unique_id, :atomic_value
      persist_by      :unique_id
      attr_atomic_writer   :atomic_value
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

  ############################
  #  self.attrs_non_atomic!  #
  ############################

  it "can declare all of its attributes non-atomic" do

    class TestClass
      attr_accessor     :unique_id, :atomic_value
      persist_by        :unique_id
      attr_atomic   :atomic_value
      attrs_non_atomic!
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
      attr_atomic_reader         :atomic_value
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
  #  self.attr_non_atomic_reader  #
  #################################

  it "can declare non-atomic readers" do

    class TestClass
      attr_accessor         :unique_id, :atomic_value
      persist_by            :unique_id
      attr_atomic_reader         :atomic_value
      attr_non_atomic_reader     :atomic_value
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
  #  self.attr_non_atomic_writer  #
  #################################

  it "can declare non-atomic writers" do

    class TestClass
      attr_accessor       :unique_id, :atomic_value
      persist_by          :unique_id
      attr_atomic_writer       :atomic_value
      attr_non_atomic_writer   :atomic_value
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
  
  ####################################################################################################################################
  #  self.attr_share( class, :attr_shared_name, ... )                                                                                #
  #  self.attr_share( class, :attr_shared_name => :local_attribute_alias, ... )                                                      #
  #  self.attr_share( class, :attr_shared_name, ... ) { { :attr_shared_name => :local_attribute_alias } }                            #
  #  self.attr_share( class, :attr_shared_name => :local_attribute_alias, ... ) { { :attr_shared_name => :local_attribute_alias } }  #
  ####################################################################################################################################

  it "can share attributes between classes; this implies an atomic operation for both classes, even if not otherwise specified" do
    
  end

  it "can share multiple attributes between classes in a single call" do
    
  end

  it "can share multiple attributes between classes in a single call with in-line name mapping" do
    
  end

  it "can share multiple attributes between classes in a single call with name mapping provided by block iteration" do
    
  end

  it "can share multiple attributes between classes in a single call with name mapping provided by a hash returned in a block" do
    
  end

  ###################################################################################
  #  self.attr_share!( class )                                                      #
  #  self.attr_share!( class ) { { :attr_shared_name => :local_attribute_alias } }  #
  ###################################################################################
  
  it "can implicitly share all attributes from another class" do
    
  end

  ################################
  #  self.attr_merge_like_hash!  #
  ################################
  
  it "can auto-configure merge method to merge properties from B to A like Hash#merge" do
    
  end

  ########################
  #  self.attr_delegate  #
  ########################
  
  # * attr_is_delegate  :accessor
  it "" do
    
  end

  ########################
  #  self.attr_property  #
  ########################
  
  # * attr_is_property     :accessor
  it "" do
    
  end

  ########################
  #  self.attr_required  #
  ########################

  # * attr_required   :accessor
  it "" do
    
  end

  #########################
  #  self.attr_validator  #
  #########################

  # * attr_validator  :constraint_validation_method
  it "" do
    
  end

  #########################
  #  self.before_persist  #
  #########################

  it "" do
    
  end

  ########################
  #  self.after_persist  #
  ########################

  it "" do
    
  end

  ##########################
  #  self.before_persist!  #
  ##########################

  it "" do
    
  end

  #########################
  #  self.after_persist!  #
  #########################

  it "" do
    
  end

  ##############
  #  revision  #
  ##############
  
  it "can manage revisions" do
    
  end
   
end




# view permissions for specific users (so certain content only shows up for certain users/groups)
