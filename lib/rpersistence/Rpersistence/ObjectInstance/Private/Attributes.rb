
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------  Persistence Object Attributes  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Attributes

  ##############################
  #  Klass.complex_properties  #
  #  complex_properties        #
  ##############################

  def complex_properties
    
    return @__rpersistence__cache__complex_property__
    
  end

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  ####################################
  #  Klass.included_attributes_hash  #
  #  included_attributes_hash        #
  ####################################

  def included_attributes_hash
    
    return get_cascading_hash_configuration_from_Object( :include )
    
  end

  ####################################
  #  Klass.excluded_attributes_hash  #
  #  excluded_attributes_hash        #
  ####################################

  def excluded_attributes_hash
    
    return get_cascading_hash_configuration_from_Object( :exclude )
    
  end

  ###########################################
  #  Klass.included_atomic_attributes_hash  #
  #  included_atomic_attributes_hash        #
  ###########################################

  def included_atomic_attributes_hash
    
    return get_cascading_hash_configuration_from_Object( :include_as_atomic )
    
  end

  ###############################################
  #  Klass.included_non_atomic_attributes_hash  #
  #  included_non_atomic_attributes_hash        #
  ###############################################

  def included_non_atomic_attributes_hash
    
    return get_cascading_hash_configuration_from_Object( :include_as_non_atomic )
    
  end

  ################################################
  #  Klass.excluded_from_atomic_attributes_hash  #
  #  excluded_from_atomic_attributes_hash        #
  ################################################

  def excluded_from_atomic_attributes_hash
    
    return get_cascading_hash_configuration_from_Object( :exclude_from_atomic )
    
  end

  #############################################
  #  Klass.excluded_from_all_attributes_hash  #
  #  excluded_from_all_attributes_hash        #
  #############################################

  def excluded_from_all_attributes_hash
    
    return get_cascading_hash_configuration_from_Object( :exclude_from_all )
    
  end

  ##################################
  #  Klass.atomic_attributes_hash  #
  #  atomic_attributes_hash        #
  ##################################

  def atomic_attributes_hash
    
    # atomic attributes are always declared (whether explicitly by attr_atomic or implicitly by attr_accessor)
    return included_atomic_attributes_hash

  end

  ######################################
  #  Klass.non_atomic_attributes_hash  #
  #  non_atomic_attributes_hash        #
  ######################################

  def non_atomic_attributes_hash
          
    # get declared attributes (their variables may not exist yet)
    attributes = included_non_atomic_attributes_hash

    if persists_instance_variables_by_default?
      
      # add implicit attributes (default is to persist all variables)
      instance_variable_as_non_atomic_accessors  =  Hash.new
      instance_variables_as_accessors.each do |this_variable_accessor|
        instance_variable_as_non_atomic_accessors[ this_variable_accessor ] = status_for_existing_status_minus_other_status( :accessor, attributes[ this_variable_accessor ] )
      end

    end
    
    return attributes
    
  end

  ######################################
  #  Klass.persistent_attributes_hash  #
  #  persistent_attributes_hash        #
  ######################################

  def persistent_attributes_hash

    # start with explicitly included attributes
    persistent_attributes = included_attributes_hash

    if persists_instance_variables_by_default?
      
      # now add default attributes not already defined
      instance_variables_as_accessors.each do |this_variable_accessor|
        # default for instance variables is accessor - if we are persisting all variables then we set all to :accessor unless excluded
        persistent_attributes[ this_variable_accessor ] = :accessor
      end

    end

    # now exclude explicitly excluded attributes
    excluded_attributes_hash.each do |this_excluded_attribute, this_excluded_attribute_status|
      persistent_attributes[ this_excluded_attribute ] = status_for_existing_status_minus_other_status( persistent_attributes[ this_excluded_attribute ], this_excluded_attribute_status )
    end

    return persistent_attributes

  end

  ##########################################
  #  Klass.non_persistent_attributes_hash  #
  #  non_persistent_attributes_hash        #
  ##########################################

  def non_persistent_attributes_hash

    non_persistent_attributes = nil

    if persists_instance_variables_by_default?
      # if we persist all by default then non-persist are the ones we've excluded
      non_persistent_attributes = excluded_from_all_attributes_hash
    else
      non_persistent_attributes  =  excluded_from_all_attributes_hash
      # otherwise the ones we haven't included or have excluded
      included_attributes  =  included_attributes_hash
      instance_variables_as_accessors.each do |this_variable_accessor|
        # add to excluded any instance variables minus the mode by which they are included
        non_persistent_attributes[ this_variable_accessor ] = status_for_existing_status_minus_other_status( :accessor, included_attributes[ this_variable_accessor ] )
      end
    end

    return non_persistent_attributes

  end
  
  ################################################################
  #  Klass.atomic_non_atomic_persistent_accessor_reader_writer?  #
  #  atomic_non_atomic_persistent_accessor_reader_writer?        #
  ################################################################

  def atomic_non_atomic_persistent_accessor_reader_writer?( accessors, attributes )
    
    attributes_match = true
    
    attributes.each do |this_attribute|
      this_attribute_accessor, this_attribute  =  accessor_name_for_var_or_method( this_attribute )
      unless accessors.include?( this_attribute_accessor )
        attributes_match = false
        break
      end
    end
    
    return attributes_match
    
  end

  #######################################
  #  Klass::variable_name_for_accessor  #
  #  variable_name_for_accessor         #
  #######################################
  
  def variable_name_for_accessor( accessor )
    return ( '@' + accessor.to_s ).to_sym
  end

  #######################################
  #  Klass::accessor_name_for_variable  #
  #  accessor_name_for_variable         #
  #######################################
  
  def accessor_name_for_variable( accessor )
    accessor_string = accessor.to_s
    return accessor_string.slice( 1, accessor_string.length ).to_sym
  end

  #############################################
  #  Klass::write_accessor_name_for_accessor  #
  #  write_accessor_name_for_accessor         #
  #############################################
  
  def write_accessor_name_for_accessor( accessor )
    return ( accessor.to_s + '=' ).to_sym
  end
  
  ############################################
  #  Klass::accessor_name_for_var_or_method  #
  #  accessor_name_for_var_or_method         #
  ############################################

  def accessor_name_for_var_or_method( attribute, writer_not_reader = false )
    
    property_name         = nil
    accessor_method_name  = nil

    if attribute == nil

      # do nothing
      
    elsif attribute.to_s.chars.first == '@'
      
      property_name         = attribute
      accessor_method_name  = accessor_name_for_variable( attribute )
      
    else
      
      property_name           = variable_name_for_accessor( attribute )

      if writer_not_reader
        accessor_method_name  = write_accessor_name_for_accessor( attribute )
      else
        accessor_method_name  = attribute
      end
    
    end

    return accessor_method_name, property_name
    
  end

  ####################################
  #  Klass::name_for_prior_accessor  #
  #  name_for_prior_accessor         #
  ####################################

  def name_for_prior_accessor( accessor_method_name, reader_writer_accessor )

    new_name_for_prior_accessor = nil

    method_string         = accessor_method_name.to_s
    if reader_writer_accessor == :writer and method_string[ method_string.length - 1] == '='
      accessor_method_name  = method_string.slice( 0, method_string.length - 1 )
    end
    
    new_name_for_prior_accessor = ( accessor_method_name.to_s + '_pre_rpersistence' ).to_sym

    if reader_writer_accessor == :writer
      
      new_name_for_prior_accessor = write_accessor_name_for_accessor( new_name_for_prior_accessor )

    end

    return new_name_for_prior_accessor

  end

  ########################################
  #  Klass::alias_prior_accessor_method  #
  #  alias_prior_accessor_method         #
  ########################################

  def alias_prior_accessor_method( accessor_method_name, reader_writer_accessor )
    prior_accessor_name = nil
    if method_defined?( accessor_method_name )
      prior_accessor_name = name_for_prior_accessor( accessor_method_name, reader_writer_accessor )
      alias_method prior_accessor_name, accessor_method_name
    end
    return prior_accessor_name
  end
  
  #######################################
  #  Klass::accessor_has_prior_method?  #
  #  accessor_has_prior_method?         #
  #######################################
  
  def accessor_has_prior_method?( accessor_method_name, reader_writer_accessor )
    has_prior_method    = false
    prior_accessor_name = name_for_prior_accessor( accessor_method_name, reader_writer_accessor )
    if respond_to?( prior_accessor_name )
      has_prior_method = true
    end
    return has_prior_method
  end

  ############################################
  #  Klass::instance_variables_as_accessors  #
  #  instance_variables_as_accessors         #
  ############################################

  def instance_variables_as_accessors

    instance_vars_as_accessors  = Array.new
    
    instance_variables.each do |this_var|
      instance_vars_as_accessors.push( accessor_name_for_variable( this_var ) )
    end

    return instance_vars_as_accessors

  end
  
end
