require_relative '../../../lib/rpersistence.rb'

describe Rpersistence::ObjectInstance::Configuration do

  #############################
  #  Klass.persistence_port=  #
  #  persistence_port=#
  #  Klass.persistence_port   #
  #  persistence_port  #
  #############################
  
  it "can set and get its persistence port" do
    mock_port = Object.new
    class Rpersistence::ObjectInstance::Configuration::Mock01
    end
    Rpersistence::ObjectInstance::Configuration::Mock01.persistence_port = mock_port
    Rpersistence::ObjectInstance::Configuration::Mock01.persistence_port.should == mock_port
    instance = Rpersistence::ObjectInstance::Configuration::Mock01.new
    instance.persistence_port.should == mock_port
    alternate_mock_port = Object.new
    instance.persistence_port = alternate_mock_port
    instance.persistence_port.should == alternate_mock_port
  end
  
  ########################################
  #  Klass.instance_persistence_bucket=  #
  #  persistence_bucket=         #
  #  Klass.instance_persistence_bucket   #
  #  persistence_bucket          #
  ########################################

  it "can set and get its persistence bucket" do
    class Rpersistence::ObjectInstance::Configuration::Mock02
    end
    Rpersistence::ObjectInstance::Configuration::Mock02.instance_persistence_bucket.should == Rpersistence::ObjectInstance::Configuration::Mock02.to_s
    Rpersistence::ObjectInstance::Configuration::Mock02.instance_persistence_bucket = 'another bucket'
    Rpersistence::ObjectInstance::Configuration::Mock02.instance_persistence_bucket.should == 'another bucket'
    instance = Rpersistence::ObjectInstance::Configuration::Mock02.new
    instance.persistence_bucket.should == 'another bucket'
    instance.persistence_bucket = 'yet another bucket'
    instance.persistence_bucket.should == 'yet another bucket'
  end
  
  ######################################################
  #  Klass.attr_persistent!     #
  #  attr_persistent!   #
  #  Klass.attr_non_persistent!       #
  #  attr_non_persistent!             #
  ######################################################

  it "can be set to persist all instance variables by default or no instance variables by default" do
    class Rpersistence::ObjectInstance::Configuration::Mock04
    end
    Rpersistence::ObjectInstance::Configuration::Mock04.persists_all_by_default?.should == true
    Rpersistence::ObjectInstance::Configuration::Mock04.attr_non_persistent!
    Rpersistence::ObjectInstance::Configuration::Mock04.persists_all_by_default?.should == false
    Rpersistence::ObjectInstance::Configuration::Mock04.attr_persistent!
    Rpersistence::ObjectInstance::Configuration::Mock04.persists_all_by_default?.should == true
    instance = Rpersistence::ObjectInstance::Configuration::Mock04.new
    instance.persists_all_by_default?.should == true
    instance.attr_non_persistent!
    instance.persists_all_by_default?.should == false
    instance.attr_persistent!
    instance.persists_all_by_default?.should == true
  end

  ###########################################
  #  Klass.persists_atomic_by_default!      #
  #  persists_atomic_by_default!    #
  #  persists_non_atomic_by_default!  #
  ###########################################

  it "can be set to persist atomically by default, which means any accessors declared after this point will automatically be declared atomic or non-atomically by default, which means only explicit calls to persist! will persist properties not explicitly declared atomic" do
    class Rpersistence::ObjectInstance::Configuration::Mock05
    end
    Rpersistence::ObjectInstance::Configuration::Mock05.persists_atomic_by_default?.should == false
    Rpersistence::ObjectInstance::Configuration::Mock05.persists_atomic_by_default!
    Rpersistence::ObjectInstance::Configuration::Mock05.persists_atomic_by_default?.should == true
    Rpersistence::ObjectInstance::Configuration::Mock05.persists_non_atomic_by_default!
    Rpersistence::ObjectInstance::Configuration::Mock05.persists_atomic_by_default?.should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock05.new
    instance.persists_atomic_by_default?.should == false
    instance.persists_atomic_by_default!
    instance.persists_atomic_by_default?.should == true
    instance.persists_non_atomic_by_default!
    instance.persists_atomic_by_default?.should == false
  end

  #######################
  #  attr_atomic  #
  #######################

  it "can declare atomic attributes" do
    class Rpersistence::ObjectInstance::Configuration::Mock07
      attr_atomic :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock07.atomic_attribute?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock07.atomic_attribute?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock07.atomic_attribute?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock07.atomic_attribute?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock07.new
    instance.atomic_attribute?( :attribute ).should == true
    instance.atomic_attribute?( :@variable ).should == true
    instance.atomic_attribute?( :other_attribute ).should == false
    instance.atomic_attribute?( :other_variable ).should == false
  end

  ##############################
  #  attr_atomic_reader  #
  ##############################

  it "can declare atomic attribute readers" do
    class Rpersistence::ObjectInstance::Configuration::Mock08
      attr_atomic_reader :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock08.atomic_attribute_reader?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock08.atomic_attribute_reader?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock08.atomic_attribute_reader?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock08.atomic_attribute_reader?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock08.new
    instance.atomic_attribute_reader?( :attribute ).should == true
    instance.atomic_attribute_reader?( :@variable ).should == true
    instance.atomic_attribute_reader?( :other_attribute ).should == false
    instance.atomic_attribute_reader?( :other_variable ).should == false
  end

  ##############################
  #  attr_atomic_writer  #
  ##############################

  it "can declare atomic attribute writers" do
    class Rpersistence::ObjectInstance::Configuration::Mock09
      attr_atomic_writer :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock09.atomic_attribute_writer?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock09.atomic_attribute_writer?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock09.atomic_attribute_writer?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock09.atomic_attribute_writer?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock09.new
    instance.atomic_attribute_writer?( :attribute ).should == true
    instance.atomic_attribute_writer?( :@variable ).should == true
    instance.atomic_attribute_writer?( :other_attribute ).should == false
    instance.atomic_attribute_writer?( :other_variable ).should == false
  end

  ###########################
  #  attr_non_atomic  #
  ###########################

  it "can declare non-atomic attributes" do
    class Rpersistence::ObjectInstance::Configuration::Mock10
      attr_non_atomic :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock10.non_atomic_attribute?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock10.non_atomic_attribute?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock10.non_atomic_attribute?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock10.non_atomic_attribute?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock10.new
    instance.non_atomic_attribute?( :attribute ).should == true
    instance.non_atomic_attribute?( :@variable ).should == true
    instance.non_atomic_attribute?( :other_attribute ).should == false
    instance.non_atomic_attribute?( :other_variable ).should == false
  end

  ##################################
  #  attr_non_atomic_reader  #
  ##################################

  it "can declare non-atomic readers, meaning any time the object is persisted from a port it will load these values" do
    class Rpersistence::ObjectInstance::Configuration::Mock11
      attr_non_atomic_reader :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock11.non_atomic_attribute_reader?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock11.non_atomic_attribute_reader?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock11.non_atomic_attribute_reader?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock11.non_atomic_attribute_reader?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock11.new
    instance.non_atomic_attribute_reader?( :attribute ).should == true
    instance.non_atomic_attribute_reader?( :@variable ).should == true
    instance.non_atomic_attribute_reader?( :other_attribute ).should == false
    instance.non_atomic_attribute_reader?( :other_variable ).should == false
  end

  ##################################
  #  attr_non_atomic_writer  #
  ##################################

  it "can declare non-atomic writers, meaning any time the object is told to persist! it will persist these values" do
    class Rpersistence::ObjectInstance::Configuration::Mock12
      attr_non_atomic_writer :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock12.non_atomic_attribute_writer?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock12.non_atomic_attribute_writer?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock12.non_atomic_attribute_writer?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock12.non_atomic_attribute_writer?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock12.new
    instance.non_atomic_attribute_writer?( :attribute ).should == true
    instance.non_atomic_attribute_writer?( :@variable ).should == true
    instance.non_atomic_attribute_writer?( :other_attribute ).should == false
    instance.non_atomic_attribute_writer?( :other_variable ).should == false
  end

  #########################
  #  attrs_atomic!  #
  #########################

  it "can declare all attributes atomic" do
    class Rpersistence::ObjectInstance::Configuration::Mock13
      attrs_atomic!
      attr_accessor :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock13.atomic_attribute?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock13.atomic_attribute?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock13.atomic_attribute?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock13.atomic_attribute?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock13.new
    instance.atomic_attribute?( :attribute ).should == true
    instance.atomic_attribute?( :@variable ).should == true
    instance.atomic_attribute?( :other_attribute ).should == false
    instance.atomic_attribute?( :other_variable ).should == false    
  end

  #############################
  #  attrs_non_atomic!  #
  #############################

  it "can declare all attributes non-atomic" do
    class Rpersistence::ObjectInstance::Configuration::Mock14
      attr_atomic :attribute, :@variable
      attrs_non_atomic!
    end
    Rpersistence::ObjectInstance::Configuration::Mock14.non_atomic_attribute?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock14.non_atomic_attribute?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock14.non_atomic_attribute?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock14.non_atomic_attribute?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock14.new
    instance.non_atomic_attribute?( :attribute ).should == true
    instance.non_atomic_attribute?( :@variable ).should == true
    instance.non_atomic_attribute?( :other_attribute ).should == false
    instance.non_atomic_attribute?( :other_variable ).should == false    
  end

  ###############################
  #  attr_non_persistent  #
  ###############################

  it "can declare non-persistent attributes" do
    class Rpersistence::ObjectInstance::Configuration::Mock15
      attr_non_persistent :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock15.non_persistent_attribute?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock15.non_persistent_attribute?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock15.non_persistent_attribute?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock15.non_persistent_attribute?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock15.new
    instance.non_persistent_attribute?( :attribute ).should == true
    instance.non_persistent_attribute?( :@variable ).should == true
    instance.non_persistent_attribute?( :other_attribute ).should == false
    instance.non_persistent_attribute?( :other_variable ).should == false    
  end

  #################################
  #  attrs_non_persistent!  #
  #################################

  it "can declare that all currently declared attributes are now non-persistent and future attributes are non-persistent by default" do
    class Rpersistence::ObjectInstance::Configuration::Mock15
      attr_atomic :attribute, :@variable
      attrs_non_persistent!
    end
    Rpersistence::ObjectInstance::Configuration::Mock15.persistent_attribute?( :attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock15.non_persistent_attribute?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock15.non_persistent_attribute?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock15.non_persistent_attribute?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock15.non_persistent_attribute?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock15.new
    instance.non_persistent_attribute?( :attribute ).should == true
    instance.non_persistent_attribute?( :@variable ).should == true
    instance.non_persistent_attribute?( :other_attribute ).should == false
    instance.non_persistent_attribute?( :other_variable ).should == false    
  end

  ######################################
  #  attr_non_persistent_reader  #
  ######################################

  it "can declare that attributes should not read persistently, meaning persisted values will never be retrieved from persistence" do
    class Rpersistence::ObjectInstance::Configuration::Mock16
      attr_non_persistent_reader :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock16.non_persistent_attribute_reader?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock16.non_persistent_attribute_reader?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock16.non_persistent_attribute_reader?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock16.non_persistent_attribute_reader?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock16.new
    instance.non_persistent_attribute_reader?( :attribute ).should == true
    instance.non_persistent_attribute_reader?( :@variable ).should == true
    instance.non_persistent_attribute_reader?( :other_attribute ).should == false
    instance.non_persistent_attribute_reader?( :other_variable ).should == false    
  end

  ######################################
  #  attr_non_persistent_writer  #
  ######################################

  it "can declare that attributes should not write persistently, meaning the persisted value will never change" do
    class Rpersistence::ObjectInstance::Configuration::Mock17
      attr_non_persistent_writer :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock17.non_persistent_attribute_writer?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock17.non_persistent_attribute_writer?( :@variable ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock17.non_persistent_attribute_writer?( :other_attribute ).should == false
    Rpersistence::ObjectInstance::Configuration::Mock17.non_persistent_attribute_writer?( :@other_variable ).should == false
    instance = Rpersistence::ObjectInstance::Configuration::Mock17.new
    instance.non_persistent_attribute_writer?( :attribute ).should == true
    instance.non_persistent_attribute_writer?( :@variable ).should == true
    instance.non_persistent_attribute_writer?( :other_attribute ).should == false
    instance.non_persistent_attribute_writer?( :other_variable ).should == false    
  end

  #####################
  #  attr_flat  #
  #####################

  it "can declare that complex attributes should be stored as flat attributes" do
    class Rpersistence::ObjectInstance::Configuration::Mock18
      attr_flat :attribute, :@variable
    end
    Rpersistence::ObjectInstance::Configuration::Mock18.persists_flat?( :attribute ).should == true
    Rpersistence::ObjectInstance::Configuration::Mock18.persists_flat?( :@variable ).should == true
    instance = Rpersistence::ObjectInstance::Configuration::Mock18.new
    instance.persists_flat?( :attribute ).should == true
    instance.persists_flat?( :@variable ).should == true
  end
  
end
