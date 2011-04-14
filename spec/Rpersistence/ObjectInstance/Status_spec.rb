
describe Rpersistence::ObjectInstance::Status do

  #############################################
  #  Klass.persistence_key_source_is_method?  #
  #  persistence_key_source_is_method?        #
  #############################################

  it "can report whether the current key source for persisting is a method" do
    class Rpersistence::ObjectInstance::Status::Mock01
    end
  end

  ###############################################
  #  Klass.persistence_key_source_is_variable?  #
  #  persistence_key_source_is_variable?        #
  ###############################################

  it "can report whether the current key source for persisting is a variable" do
    class Rpersistence::ObjectInstance::Status::Mock02
    end
    
  end

  ###################################################
  #  Klass.persists_instance_variables_by_default?  #
  #  persists_instance_variables_by_default?        #
  ###################################################

  it "can report whether it persists all instance variables by default" do
    class Rpersistence::ObjectInstance::Status::Mock03
    end
    
  end

  #######################################
  #  Klass.persists_atomic_by_default?  #
  #  persists_atomic_by_default?        #
  #######################################

  it "can report whether it persists atomically or non-atomically by default" do
    class Rpersistence::ObjectInstance::Status::Mock04
    end
    
  end

  #############################
  #  Klass.atomic_attribute?  #
  #  atomic_attribute?        #
  #############################

  it "can report whether a given attribute is atomic" do
    class Rpersistence::ObjectInstance::Status::Mock05
    end
    
  end
  
  ######################################
  #  Klass.atomic_attribute_accessor?  #
  #  atomic_attribute_accessor?        #
  ######################################

  it "can report whether a given attribute has an atomic accessor" do
    class Rpersistence::ObjectInstance::Status::Mock06
    end
    
  end
  
  ####################################
  #  Klass.atomic_attribute_reader?  #
  #  atomic_attribute_reader?        #
  ####################################

  it "can report whether a given attribute has an atomic reader" do
    class Rpersistence::ObjectInstance::Status::Mock07
    end
    
  end
  
  ####################################
  #  Klass.atomic_attribute_writer?  #
  #  atomic_attribute_writer?        #
  ####################################

  it "can report whether a given attribute has an atomic writer" do
    class Rpersistence::ObjectInstance::Status::Mock08
    end
    
  end
  
  #################################
  #  Klass.non_atomic_attribute?  #
  #  non_atomic_attribute?        #
  #################################

  it "can report whether a given attribute is non-atomic" do
    class Rpersistence::ObjectInstance::Status::Mock09
    end
    
  end
  
  ##########################################
  #  Klass.non_atomic_attribute_accessor?  #
  #  non_atomic_attribute_accessor?        #
  ##########################################

  it "can report whether a given attribute has a non-atomic accessor" do
    class Rpersistence::ObjectInstance::Status::Mock10
    end
    
  end
  
  ########################################
  #  Klass.non_atomic_attribute_reader?  #
  #  non_atomic_attribute_reader?        #
  ########################################

  it "can report whether a given attribute has a non-atomic reader" do
    class Rpersistence::ObjectInstance::Status::Mock11
    end
    
  end
  
  ########################################
  #  Klass.non_atomic_attribute_writer?  #
  #  non_atomic_attribute_writer?        #
  ########################################

  it "can report whether a given attribute has a non-atomic writer" do
    class Rpersistence::ObjectInstance::Status::Mock12
    end
    
  end
  
  #################################
  #  Klass.persistent_attribute?  #
  #  persistent_attribute?        #
  #################################

  it "can report whether a given attribute is persistent" do
    class Rpersistence::ObjectInstance::Status::Mock13
    end
    
  end
  
  #####################################
  #  Klass.non_persistent_attribute?  #
  #  non_persistent_attribute?        #
  #####################################

  it "can report whether a given attribute is non-persistent" do
    class Rpersistence::ObjectInstance::Status::Mock14
    end
    
  end
  
  ########################################
  #  Klass.persistent_attribute_reader?  #
  #  persistent_attribute_reader?        #
  ########################################

  it "can report whether a given attribute has a persistent attribute reader" do
    class Rpersistence::ObjectInstance::Status::Mock15
    end
    
  end
  
  ########################################
  #  Klass.persistent_attribute_writer?  #
  #  persistent_attribute_writer?        #
  ########################################

  it "can report whether a given attribute has a persistent attribute writer" do
    class Rpersistence::ObjectInstance::Status::Mock16
    end
    
  end

  ##################################
  #  Klass.persists_as_flat_file?  #
  #  persists_as_flat_file?        #
  ##################################

  def persists_as_flat_file?
    
  end
  
end
