
describe Rpersistence::ObjectInstance::Status do

  ###################################################
  #  persists_all_by_default?  #
  ###################################################

  it "can report whether it persists all instance variables by default" do
    class Rpersistence::ObjectInstance::Status::Mock03
    end
    
  end

  #######################################
  #  persists_atomic_by_default?  #
  #######################################

  it "can report whether it persists atomically or non-atomically by default" do
    class Rpersistence::ObjectInstance::Status::Mock04
    end
    
  end

  #############################
  #  atomic_attribute?  #
  #############################

  it "can report whether a given attribute is atomic" do
    class Rpersistence::ObjectInstance::Status::Mock05
    end
    
  end
  
  ######################################
  #  atomic_attribute_accessor?  #
  ######################################

  it "can report whether a given attribute has an atomic accessor" do
    class Rpersistence::ObjectInstance::Status::Mock06
    end
    
  end
  
  ####################################
  #  atomic_attribute_reader?  #
  ####################################

  it "can report whether a given attribute has an atomic reader" do
    class Rpersistence::ObjectInstance::Status::Mock07
    end
    
  end
  
  ####################################
  #  atomic_attribute_writer?  #
  ####################################

  it "can report whether a given attribute has an atomic writer" do
    class Rpersistence::ObjectInstance::Status::Mock08
    end
    
  end
  
  #################################
  #  non_atomic_attribute?  #
  #################################

  it "can report whether a given attribute is non-atomic" do
    class Rpersistence::ObjectInstance::Status::Mock09
    end
    
  end
  
  ##########################################
  #  non_atomic_attribute_accessor?  #
  ##########################################

  it "can report whether a given attribute has a non-atomic accessor" do
    class Rpersistence::ObjectInstance::Status::Mock10
    end
    
  end
  
  ########################################
  #  non_atomic_attribute_reader?  #
  ########################################

  it "can report whether a given attribute has a non-atomic reader" do
    class Rpersistence::ObjectInstance::Status::Mock11
    end
    
  end
  
  ########################################
  #  non_atomic_attribute_writer?  #
  ########################################

  it "can report whether a given attribute has a non-atomic writer" do
    class Rpersistence::ObjectInstance::Status::Mock12
    end
    
  end
  
  #################################
  #  persistent_attribute?  #
  #################################

  it "can report whether a given attribute is persistent" do
    class Rpersistence::ObjectInstance::Status::Mock13
    end
    
  end
  
  #####################################
  #  non_persistent_attribute?  #
  #####################################

  it "can report whether a given attribute is non-persistent" do
    class Rpersistence::ObjectInstance::Status::Mock14
    end
    
  end
  
  ########################################
  #  persistent_attribute_reader?  #
  ########################################

  it "can report whether a given attribute has a persistent attribute reader" do
    class Rpersistence::ObjectInstance::Status::Mock15
    end
    
  end
  
  ########################################
  #  persistent_attribute_writer?  #
  ########################################

  it "can report whether a given attribute has a persistent attribute writer" do
    class Rpersistence::ObjectInstance::Status::Mock16
    end
    
  end

  ##################################
  #  persists_as_flat_file?  #
  ##################################

  def persists_as_flat_file?
    
  end
  
end
