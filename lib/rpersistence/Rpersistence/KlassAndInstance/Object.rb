
#---------------------------------------------------------------------------------------------------------#
#-------------------------------------  Shared Object/Instance  ------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::KlassAndInstance::Object

	# The methods in this module extend Object and are also included for instances.

  # All variables can be automatically persisted, or specific variables can be declared as atomic or non-atomic.
  # Atomic declarations necessitate the use of an accessor (which will be created if it does ! exist).
  # Changing the value of atomic variables directly _will ! persist atomically_.
  # Only changing the value of atomic variables by way of their accessors will persist atomically. 

  ############################
  #  Klass.persistence_port  #
  #  persistence_port        #
  ############################
  
  def persistence_port

    port = nil

    if @__rpersistence__port__
      
      port = @__rpersistence__port__
      
    elsif self.class != Class
      
      port = self.class.persistence_port
      
    end

    return port

  end

  #############################
  #  Klass.persistence_port=  #
  #  persistence_port=        #
  #############################
  
  def persistence_port=( port )


    @__rpersistence__port__ = port

    return self

  end

  ###############################
  #  Klass.persistence_bucket=  #
  #  persistence_bucket=        #
  ###############################

	# declare name of persistence bucket where object will be stored
  def persistence_bucket=( persistence_bucket_class_or_name )


    @__rpersistence__bucket__ = persistence_bucket_class_or_name.to_s

  end
  alias_method :store_as, :persistence_bucket=

  ##############################
  #  Klass.persistence_bucket  #
  #  persistence_bucket        #
  ##############################
  
  def persistence_bucket
    
		rpersistence_bucket = nil
		
		# if specified at instance level, use specified value
		# otherwise, use value stored in class		
    if @__rpersistence__bucket__
    	
    	rpersistence_bucket = @__rpersistence__bucket__
    
    elsif self.class != Class
      
      rpersistence_bucket = self.class.persistence_bucket
  	
  	else
  	  
  		# default persistence bucket is classname as string
  		rpersistence_bucket = persistence_bucket	=	self.to_s

  	end

		return rpersistence_bucket

  end

  ###################################
  #  Klass.persistence_key_source=  #
  #  persistence_key_source=        #
  ###################################
  
  # declares method or ivar that provides key for persisting to port 
  def persistence_key_source=( persistence_key_accessor )


    @__rpersistence__key_source__ = persistence_key_accessor

    if @__rpersistence__key_source__.to_s.is_variable_name?
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

    return self

  end
  alias_method :persist_by, :persistence_key_source=

  ##################################
  #  Klass.persistence_key_source  #
  #  persistence_key_source        #
  ##################################

  # returns declared method or ivar that provides key for persisting to port
	def persistence_key_source

    key_source = nil

		if  instance_variable_defined?( :@__rpersistence__key_source__ )

			key_source = @__rpersistence__key_source__

		elsif self.class != Class

			key_source = self.class.persistence_key_source
  
		end

		return key_source

	end

  ##################################
  #  Klass.persistence_key_method  #
  #  persistence_key_method        #
  ##################################

  def persistence_key_method

    key_source = nil

    if instance_variable_defined?( :@__rpersistence__key_source__ )

      if persistence_key_source_is_method?

        key_source  = @__rpersistence__key_source__

      end

    elsif persistence_key_source_is_method?

      key_source  = self.class.persistence_key_method

    end
    
    return key_source

  end

  ####################################
  #  Klass.persistence_key_variable  #
  #  persistence_key_variable        #
  ####################################

  def persistence_key_variable

    key_source = nil

    if instance_variable_defined?( :@__rpersistence__key_source__ ) and persistence_key_source_is_variable?

      key_source  = @__rpersistence__key_source__

    elsif persistence_key_source_is_variable?

      key_source  = self.class.persistence_key_variable

    end

    return key_source

  end

  #######################
  #  Klass.attr_atomic  #
  #  attr_atomic        #
  #######################

	# declare one or more attributes to persist atomically
  def attr_atomic( *attributes )

    # use internal function to add each attribute as atomic accessor
		attributes.each do |this_attribute|

		  if this_attribute.is_a?( Hash )
		    
        attr_atomic( *this_attribute.keys )
		    
	    else
	      
			  add_attribute( true, true, this_attribute, :accessor )
			  
		  end
		  
		end

    return self

  end

  ##############################
  #  Klass.attr_atomic_reader  #
  #  attr_atomic_reader        #
  ##############################

	# declare one or more attributes to persist from the database atomically (but ! write atomically)
  def attr_atomic_reader( *attributes )

		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_atomic_reader( *this_attribute.keys )

      else

  			add_attribute( true, true, this_attribute, :reader )

  	  end

		end

    return self

  end

  ##############################
  #  Klass.attr_atomic_writer  #
  #  attr_atomic_writer        #
  ##############################

	# declare one or more attributes to persist to the database atomically (but ! read atomically)
  def attr_atomic_writer( *attributes )

		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_atomic_writer( *this_attribute.keys )

      else

  			add_attribute( true, true, this_attribute, :writer )

  	  end

		end

    return self

  end

  ###########################
  #  Klass.attr_non_atomic  #
  #  attr_non_atomic        #
  ###########################

  # declare one or more attributes to persist only non-atomically
  def attr_non_atomic( *attributes )
    
		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_non_atomic( *this_attribute.keys )

      else
        
        add_attribute( false, true, this_attribute, :accessor )
        remove_atomic_accessor( this_attribute, :accessor )
  			
      end

		end

    return self

  end

  ##################################
  #  Klass.attr_non_atomic_reader  #
  #  attr_non_atomic_reader        #
  ##################################

  def attr_non_atomic_reader( *attributes )

		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_non_atomic_reader( *this_attribute.keys )
      
      else
        
        add_attribute( false, true, this_attribute, :reader )
  			remove_atomic_accessor( this_attribute, :reader )
  			
      end


		end

    return self

  end

  ##################################
  #  Klass.attr_non_atomic_writer  #
  #  attr_non_atomic_writer        #
  ##################################

  def attr_non_atomic_writer( *attributes )

		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_non_atomic_writer( *this_attribute.keys )
      
      else

  			add_attribute( false, true, this_attribute, :writer )
  			remove_atomic_accessor( this_attribute, :writer )

      end

		end

    return self

  end

  #########################
  #  Klass.attrs_atomic!  #
  #  attrs_atomic!        #
  #########################

	#	declare all attributes persist atomically
  def attrs_atomic!

		# set persists_atomically_by_default true
    @__rpersistence__default_atomic__ = true
				
		# move all explicitly declared non-atomic elements into atomic
    attr_atomic( @__rpersistence__include_as_non_atomic__ )

    return self

  end

  #############################
  #  Klass.attrs_non_atomic!  #
  #  attrs_non_atomic!        #
  #############################

	# declare all attributes persist non-atomically
  def attrs_non_atomic!

		# set persists_atomically_by_default false
    @__rpersistence__default_atomic__ = false

		# move all declared elements from atomic into non-atomic
    attr_non_atomic( @__rpersistence__include_as_atomic__ )

    return self

  end

  ###############################
  #  Klass.attr_non_persistent  #
  #  attr_non_persistent        #
  ###############################

	def attr_non_persistent( *attributes )

		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_non_persistent( *this_attribute.keys )

      else
        
  			add_attribute( false, false, this_attribute, :accessor )
			  #remove_atomic_accessor( this_attribute, :accessor )

  	  end

		end

	end
  alias_method :attr_exclude, :attr_non_persistent

  ######################################
  #  Klass.attr_non_persistent_reader  #
  #  attr_non_persistent_reader        #
  ######################################

	def attr_non_persistent_reader( *attributes )

		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_non_persistent_reader( *this_attribute.keys )

      else

  			add_attribute( false, false, this_attribute, :reader )
			  remove_atomic_accessor( this_attribute, :reader )

  	  end

		end

	end
  alias_method :attr_exclude_reader, :attr_non_persistent_reader

  ######################################
  #  Klass.attr_non_persistent_writer  #
  #  attr_non_persistent_writer        #
  ######################################

	def attr_non_persistent_writer( *attributes )

		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_non_persistent_writer( *this_attribute.keys )

      else

  			add_attribute( false, false, this_attribute, :writer )
			  remove_atomic_accessor( this_attribute, :writer )

  	  end

		end

	end
  alias_method :attr_exclude_writer, :attr_non_persistent_writer

  ######################
  #  Klass.attr_clear  #
  #  attr_clear        #
  ######################

  # clear accessors for one or more attributes
  def attr_clear( *attributes )

    # use internal function to add each attribute as atomic accessor
		attributes.each do |this_attribute|
			add_attribute( true,    true,   this_attribute,   nil )
			add_attribute( false,   true,   this_attribute,   nil )
			add_attribute( true,    false,  this_attribute,   nil )
			add_attribute( false,   false,  this_attribute,   nil )
			remove_atomic_accessor( this_attribute, :reader )
		end

    return self

  end

  #######################################  Configuration Status  ############################################

  ######################
  #  Klass.persisted?  #
  #  persisted?        #
  ######################

	def persisted?( *args )
	  
	  object, bucket, key = Rpersistence::KlassAndInstance::Object.object_or_bucket_key_for_args( args )
	  
	  is_persisted  = false
	  
	  if object
	    is_persisted  = persistence_port.adapter.persisted?( object )
    else
	    is_persisted  = persistence_port.adapter.persistence_key_exists_for_bucket?( bucket, key )      
    end
	  
    return is_persisted
    
	end

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
  
  #############################
  #  Klass.atomic_attribute?  #
  #  atomic_attribute?        #
  #############################
  
  def atomic_attribute?( *attributes )

    # if everything is atomic we don't need to look up anything - return true
    return true if persists_all_ivars_atomically?

    is_atomic = false
    
    atomic_vars = atomic_attributes
    
    if atomic_vars

      attributes.each do |this_attribute|
        attribute = atomic_vars.select { |attribute_name, status| attribute_name == this_attribute }
        is_atomic = ( attribute.empty? ? false : true )
        break unless is_atomic
      end

    end
    
    return is_atomic    

  end

  ####################################
  #  Klass.atomic_attribute_reader?  #
  #  atomic_attribute_reader?        #
  ####################################
  
  def atomic_attribute_reader?( *attributes )

    # if everything is atomic we don't need to look up anything - return true
    return true if persists_all_ivars_atomically?

    is_atomic_reader = false

    atomic_vars = atomic_attributes

    if atomic_vars

      attributes.each do |this_attribute|
        attribute = atomic_vars.select { |attribute_name, status| attribute_name == this_attribute and status == :reader }
        is_atomic_reader = ( attribute.empty? ? false : true )
        break unless is_atomic_reader
      end

    end
    
    return is_atomic_reader

  end

  ####################################
  #  Klass.atomic_attribute_writer?  #
  #  atomic_attribute_writer?        #
  ####################################
  
  def atomic_attribute_writer?( *attributes )

    # if everything is atomic we don't need to look up anything - return true
    return true if persists_all_ivars_atomically?

    atomic_vars = atomic_attributes

    is_atomic_writer = false

    if atomic_vars

      attributes.each do |this_attribute|
        attribute = atomic_vars.select { |attribute_name, status| attribute_name == this_attribute and status == :writer }
        is_atomic_writer = ( attribute.empty? ? false : true )
        break unless is_atomic_writer
      end

    end
    
    return is_atomic_writer

  end
  
  #################################
  #  Klass.non_atomic_attribute?  #
  #  non_atomic_attribute?        #
  #################################
  
  def non_atomic_attribute?( *attributes )

    is_non_atomic = false

    non_atomic_vars = non_atomic_attributes

    if non_atomic_vars

      attributes.each do |this_attribute|
        attribute     = non_atomic_vars.select { |attribute_name| attribute_name == this_attribute }
        is_non_atomic = ( attribute.empty? ? false : true )
        break unless is_non_atomic
      end

    end
    
    return is_non_atomic    

  end
  
  #################################
  #  Klass.persistent_attribute?  #
  #  persistent_attribute?        #
  #################################
  
  def persistent_attribute?( *attributes )

    is_persistent = false

    persistent_vars = persistent_attributes

    if persistent_vars

      attributes.each do |this_attribute|

        is_persistent = persistent_vars.any? do |variable|

          accessor_method_name, property_name  = accessor_name_for_var_or_method( this_attribute, true )

          if property_name == variable
            return true
          end

        end

        break unless is_persistent

      end
    
    end
    
    return is_persistent    

  end

  #####################################
  #  Klass.non_persistent_attribute?  #
  #  non_persistent_attribute?        #
  #####################################
  
  def non_persistent_attribute?( *attributes )

    return ! persistent_attribute?( *attributes )    

  end

  ########################################
  #  Klass.persistent_attribute_reader?  #
  #  persistent_attribute_reader?        #
  ########################################
  
  def persistent_attribute_reader?( *attributes )

    is_persistent_reader = false

    persistent_vars = persistent_attributes

    if persistent_vars
  
      attributes.each do |this_attribute|
        is_persistent_reader = persistent_vars[ this_attribute ] if persistent_vars.include?( this_attribute )
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

    persistent_vars = persistent_attributes

    if persistent_vars

      attributes.each do |this_attribute|
        is_persistent_writer = persistent_vars[ this_attribute ] if persistent_vars.include?( this_attribute )
        break unless is_persistent_writer
      end

    end
    
    return is_persistent_writer

  end

  ###############################
  #  Klass.persists_all_ivars?  #
  #  persists_all_ivars?        #
  ###############################

	def persists_all_ivars?
    
    persists_all_ivars  = false
    
    if instance_variable_defined?( :@__rpersistence__persists_all_ivars____ )
      persists_all_ivars = @__rpersistence__persists_all_ivars____
    elsif self.class != Class
      persists_all_ivars = self.class.persists_all_ivars?
    end
    
    return persists_all_ivars
    
  end

  ##########################################
  #  Klass.persists_all_ivars_atomically?  #
  #  persists_all_ivars_atomically?        #
  ##########################################

	def persists_all_ivars_atomically?
    
    persists_all_ivars  = false
    
    if instance_variable_defined?( :@__rpersistence__persists_all_ivars____ )
      persists_all_ivars = @__rpersistence__default_atomic__
    elsif self.class != Class
      persists_all_ivars = self.class.persists_all_ivars?
    end
    
    return persists_all_ivars
    
  end

  #############################
  #  Klass.atomic_attributes  #
  #  atomic_attributes        #
  #############################

	def atomic_attributes
    
    atomic_attributes = nil

    if  instance_variable_defined?( :@__rpersistence__persists_all_ivars__ ) and 
        @__rpersistence__persists_all_ivars__                               and
        @__rpersistence__default_atomic__

      # if we persist all and default atomic then atomic are ones we've not included as non-atomic or excluded
      atomic_attributes = instance_variables - @__rpersistence__include_as_non_atomic__ - @__rpersistence__exclude_from_all__

    elsif instance_variable_defined?( :@__rpersistence__include_as_non_atomic__ )

      # if we do not persist by default then atomic are ones we've explicitly included
      atomic_attributes = @__rpersistence__include_as_atomic__

    elsif self.class != Class

      atomic_attributes = self.class.atomic_attributes

    end
    
    return atomic_attributes
    
  end

  ##########################
  #  Klass.atomic_readers  #
  #  atomic_readers        #
  ##########################

	def atomic_readers
    
    atomic_attributes = nil

    if instance_variable_defined?( :@__rpersistence__includes__ )

      atomic_accessors = self.class.atomic_attributes
      
      atomic_attributes = atomic_accessors.select { |accessor, status| status == :reader }
      
    elsif self.class != Class

      atomic_attributes = self.class.atomic_readers

    end

    return atomic_attributes
    
  end

  ##########################
  #  Klass.atomic_writers  #
  #  atomic_writers        #
  ##########################

	def atomic_writers
    
    atomic_attributes = nil

    if instance_variable_defined?( :@__rpersistence__includes__ )

      atomic_accessors = self.class.atomic_attributes
      
      atomic_attributes = atomic_accessors.select { |accessor, status| status == :writer }
      
    elsif self.class != Class

      atomic_attributes = self.class.atomic_writers

    end

    return atomic_attributes
    
  end

  #################################
  #  Klass.non_atomic_attributes  #
  #  non_atomic_attributes        #
  #################################

	def non_atomic_attributes
    
    non_atomic_attributes = nil
    
    if  instance_variable_defined?( :@__rpersistence__persists_all_ivars__ ) and 
        @__rpersistence__persists_all_ivars__

      if @__rpersistence__default_atomic__
        # if we persist all and default atomic then non-atomic are ones we've included as non-atomic (ones we've excluded are neither)
        non_atomic_attributes = @__rpersistence__include_as_non_atomic__ + @__rpersistence__exclude_from_atomic__
      else
        # if we persist all and default non-atomic then non-atomic are ones we haven't included as atomic or excluded from all
        non_atomic_attributes = instance_variables - @__rpersistence__include_as_atomic__ - @__rpersistence__exclude_from_all__
      end

    elsif instance_variable_defined?( :@__rpersistence__include_as_non_atomic__ )

      # if we do not persist by default then non-atomic are ones we've explicitly included
      non_atomic_attributes = @__rpersistence__include_as_non_atomic__

    elsif self.class != Class

      non_atomic_attributes = self.class.non_atomic_attributes

    end

    return non_atomic_attributes
    
  end

  ##############################
  #  Klass.non_atomic_readers  #
  #  non_atomic_readers        #
  ##############################

	def non_atomic_readers
    
    non_atomic_attributes = nil

    if instance_variable_defined?( :@__rpersistence__includes__ )

      non_atomic_accessors = self.class.non_atomic_attributes
      
      non_atomic_attributes = non_atomic_accessors.select { |accessor, status| status == :reader }
      
    elsif self.class != Class

      non_atomic_attributes = self.class.non_atomic_readers

    end

    return non_atomic_attributes
    
  end

  ##############################
  #  Klass.non_atomic_writers  #
  #  non_atomic_writers        #
  ##############################

	def non_atomic_writers
    
    non_atomic_attributes = nil

    if instance_variable_defined?( :@__rpersistence__includes__ )

      non_atomic_accessors = self.class.non_atomic_attributes
      
      non_atomic_attributes = non_atomic_accessors.select { |accessor, status| status == :writer }
      
    elsif self.class != Class

      non_atomic_attributes = self.class.non_atomic_writers

    end

    return non_atomic_attributes
    
  end

  #################################
  #  Klass.persistent_attributes  #
  #  persistent_attributes        #
  #################################

	def persistent_attributes
    
    persistent_attributes = nil
    
    if  instance_variable_defined?( :@__rpersistence__persists_all_ivars__ )

      if @__rpersistence__persists_all_ivars__
        # if we persist all by default then non-persist are the ones we've excluded
        persistent_attributes = instance_variables - @__rpersistence__exclude_from_all__.keys
      else
        # otherwise the ones we've included
        persistent_attributes = @__rpersistence__includes__.keys
      end

    elsif self.class != Class

      non_atomic_attributes = self.class.persistent_attributes

    end
    
    return persistent_attributes
    
  end

  #####################################
  #  Klass.non_persistent_attributes  #
  #  non_persistent_attributes        #
  #####################################

	def non_persistent_attributes
    
    non_persistent_attributes = nil
    if  instance_variable_defined?( :@__rpersistence__persists_all_ivars__ )

      if @__rpersistence__persists_all_ivars__
        # if we persist all by default then non-persist are the ones we've excluded
        non_persistent_attributes = @__rpersistence__exclude_from_all__
      else
        # otherwise the ones we've included
        non_persistent_attributes = instance_variables - @__rpersistence__includes__.keys
      end

    elsif self.class != Class

      non_atomic_attributes = self.class.persistent_attributes

    end
    
    return non_persistent_attributes
    
  end

  ##############################################  Cease  ####################################################

  ##################
  #  Klass.cease!  #
  #  cease!        #
  ##################

	def cease!( *args )

		port, bucket, persistence_key = parse_persist_args( args )

    port.adapter.delete_object!( self )

	end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  ######################################
  #  ivars_minus_persistence_internal  #
  ######################################

  def ivars_minus_persistence_internal
    
    ivar_hash	=	Hash.new
		
		instance_variables.each do |property_name|

			unless  property_name.to_s.slice( 0, 17 ) == "@__rpersistence__"

			  ivar_hash[ property_name ] = instance_variable_get( property_name )

      end
      
		end
		
		return ivar_hash
		
  end

  ########################################
  #  persistence_hash_for_current_state  #
  ########################################

  def persistence_hash_for_current_state

    persistence_hash_from_port  = persistence_hash_from_port( persistence_id )
    
    atomic_vars = atomic_attributes

    # any non-atomic values set in instance_variables need to override values persisted in our port
    non_atomic_instance_var_hash  = ivars_minus_persistence_internal.select do |variable_name, value| 
      accessor_method_name, property_name  = accessor_name_for_var_or_method( variable_name, false )
      ! atomic_vars.has_key?( accessor_method_name )
    end

    persistence_hash_for_current_state  = persistence_hash_from_port.merge( non_atomic_instance_var_hash )

    return persistence_hash_for_current_state

  end
  
  ################################
  #  persistence_hash_from_port  #
  ################################

  def persistence_hash_from_port( global_persistence_id )
    
    object_hash = Hash.new

    if global_persistence_id

  		object_hash   = persistence_port.adapter.get_object( global_persistence_id, persistence_bucket )
    
    end
    
		return object_hash
		
  end

	private

  #################################################
  #  Klass::persistence_object_has_configuration  #
  #  persistence_object_has_configuration         #
  #################################################

  def persistence_object_has_configuration

    has_configuration = false
  
    if  self.class != Class           and 
        ( @__rpersistence__includes__   or
          @__rpersistence__excludes__ )
      has_configuration = true
    end
    
    return has_configuration
    
  end

  #######################################################
  #  Klass::persistence_instance_with_no_configuration  #
  #  persistence_instance_with_no_configuration         #
  #######################################################

  def persistence_instance_with_no_configuration

    has_no_configuration = false
  
    if  self.class != Class             and 
        ! @__rpersistence__includes__   and
        ! @__rpersistence__excludes__
      has_no_configuration = true
    end
    
    return has_no_configuration
    
  end
  
  ##########################
  #  Klass::add_attribute  #
  #  add_attribute         #
  ##########################
	
	def add_attribute( atomic, include_not_exclude, attribute, reader_writer_accessor )
    
    
    # if we are an instance setting attributes we have to copy over class settings first
    copy_class_settings_if_necessary( atomic, include_not_exclude )
    
    # if we are declaring attributes then we are ! persisting all ivars (only declared)
    @__rpersistence__persists_all_ivars__       = false

    # mark attribute as explicitly included
    if include_not_exclude
      @__rpersistence__includes__[ attribute ]  = true
      @__rpersistence__excludes__[ attribute ]  = false
    else
      @__rpersistence__excludes__[ attribute ]  = true
      @__rpersistence__includes__[ attribute ]  = false
    end

    # add status (:reader, :writer, :accessor) to currently declared status
    # ie. :reader (existing) + :writer (new) = :accessor (resulting attribute status)
    add_attribute_status( atomic, include_not_exclude, attribute, reader_writer_accessor )
    
    # subtract status from complementary atomicity/include var
    subtract_attribute_status( ! atomic, include_not_exclude, attribute, reader_writer_accessor )

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
  
  ############################################
  #  Klass::accessor_name_for_var_or_method  #
  #  accessor_name_for_var_or_method         #
  ############################################

  def accessor_name_for_var_or_method( attribute, writer_not_reader = false )

    property_name         = nil
    accessor_method_name  = nil
    
    if attribute.to_s.chars.first == '@'
      
      property_name         = attribute
      attribute_name        = attribute.to_s
      accessor_method_name  = attribute_name.slice( 1, attribute_name.length - 1 ).to_sym
      
    else
      
      property_name           = ( '@' + attribute.to_s ).to_sym

      if writer_not_reader
        accessor_method_name  = ( attribute.to_s + '=' ).to_sym
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
      
      new_name_for_prior_accessor = ( new_name_for_prior_accessor.to_s + '=' ).to_sym

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

    define_method accessor_method_name do

      property_value    = nil

      # if we have an id and this is not the first persist, put atomically
      if @__rpersistence__id__ and ! instance_variable_defined?( :@__rpersistence__first_persist__ )

        property_value      = persistence_port.adapter.get_property( self, property_name )

      else

        if prior_accessor_name

          property_value  = __send__( prior_accessor_name, property_value )

        else

          instance_variable_get( property_name )

        end

      end

      # we need to retrieve by var name for consistency with non-atomic persistence
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

      # if we have an id and this is not the first persist, put atomically
      if  @__rpersistence__id__ and ! instance_variable_defined?( :@__rpersistence__first_persist__ )
        # we need to retrieve by var name for consistency with non-atomic persistence
        persistence_port.adapter.put_property!( self, property_name, property_value )
      else

        # set value in object
        if prior_accessor_name
          __send__( prior_accessor_name, property_value )
        else
          instance_variable_set( property_name, property_value )
        end
        
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

      method_to_remove  = ( reader_writer_accessor == :writer ? ( accessor_method_name.to_s + '=' ).to_sym : accessor_method_name )

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
  
end

#---------------------------------------------------------------------------------------------------------#
#--------------------------------------------  Includes  -------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Object
  
	include	Rpersistence::KlassAndInstance::Object
	extend	Rpersistence::KlassAndInstance::Object
	
  ###############
  #  inherited  #
  ###############

  def self.inherited( class_or_module )

    class_or_module.instance_eval do
      
  		# if true all ivars are persisted
      @__rpersistence__persists_all_ivars__		 		    = true
  		# enable or disable atomic persistence if no explicit include/exclude is specified
  		# if @__rpersistence__persists_all_ivars__ is true and a var is ! explicitly included/excluded, var will be atomic
      @__rpersistence__default_atomic__ 		          = true

      # explicitly include vars as atomic/non-atomic
      @__rpersistence__includes__                     = Hash.new
      # explicitly exclude vars from being atomic/non-atomic
      @__rpersistence__excludes__                     = Hash.new

      # explicitly declare atomic/non-atomic attributes
      # anything included here is also in @__rpersistence__includes__
      @__rpersistence__include_as_atomic__            = Hash.new
      @__rpersistence__include_as_non_atomic__        = Hash.new

      # explicitly exclude atomic/non-atomic attributes
      # anything excluded here is also in @__rpersistence__excludes__
      @__rpersistence__exclude_from_atomic__          = Hash.new
      @__rpersistence__exclude_from_all__             = Hash.new
    
      # attributes shared between two or more classes
      @__rpersistence__shared_attributes__            = Hash.new

    end
    
  end

  ########################################
  #  self.object_or_bucket_key_for_args  #
  ########################################
	
	def self.object_or_bucket_key_for_args( args )

    object, bucket, key = nil
    case args.length
      when 1
        object = args[ 0 ]
      when 2
        bucket, key = args[ 0 ], args[ 1 ]
      else
        raise "Expected <object> or <bucket>, <key>."
    end
	  
	  return object, bucket, key
	  
  end
  
end


