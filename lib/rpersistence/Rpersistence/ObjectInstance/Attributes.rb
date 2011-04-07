
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------  Persistence Object Attributes  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Attributes

  ####################################  Atomicity Configurations  ###########################################
  
  #############################
  #  Klass.atomic_attributes  #
  #  atomic_attributes        #
  #############################

	def atomic_attributes
    
    return atomic_non_atomic_readers_writers_accessors( true, nil )
    
  end

  ######################################
  #  Klass.atomic_attribute_accessors  #
  #  atomic_attribute_accessors        #
  ######################################

	def atomic_attribute_accessors
    
    return atomic_non_atomic_readers_writers_accessors( true, :accessor )

  end

  ####################################
  #  Klass.atomic_attribute_readers  #
  #  atomic_attribute_readers        #
  ####################################

	def atomic_attribute_readers
    
    return atomic_non_atomic_readers_writers_accessors( true, :reader )

  end

  ####################################
  #  Klass.atomic_attribute_writers  #
  #  atomic_attribute_writers        #
  ####################################

	def atomic_attribute_writers
    
    return atomic_non_atomic_readers_writers_accessors( true, :writer )
    
  end

  #################################
  #  Klass.non_atomic_attributes  #
  #  non_atomic_attributes        #
  #################################

	def non_atomic_attributes
    
    return atomic_non_atomic_readers_writers_accessors( false, nil )
    
  end

  ##########################################
  #  Klass.non_atomic_attribute_accessors  #
  #  non_atomic_attribute_accessors        #
  ##########################################

	def non_atomic_attribute_accessors
    
    return atomic_non_atomic_readers_writers_accessors( false, :accessor )

  end

  ########################################
  #  Klass.non_atomic_attribute_readers  #
  #  non_atomic_attribute_readers        #
  ########################################

	def non_atomic_attribute_readers
    
    return atomic_non_atomic_readers_writers_accessors( false, :reader )

  end

  ########################################
  #  Klass.non_atomic_attribute_writers  #
  #  non_atomic_attribute_writers        #
  ########################################

	def non_atomic_attribute_writers
    
    return atomic_non_atomic_readers_writers_accessors( false, :writer )
    
  end

  ####################################  Persistence Configuration  ##########################################

  #################################
  #  Klass.persistent_attributes  #
  #  persistent_attributes        #
  #################################

	def persistent_attributes
    
    persistent_attributes = nil

    if persists_ivars_by_default?
      # if we persist all by default then non-persist are the ones we've excluded
      persistent_attributes = ( instance_variables_as_accessors + included_attributes - excluded_attributes ).uniq
    else
      # otherwise the ones we've included
      persistent_attributes = included_attributes - excluded_attributes
    end

    return persistent_attributes
    
  end

  ########################################
  #  Klass.persistent_attribute_readers  #
  #  persistent_attribute_readers        #
  ########################################

	def persistent_attribute_readers
    
    persistent_attributes = nil

    if persists_ivars_by_default?
      # if we persist all by default then non-persist are the ones we've excluded
      persistent_attributes = ( instance_variables_as_accessors + included_attribute_readers - excluded_attribute_readers ).uniq
    else
      # otherwise the ones we've included
      persistent_attributes = included_attribute_readers - excluded_attribute_readers
    end

    return persistent_attributes
    
  end

  ########################################
  #  Klass.persistent_attribute_writers  #
  #  persistent_attribute_writers        #
  ########################################

	def persistent_attribute_writers

    persistent_attributes = nil

    if persists_ivars_by_default?
      # if we persist all by default then non-persist are the ones we've excluded
      persistent_attributes = ( instance_variables_as_accessors + included_attribute_writers - excluded_attribute_writers ).uniq
    else
      # otherwise the ones we've included
      persistent_attributes = included_attribute_writers - excluded_attribute_writers
    end

    return persistent_attributes
    
  end
  
  #####################################
  #  Klass.non_persistent_attributes  #
  #  non_persistent_attributes        #
  #####################################

	def non_persistent_attributes

    non_persistent_attributes = nil

    if persists_ivars_by_default?
      # if we persist all by default then non-persist are the ones we've excluded
      non_persistent_attributes = excluded_attributes
    else
      # otherwise the ones we haven't included or have excluded
      non_persistent_attributes = ( instance_variables_as_accessors + excluded_attributes - included_attributes ).uniq
    end

    return non_persistent_attributes
    
  end

  ############################################
  #  Klass.non_persistent_attribute_readers  #
  #  non_persistent_attribute_readers        #
  ############################################

	def non_persistent_attribute_readers

    non_persistent_attribute_readers = nil

    if persists_ivars_by_default?
      # if we persist all by default then non-persist are the ones we've excluded
      non_persistent_attribute_readers = ( instance_variables_as_accessors + included_attribute_readers - excluded_attribute_readers ).uniq
    else
      # otherwise the ones we've included
      non_persistent_attribute_readers = included_attribute_readers
    end

    return non_persistent_attribute_readers

  end

  ############################################
  #  Klass.non_persistent_attribute_writers  #
  #  non_persistent_attribute_writers        #
  ############################################

	def non_persistent_attribute_writers

    non_persistent_attribute_writers = nil

    if persists_ivars_by_default?
      # if we persist all by default then non-persist are the ones we've excluded
      non_persistent_attribute_writers = ( instance_variables_as_accessors + included_attribute_writers - excluded_attribute_writers ).uniq
    else
      # otherwise the ones we've included
      non_persistent_attribute_writers = included_attribute_writers
    end

    return non_persistent_attribute_writers

  end
  
  ###############################
  #  Klass.included_attributes  #
  #  included_attributes        #
  ###############################

	def included_attributes
    
    included_attributes = nil
    
    if self.class != Class

      included_attributes = self.class.included_attributes

    else
    
      included_attributes = ( @__rpersistence__includes__ || {} ).keys
          
    end
      
    included_attributes = included_attributes + @__rpersistence__includes__.keys if @__rpersistence__includes__
    included_attributes = included_attributes - @__rpersistence__excludes__.keys if @__rpersistence__excludes__
    
    return included_attributes.uniq
    
  end

  ########################################
  #  Klass.included_attribute_accessors  #
  #  included_attribute_accessors        #
  ########################################

	def included_attribute_accessors
    
    included_attribute_accessors  = included_or_excluded_attribute_accessor_reader_writers( true, :accessor )
    
  end

  ######################################
  #  Klass.included_attribute_readers  #
  #  included_attribute_readers        #
  ######################################

	def included_attribute_readers
    
    included_attribute_readers    = included_or_excluded_attribute_accessor_reader_writers( true, :reader )
    
  end
  
  ######################################
  #  Klass.included_attribute_writers  #
  #  included_attribute_writers        #
  ######################################

	def included_attribute_writers

    included_attribute_writers    = included_or_excluded_attribute_accessor_reader_writers( true, :writer )

  end
  
  ###############################
  #  Klass.excluded_attributes  #
  #  excluded_attributes        #
  ###############################

	def excluded_attributes

    excluded_attributes = nil
    
    if self.class != Class

      excluded_attributes = self.class.excluded_attributes

    else
    
      excluded_attributes = ( @__rpersistence__excludes__ || {} ).keys
          
    end
      
    excluded_attributes = excluded_attributes + @__rpersistence__excludes__.keys if @__rpersistence__excludes__
    excluded_attributes = excluded_attributes - @__rpersistence__includes__.keys if @__rpersistence__includes__
    
    return excluded_attributes.uniq
    
  end

  ########################################
  #  Klass.excluded_attribute_accessors  #
  #  excluded_attribute_accessors        #
  ########################################

	def excluded_attribute_accessors

    excluded_attribute_accessors  = included_or_excluded_attribute_accessor_reader_writers( false, :accessor )
    
  end
  
  ######################################
  #  Klass.excluded_attribute_readers  #
  #  excluded_attribute_readers        #
  ######################################

	def excluded_attribute_readers
    
    excluded_attribute_readers    = included_or_excluded_attribute_accessor_reader_writers( false, :reader )

  end

  ######################################
  #  Klass.excluded_attribute_writers  #
  #  excluded_attribute_writers        #
  ######################################

	def excluded_attribute_writers
    
    excluded_attribute_writers    = included_or_excluded_attribute_accessor_reader_writers( false, :writer )
    
  end

end

