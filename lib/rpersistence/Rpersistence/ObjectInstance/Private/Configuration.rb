
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------  Persistence Object Configuration  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Configuration

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  #########################################################
  #  Klass::get_cascading_hash_configuration_from_Object  #
  #  get_cascading_hash_configuration_from_Object         #
  #########################################################

	def get_cascading_hash_configuration_from_Object( which_configuration )
		
		configuration_variable = configuration_variable( which_configuration )
		
		# get object configuration
		configuration = object_instance_variable_get( configuration_variable ) || Hash.new

		# we merge local configuration (if any) with cascading configuration from class
		# configuration defined lowest in the hierarchy wins
		cascading_class_configuration = self.class.instance_eval { get_cascading_hash_configuration_from_Object( which_configuration ) }
		configuration = cascading_class_configuration.merge( configuration )
		
		# return configuration
		return configuration
		
	end

  ##########################################################
  #  Klass::get_cascading_array_configuration_from_Object  #
  #  get_cascading_array_configuration_from_Object         #
  ##########################################################

	def get_cascading_array_configuration_from_Object( which_configuration )
		
		configuration_variable = configuration_variable( which_configuration )
		
		# get object configuration
		configuration = object_instance_variable_get( configuration_variable ) || Array.new

		# we merge local configuration (if any) with cascading configuration from class
		# configuration defined lowest in the hierarchy wins
		cascading_class_configuration = self.class.instance_eval { get_cascading_array_configuration_from_Object( which_configuration ) }
		configuration = configuration.concat( cascading_class_configuration )

		# return configuration
		return configuration
		
	end

  #########################################################
  #  Klass::get_configuration_searching_upward_from_self  #
  #  get_configuration_searching_upward_from_self         #
  #########################################################

	def get_configuration_searching_upward_from_self( which_configuration )

		configuration_variable = configuration_variable( which_configuration )

		# get object configuration
		local_configuration = instance_variable_defined?( configuration_variable )

		if local_configuration

			configuration = object_instance_variable_get( configuration_variable )

		else
			
			# if we don't have an object configuration for which_configuration then we need our class configuration
			# class configuration is defined in Rpersistence::ClassInstance::Configuration
			configuration = self.class.instance_eval { get_configuration_searching_upward_from_self( which_configuration ) }
		
		end
		
		# return configuration
		return configuration

	end
	
	###################################
  #  Klass::configuration_variable  #
  #  configuration_variable         #
  ###################################
  
	def configuration_variable( which_configuration )
		
		return ( '@__rpersistence__' + which_configuration.to_s + '__' ).to_sym
		
	end

  ###########################################################
  #  Klass::include_or_extend_for_persistence_if_necessary  #
  #  include_or_extend_for_persistence_if_necessary         #
  ###########################################################

  def include_or_extend_for_persistence_if_necessary

    # we know this object needs to be evaluated as a persistence object
    # for now we are not allowing classes to become enhanced this way
    if self.class == Class
      include( Rpersistence::ObjectInstance::Equality )
    else
      self.extend( Rpersistence::ObjectInstance::Equality )
    end
    
  end
  
  ###########################################
  #  Klass.set_persistence_key_source_type  #
  #  set_persistence_key_source_type        #
  ###########################################

  def set_persistence_key_source_type( persistence_key_accessor )
    
    if persistence_key_accessor.to_s.is_variable_name?
	    @__rpersistence__key_source_is_variable__ = true
	    @__rpersistence__key_source_is_method__   = false
    elsif persistence_key_accessor
	    @__rpersistence__key_source_is_method__   = true
	    @__rpersistence__key_source_is_variable__ = false
	  # nil case
    else
	    @__rpersistence__key_source_is_method__   = false
	    @__rpersistence__key_source_is_variable__ = false
	  end
    
  end

  ##############################
  #  Klass::get_atomicity_var  #
  #  get_atomicity_var         #
  ##############################

  def get_atomicity_var( atomic, include_not_exclude )
	  return ( atomic   ?   ( include_not_exclude ? @__rpersistence__include_as_atomic__			||= Hash.new
                                                : @__rpersistence__exclude_from_atomic__		||= Hash.new ) 
                      :   ( include_not_exclude ? @__rpersistence__include_as_non_atomic__ 	||= Hash.new
                                                : @__rpersistence__exclude_from_all__ 			||= Hash.new ) )
  end

  ############################
  #  Klass::get_include_var  #
  #  get_include_var         #
  ############################

  def get_include_var( include_not_exclude )
	  return ( include_not_exclude 	? @__rpersistence__include__	||= Hash.new
                               		: @__rpersistence__exclude__	||= Hash.new )
  end

  ####################################
  #  Klass::get_attribute_variables  #
  #  get_attribute_variables         #
  ####################################

  def get_attribute_variables( atomic, include_not_exclude )
		return [	get_atomicity_var( atomic, include_not_exclude ),
							get_include_var( include_not_exclude ) ]
	end

  ###################################
  #  Klass::get_complementary_vars  #
  #  get_complementary_vars         #
  ###################################
	
	def get_complementary_variables( atomic, include_not_exclude )
		
							# opposite include/exclude var
		return [ 	get_include_var( ! include_not_exclude ),
							# remaining 3 atomicity vars
						  get_atomicity_var( atomic, ! include_not_exclude ),
							get_atomicity_var( ! atomic, include_not_exclude ),
							get_atomicity_var( ! atomic, ! include_not_exclude ) ]
	end
	
  ##########################
  #  Klass::add_attribute  #
  #  add_attribute         #
  ##########################
	
	def add_attribute( atomic, include_not_exclude, attribute, reader_writer_accessor )
    
    accessor_method_name, property_name  = accessor_name_for_var_or_method( attribute, false )
    
		# :include, :include_as_atomic
		# :include, :include_as_non_atomic
		# :exclude, :exclude_from_atomic
		# :exclude, :exclude_from_all
		get_attribute_variables( atomic, include_not_exclude ).each do |this_attribute_variable|
			new_atomicity_value																	=	status_for_existing_status_plus_other_status( this_attribute_variable[ accessor_method_name ], reader_writer_accessor )		
			this_attribute_variable[ accessor_method_name ]			=	new_atomicity_value
		end

		# subtract from complementary sets - set to nil if appropriate
		# :include_as_atomic 			=> exclude, include_as_non_atomic, exclude_from_atomic, exclude_from_all
		# :include_as_non_atomic 	=> exclude, include_as_atomic, exclude_from_atomic, exclude_from_all
		# :exclude_from_atomic 		=> include, include_as_atomic, include_as_non_atomic, exclude_from_all
		# :exclude_from_all				=> include, include_as_atomic, include_as_non_atomic, exclude_from_atomic
		get_complementary_variables( atomic, include_not_exclude ).each do |this_complementary_variable|
			new_complementary_value 														=	status_for_existing_status_minus_other_status( this_complementary_variable[ accessor_method_name ], reader_writer_accessor )		
			this_complementary_variable[ accessor_method_name ] = new_complementary_value
		end		

		return self
    
	end

  #########################################################
  #  Klass::status_for_existing_status_plus_other_status  #
  #  status_for_existing_status_plus_other_status         #
  #########################################################
	
	def status_for_existing_status_plus_other_status( existing_status, other_status )
		
		status = nil
		
		case existing_status
			
			when :accessor

				status = :accessor

			when :reader

				case other_status
					when :writer, :accessor
						status = :accessor
					else
						status = :reader
				end

			when :writer

				case other_status
					when :reader, :accessor
						status = :accessor
					else
						status = :writer
				end
				
			when nil
				
				return other_status
			
		end
		
		return status
		
	end

  ##########################################################
  #  Klass::status_for_existing_status_minus_other_status  #
  #  status_for_existing_status_minus_other_status         #
  ##########################################################
	
	def status_for_existing_status_minus_other_status( existing_status, other_status )
		
		status = nil
		
		case existing_status
			
			when :accessor

				case other_status
					when :accessor
						status = nil
					when :reader
						status = :writer
					when :writer
						status = :reader
					else
						status = :accessor
				end

			when :reader

				case other_status
					when :reader, :accessor
						status = nil
					else
						status = :reader
				end

			when :writer

				case other_status
					when :writer, :accessor
						status = nil
					else
						status = :writer
				end
			
		end
		
		return status
		
	end

  ################################
  #  Klass::add_atomic_accessor  #
  #  add_atomic_accessor         #
  ################################

  def add_atomic_accessor( attribute )
    add_atomic_reader( attribute )
    add_atomic_writer( attribute )
    return self
  end

  ##############################
  #  Klass::add_atomic_reader  #
  #  add_atomic_reader         #
  ##############################

  def add_atomic_reader( attribute )

    accessor_method_name, property_name  = accessor_name_for_var_or_method( attribute )

    prior_accessor_name = alias_prior_accessor_method( accessor_method_name, :reader )

    define_atomic_getter( accessor_method_name, property_name, prior_accessor_name )

    return self

  end

  ##############################
  #  Klass::add_atomic_writer  #
  #  add_atomic_writer         #
  ##############################

  def add_atomic_writer( attribute )

    accessor_method_name, property_name  = accessor_name_for_var_or_method( attribute, true )

    prior_accessor_name = alias_prior_accessor_method( accessor_method_name, :writer )

    define_atomic_setter( accessor_method_name, property_name, prior_accessor_name )

    return self

  end

  #################################
  #  Klass::define_atomic_getter  #
  #  define_atomic_getter         #
  #################################

  def define_atomic_getter( accessor_method_name, property_name, prior_accessor_name )

    define_method( accessor_method_name ) do

      property_value    = nil

      if prior_accessor_name

        property_value  = __send__( prior_accessor_name )

      else

        property_value  = instance_variable_get( property_name )

      end

      return property_value

    end

    return self

  end

  #################################
  #  Klass::define_atomic_setter  #
  #  define_atomic_setter         #
  #################################

  def define_atomic_setter( accessor_method_name, property_name, prior_accessor_name )

    define_method( accessor_method_name ) do |property_value|

      if prior_accessor_name

        __send__( prior_accessor_name, property_value )

      else

        instance_variable_set( property_name, property_value )

      end

      return self

    end

    return self

  end

  ###################################
  #  Klass::remove_atomic_accessor  #
  #  remove_atomic_accessor         #
  ###################################

  def remove_atomic_accessor( accessor_method_name, reader_writer_accessor )

    if reader_writer_accessor == :accessor

      remove_atomic_accessor( accessor_method_name, :reader )
      remove_atomic_accessor( accessor_method_name, :writer )

    else

      prior_accessor_name = name_for_prior_accessor( accessor_method_name, reader_writer_accessor )

      method_to_remove  = ( reader_writer_accessor == :writer ? write_accessor_name_for_accessor( accessor_method_name ) : accessor_method_name )

			if respond_to?( :method_defined? )
	      if method_defined?( prior_accessor_name )
	      	remove_method( method_to_remove )
	        # alias our old accessor back to be primary
	        alias_method method_to_remove, prior_accessor_name
	      end
			else
				if respond_to?( method_to_remove )
					remove_method( method_to_remove )
	        # alias our old accessor back to be primary
	        alias_method method_to_remove, prior_accessor_name
				end
			end
			

    end

    return self

  end

  ####################################
  #  Klass::add_non_atomic_accessor  #
  #  add_non_atomic_accessor         #
  ####################################

  def add_non_atomic_accessor( attribute )
    add_non_atomic_reader( attribute )
    add_non_atomic_writer( attribute )
    return self
  end

  ##################################
  #  Klass::add_non_atomic_reader  #
  #  add_non_atomic_reader         #
  ##################################

  def add_non_atomic_reader( attribute )

    # if we have a variable we don't want to add an accessor
    if attribute.to_s.is_variable_name?
      return self
    end

    accessor_method_name, property_name  = accessor_name_for_var_or_method( attribute )

    # if we already have an accessor, don't define one
    if method_defined?( accessor_method_name )
      return self
    end

    attr_reader( attribute )

    return self

  end

  ##################################
  #  Klass::add_non_atomic_writer  #
  #  add_non_atomic_writer         #
  ##################################

  def add_non_atomic_writer( attribute )

    # if we have a variable we don't want to add an accessor
    if attribute.to_s.is_variable_name?
      return self
    end

    accessor_method_name, property_name  = accessor_name_for_var_or_method( attribute, true )

    # if we already have an accessor, don't define one
    if method_defined?( accessor_method_name )
      return self
    end

    attr_writer( attribute )

    return self

  end

end