
module Rpersistence::ObjectInstance::Status

  #######################################  Configuration Status  ############################################

  #############################################
  #  Klass.persistence_key_source_is_method?  #
  #  persistence_key_source_is_method?        #
  #############################################

  def persistence_key_source_is_method?

    key_source_is_method = nil

    if  instance_variable_defined?( :@__rpersistence__key_source_is_method__ )  and
        @__rpersistence__key_source_is_method__
        
      key_source_is_method  = true

    elsif self.class != Class

      key_source_is_method  = self.class.persistence_key_source_is_method?

    end

    return key_source_is_method

  end

  ###############################################
  #  Klass.persistence_key_source_is_variable?  #
  #  persistence_key_source_is_variable?        #
  ###############################################

  def persistence_key_source_is_variable?

    key_source_is_variable = nil

    if  instance_variable_defined( :@__rpersistence__key_source_is_variable__ )  and
        @__rpersistence__key_source_is_variable__

      key_source_is_variable  = true

    elsif self.class != Class

      key_source_is_variable  = self.class.persistence_key_source_is_variable?

    end

    return key_source_is_variable

  end
  
  ######################################
  #  Klass.persists_ivars_by_default?  #
  #  persists_ivars_by_default?        #
  ######################################

  def persists_ivars_by_default?
    
    persists_ivars = false
    
    if instance_variable_defined?( :@__rpersistence__persists_ivars_by_default__ )
    
      persists_ivars = @__rpersistence__persists_ivars_by_default__
    
    elsif self.class != Class
      
      persists_ivars = self.class.persists_ivars_by_default?

    end

    return persists_ivars
    
  end
  
  
  #######################################
  #  Klass.persists_atomic_by_default?  #
  #  persists_atomic_by_default?        #
  #######################################

  def persists_atomic_by_default?
    
    persists_atomic = false
    if instance_variable_defined?( :@__rpersistence__persists_atomic_by_default__ )
    
      persists_atomic = @__rpersistence__persists_atomic_by_default__
      
    elsif self.class != Class
      
      persists_atomic = self.class.persists_atomic_by_default?

    end

    return persists_atomic
    
  end

  #########################################  Attribute Status  ##############################################
  
  #############################
  #  Klass.atomic_attribute?  #
  #  atomic_attribute?        #
  #############################
  
  def atomic_attribute?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( atomic_attributes, attributes )

  end
  
  ######################################
  #  Klass.atomic_attribute_accessor?  #
  #  atomic_attribute_accessor?        #
  ######################################
  
  def atomic_attribute_accessor?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( atomic_attribute_accessors, attributes )

  end

  ####################################
  #  Klass.atomic_attribute_reader?  #
  #  atomic_attribute_reader?        #
  ####################################
  
  def atomic_attribute_reader?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( atomic_attribute_readers, attributes )

  end

  ####################################
  #  Klass.atomic_attribute_writer?  #
  #  atomic_attribute_writer?        #
  ####################################
  
  def atomic_attribute_writer?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( atomic_attribute_writers, attributes )

  end
  
  #################################
  #  Klass.non_atomic_attribute?  #
  #  non_atomic_attribute?        #
  #################################
  
  def non_atomic_attribute?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( non_atomic_attributes, attributes )

  end

  ##########################################
  #  Klass.non_atomic_attribute_accessor?  #
  #  non_atomic_attribute_accessor?        #
  ##########################################
  
  def non_atomic_attribute_accessor?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( non_atomic_attribute_accessors, attributes )

  end

  ########################################
  #  Klass.non_atomic_attribute_reader?  #
  #  non_atomic_attribute_reader?        #
  ########################################
  
  def non_atomic_attribute_reader?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( non_atomic_attribute_readers, attributes )

  end

  ########################################
  #  Klass.non_atomic_attribute_writer?  #
  #  non_atomic_attribute_writer?        #
  ########################################
  
  def non_atomic_attribute_writer?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( non_atomic_attribute_writers, attributes )

  end
  
  #################################
  #  Klass.persistent_attribute?  #
  #  persistent_attribute?        #
  #################################
  
  def persistent_attribute?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( persistent_attributes, attributes )

  end

  #####################################
  #  Klass.non_persistent_attribute?  #
  #  non_persistent_attribute?        #
  #####################################
  
  def non_persistent_attribute?( *attributes )

    return atomic_non_atomic_persistent_accessor_reader_writer?( non_persistent_attributes, attributes )

  end

  ########################################
  #  Klass.persistent_attribute_reader?  #
  #  persistent_attribute_reader?        #
  ########################################
  
  def persistent_attribute_reader?( *attributes )

    is_persistent_reader = false

    if persistent_vars = persistent_readers
  
      attributes.each do |this_attribute|
        is_persistent_reader = persistent_vars.include?( this_attribute )
        break unless is_persistent_reader
      end
  
    end
    
    return is_persistent_reader

  end

  ########################################
  #  Klass.persistent_attribute_writer?  #
  #  persistent_attribute_writer?        #
  ########################################
  
  def persistent_attribute_writer?( *attributes )

    is_persistent_writer = false

    if persistent_vars = persistent_writers

      attributes.each do |this_attribute|
        is_persistent_writer = persistent_vars.include?( this_attribute )
        break unless is_persistent_writer
      end

    end
    
    return is_persistent_writer

  end
  
end
