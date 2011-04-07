
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------  Persistence Object Attributes  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Attributes

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  ##########################
  #  Klass::add_attribute  #
  #  add_attribute         #
  ##########################
	
	def add_attribute( atomic, include_not_exclude, attribute, reader_writer_accessor )
    
    accessor_method_name, property_name  = accessor_name_for_var_or_method( attribute, false )
    
    # if we are an instance setting attributes we have to copy over class settings first
    copy_class_settings_if_necessary( atomic, include_not_exclude )
    
    # mark attribute as explicitly included
    if include_not_exclude
      @__rpersistence__includes__[ accessor_method_name ]  = true
      @__rpersistence__excludes__.delete( accessor_method_name )
    else
      @__rpersistence__excludes__[ accessor_method_name ]  = true
      @__rpersistence__includes__.delete( accessor_method_name )
    end

    # add status (:reader, :writer, :accessor) to currently declared status
    # ie. :reader (existing) + :writer (new) = :accessor (resulting attribute status)
    add_attribute_status( atomic, include_not_exclude, accessor_method_name, reader_writer_accessor )
    
    # subtract status from complementary atomicity/include var
    subtract_attribute_status( ! atomic, include_not_exclude, accessor_method_name, reader_writer_accessor )

	end

  #######################################################
  #  Klass.atomic_non_atomic_readers_writers_accessors  #
  #  atomic_non_atomic_readers_writers_accessors        #
  #######################################################

	def atomic_non_atomic_readers_writers_accessors( atomic, reader_writer_accessor )
    
    atomic_reader_writer_accessors = nil

    if instance_variable_defined?( :@__rpersistence__includes__ )
      
      # ultimately we are either persisting all ivars by default or persisting none by default

      atomic_non_atomic_attributes  = ( atomic  ? @__rpersistence__include_as_atomic__ 
                                                : @__rpersistence__include_as_non_atomic__ )
      
      if reader_writer_accessor

        atomic_reader_writer_accessors  = atomic_non_atomic_attributes.select { |accessor, status| status == reader_writer_accessor }

      else

        atomic_reader_writer_accessors  = atomic_non_atomic_attributes
          
      end
      
      atomic_reader_writer_accessors  = atomic_reader_writer_accessors.keys
      
    elsif self.class != Class

      self.class.instance_eval do
        atomic_reader_writer_accessors = atomic_non_atomic_readers_writers_accessors( atomic, reader_writer_accessor )
      end
      
    end

    return atomic_reader_writer_accessors
    
  end
  
  ################################################################
  #  Klass.atomic_non_atomic_persistent_accessor_reader_writer?  #
  #  atomic_non_atomic_persistent_accessor_reader_writer?        #
  ################################################################
  
  def atomic_non_atomic_persistent_accessor_reader_writer?( accessors_readers_writers, attributes )
  
    is_atomic_non_atomic_persistent_accessor_reader_writer = false

    if accessors_readers_writers

      attributes.each do |this_attribute|
        accessor_method_name, property_name                     = accessor_name_for_var_or_method( this_attribute, false )
        is_atomic_non_atomic_persistent_accessor_reader_writer  = accessors_readers_writers.include?( accessor_method_name )
        break unless is_atomic_non_atomic_persistent_accessor_reader_writer
      end

    end

    return is_atomic_non_atomic_persistent_accessor_reader_writer
    
  end

  ##################################################################
  #  Klass.included_or_excluded_attribute_accessor_reader_writers  #
  #  included_or_excluded_attribute_accessor_reader_writers        #
  ##################################################################

  def included_or_excluded_attribute_accessor_reader_writers( included_not_excluded, reader_writer_accessor )
  
    included_excluded_variable  = ( included_not_excluded ?   @__rpersistence__includes__
                                                          :   @__rpersistence__excludes__ )

    attribute_accessor_reader_writers         = included_excluded_variable.select { |accessor, status| status == reader_writer_accessor }
  
    if self.class != Class
      
      attribute_accessor_reader_writers       = self.attribute_accessor_reader_writers
      
      self.class.instance_eval do
        class_attribute_accessor_reader_writers = included_or_excluded_attribute_accessor_reader_writers( included_or_excluded, reader_writer_accessor )      
      end

      attribute_accessor_reader_writers       = attribute_accessor_reader_writers.merge( class_attribute_accessor_reader_writers )
      
    end

    return attribute_accessor_reader_writers.uniq
  
  end
  
  #############################################
  #  Klass::copy_class_settings_if_necessary  #
  #  copy_class_settings_if_necessary         #
  #############################################

  def copy_class_settings_if_necessary( atomic, include_not_exclude )

    if self.class != Class
      @__rpersistence__default_atomic__ = self.class.instance_variable_get( :@__rpersistence__default_atomic__ )
      if include_not_exclude
        @__rpersistence__includes__     = self.class.instance_variable_get( :@__rpersistence__includes__ )
        if atomic
          @__rpersistence__include_as_atomic__      = self.class.instance_variable_get( :@__rpersistence__include_as_atomic__ )          
        else
          @__rpersistence__include_as_non_atomic__  = self.class.instance_variable_get( :@__rpersistence__include_as_non_atomic__ )          
        end
      else
        @__rpersistence__excludes__     = self.class.instance_variable_get( :@__rpersistence__excludes__ )        
        if atomic
          @__rpersistence__exclude_from_atomic__    = self.class.instance_variable_get( :@__rpersistence__exclude_from_atomic__ )          
        else
          @__rpersistence__exclude_from_all__       = self.class.instance_variable_get( :@__rpersistence__exclude_from_all__ )          
        end
      end
    end
    
  end

  ##############################
  #  Klass::get_atomicity_var  #
  #  get_atomicity_var         #
  ##############################

  def get_atomicity_var( atomic, include_not_exclude )
	  return ( atomic   ?   ( include_not_exclude ? @__rpersistence__include_as_atomic__     
                                                : @__rpersistence__exclude_from_atomic__ ) 
                      :   ( include_not_exclude ? @__rpersistence__include_as_non_atomic__ 
                                                : @__rpersistence__exclude_from_all__ ) )
  end
  
  #################################
  #  Klass::add_attribute_status  #
  #  add_attribute_status         #
  #################################
	
	def add_attribute_status( atomic, include_not_exclude, attribute, reader_writer_accessor )

    atomicity_var = get_atomicity_var( atomic, include_not_exclude )

    # we are setting reader_writer_accessor for attribute in atomicity var
    atomicity_var[ attribute ]  = reader_writer_accessor

    current_value = atomicity_var[ attribute ]

    case reader_writer_accessor
      
      when :accessor

        atomicity_var[ attribute ] = :accessor

        if atomic and include_not_exclude
          add_atomic_accessor( attribute )
        elsif include_not_exclude
          add_non_atomic_accessor( attribute )
        end
        
      when :reader

        case current_value
          
          when nil
          
            atomicity_var[ attribute ]  = :reader

            if atomic and include_not_exclude
              add_atomic_reader( attribute )
            elsif include_not_exclude
              add_non_atomic_reader( attribute )
            end
            
          when :writer
            
            atomicity_var[ attribute ]  = :accessor

            if atomic and include_not_exclude
              add_atomic_reader( attribute )
            elsif include_not_exclude
              add_non_atomic_reader( attribute )
            end

        end
      
      when :writer

        case current_value
          
          when nil
          
            atomicity_var[ attribute ]  = :writer

            if atomic and include_not_exclude
              add_atomic_writer( attribute )
            elsif include_not_exclude
              add_non_atomic_writer( attribute )
            end
            
          when :reader
            
            atomicity_var[ attribute ]  = :accessor

            if atomic and include_not_exclude
              add_atomic_writer( attribute )
            elsif include_not_exclude
              add_non_atomic_writer( attribute )
            end

        end
      
      when nil
        
        atomicity_var.delete( attribute )
            
    end
    
  end

  ######################################
  #  Klass::subtract_attribute_status  #
  #  subtract_attribute_status         #
  ######################################

  # when we make an attribute atomic, remove from non-atomic list (and vice-versa)
	def subtract_attribute_status( atomic, include_not_exclude, attribute, reader_writer_accessor )

    atomicity_var = get_atomicity_var( atomic, include_not_exclude )
    
    current_value = atomicity_var[ attribute ]
    
    case reader_writer_accessor
      
      when :accessor

        atomicity_var.delete( attribute )
      
      when :reader

        case current_value
          
          when :accessor
          
            atomicity_var[ attribute ]  = :writer
            
          when :reader
            
            atomicity_var.delete( attribute )

        end
      
      when :writer

        case current_value
          
          when :accessor
          
            atomicity_var[ attribute ]  = :reader

          when :writer
            
            atomicity_var.delete( attribute )

        end

      when nil
        
        atomicity_var.delete( attribute )
      
    end
	
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

      remove_method( method_to_remove ) if method_defined?( method_to_remove )

      if method_defined?( prior_accessor_name )
        # alias our old accessor back to be primary
        alias_method method_to_remove, prior_accessor_name
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
  
end
