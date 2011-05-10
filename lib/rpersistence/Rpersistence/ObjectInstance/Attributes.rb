
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------  Persistence Object Attributes  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Attributes

  ####################################  Atomicity Configurations  ###########################################

  ###############################
  #  Klass.included_attributes  #
  #  included_attributes        #
  ###############################

  def included_attributes
    
    attributes = included_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ######################################
  #  Klass.included_atomic_attributes  #
  #  included_atomic_attributes        #
  ######################################

  def included_atomic_attributes
    
    attributes = included_atomic_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ##########################################
  #  Klass.included_non_atomic_attributes  #
  #  included_non_atomic_attributes        #
  ##########################################

  def included_non_atomic_attributes
    
    attributes = included_non_atomic_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ###############################
  #  Klass.excluded_attributes  #
  #  excluded_attributes        #
  ###############################

  def excluded_attributes
    
    attributes = excluded_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ###########################################
  #  Klass.excluded_from_atomic_attributes  #
  #  excluded_from_atomic_attributes        #
  ###########################################

  def excluded_from_atomic_attributes
    
    attributes = excluded_from_atomic_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ########################################
  #  Klass.excluded_from_all_attributes  #
  #  excluded_from_all_attributes        #
  ########################################

  def excluded_from_all_attributes
    
    attributes = excluded_from_all_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end
  
  #############################
  #  Klass.atomic_attributes  #
  #  atomic_attributes        #
  #############################

  def atomic_attributes
    
    attributes = atomic_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ######################################
  #  Klass.atomic_attribute_accessors  #
  #  atomic_attribute_accessors        #
  ######################################

  def atomic_attribute_accessors

    return atomic_attributes_hash.select { |accessor, status| status == :accessor }.keys

  end

  ####################################
  #  Klass.atomic_attribute_readers  #
  #  atomic_attribute_readers        #
  ####################################

  def atomic_attribute_readers
    
    return atomic_attributes_hash.select { |accessor, status| ( status == :reader || status == :accessor ) }.keys

  end

  ####################################
  #  Klass.atomic_attribute_writers  #
  #  atomic_attribute_writers        #
  ####################################

  def atomic_attribute_writers
    
    return atomic_attributes_hash.select { |accessor, status| ( status == :writer || status == :accessor ) }.keys
    
  end

  #################################
  #  Klass.non_atomic_attributes  #
  #  non_atomic_attributes        #
  #################################

  def non_atomic_attributes
    
    attributes = non_atomic_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ##########################################
  #  Klass.non_atomic_attribute_accessors  #
  #  non_atomic_attribute_accessors        #
  ##########################################

  def non_atomic_attribute_accessors
    
    return non_atomic_attributes_hash.select { |accessor, status| status == :accessor }.keys

  end

  ########################################
  #  Klass.non_atomic_attribute_readers  #
  #  non_atomic_attribute_readers        #
  ########################################

  def non_atomic_attribute_readers
    
    return non_atomic_attributes_hash.select { |accessor, status| ( status == :reader || status == :accessor ) }.keys

  end

  ########################################
  #  Klass.non_atomic_attribute_writers  #
  #  non_atomic_attribute_writers        #
  ########################################

  def non_atomic_attribute_writers
    
    return non_atomic_attributes_hash.select { |accessor, status| ( status == :writer || status == :accessor ) }.keys
    
  end

  ####################################  Persistence Configuration  ##########################################

  #################################
  #  Klass.persistent_attributes  #
  #  persistent_attributes        #
  #################################

  def persistent_attributes
    
    attributes = persistent_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ##########################################
  #  Klass.persistent_attribute_accessors  #
  #  persistent_attribute_accessors        #
  ##########################################

  def persistent_attribute_accessors
    
    return persistent_attributes_hash.select { |accessor, status| status == :accessor }.keys

  end

  ########################################
  #  Klass.persistent_attribute_readers  #
  #  persistent_attribute_readers        #
  ########################################

  def persistent_attribute_readers
    
    return persistent_attributes_hash.select { |accessor, status| ( status == :reader || status == :accessor ) }.keys
    
  end

  ########################################
  #  Klass.persistent_attribute_writers  #
  #  persistent_attribute_writers        #
  ########################################

  def persistent_attribute_writers

    return persistent_attributes_hash.select { |accessor, status| ( status == :writer || status == :accessor ) }.keys
    
  end
  
  #####################################
  #  Klass.non_persistent_attributes  #
  #  non_persistent_attributes        #
  #####################################

  def non_persistent_attributes

    attributes = non_persistent_attributes_hash.delete_if { |key, value| value == nil }

    return attributes.keys
    
  end

  ##############################################
  #  Klass.non_persistent_attribute_accessors  #
  #  non_persistent_attribute_accessors        #
  ##############################################

  def non_persistent_attribute_accessors

    return non_persistent_attributes_hash.select { |accessor, status| status == :accessor }.keys

  end

  ############################################
  #  Klass.non_persistent_attribute_readers  #
  #  non_persistent_attribute_readers        #
  ############################################

  def non_persistent_attribute_readers

    return non_persistent_attributes_hash.select { |accessor, status| ( status == :reader || status == :accessor ) }.keys

  end

  ############################################
  #  Klass.non_persistent_attribute_writers  #
  #  non_persistent_attribute_writers        #
  ############################################

  def non_persistent_attribute_writers

    return non_persistent_attributes_hash.select { |accessor, status| ( status == :writer || status == :accessor ) }.keys

  end
  
  ########################################
  #  Klass.included_attribute_accessors  #
  #  included_attribute_accessors        #
  ########################################

  def included_attribute_accessors
    
    return included_attributes_hash.select { |accessor, status| status == :accessor }.keys    

  end

  ######################################
  #  Klass.included_attribute_readers  #
  #  included_attribute_readers        #
  ######################################

  def included_attribute_readers
    
    return included_attributes_hash.select { |accessor, status| ( status == :reader || status == :accessor ) }.keys    
    
  end

  ######################################
  #  Klass.included_attribute_writers  #
  #  included_attribute_writers        #
  ######################################

  def included_attribute_writers
    
    return included_attributes_hash.select { |accessor, status| ( status == :writer || status == :accessor ) }.keys    
    
  end
  
  ########################################
  #  Klass.excluded_attribute_accessors  #
  #  excluded_attribute_accessors        #
  ########################################

  def excluded_attribute_accessors

    return excluded_attributes_hash.select { |accessor, status| status == :accessor }.keys    
    
  end
  
  ######################################
  #  Klass.excluded_attribute_readers  #
  #  excluded_attribute_readers        #
  ######################################

  def excluded_attribute_readers
    
    return excluded_attributes_hash.select { |accessor, status| ( status == :reader || status == :accessor ) }.keys    

  end

  ######################################
  #  Klass.excluded_attribute_writers  #
  #  excluded_attribute_writers        #
  ######################################

  def excluded_attribute_writers
    
    return excluded_attributes_hash.select { |accessor, status| ( status == :writer || status == :accessor ) }.keys    
    
  end

end

