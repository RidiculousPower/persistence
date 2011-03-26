
#---------------------------------------------------------------------------------------------------------#
#-------------------------------------  Shared Object/Instance  ------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::KlassAndInstance::Object

	# The methods in this module extend Object and are also included for instances.

  # All variables can be automatically persisted, or specific variables can be declared as atomic or non-atomic.
  # Atomic declarations necessitate the use of an accessor (which will be created if it does ! exist).
  # Changing the value of atomic variables directly _will ! persist atomically_.
  # Only changing the value of atomic variables by way of their accessors will persist atomically. 

  ###################
  #  self.extended  #
  ###################

  def self.extended( class_or_module )
    class << class_or_module
      alias_method  :object_attr_accessor, :attr_accessor
      alias_method  :object_attr_reader,   :attr_reader
      alias_method  :object_attr_writer,   :attr_writer
    end
  end

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

    include_or_extend_for_persistence_if_necessary

    @__rpersistence__port__ = port

    return self

  end

  ###############################
  #  Klass.persistence_bucket=  #
  #  persistence_bucket=        #
  ###############################

	# declare name of persistence bucket where object will be stored
  def persistence_bucket=( persistence_bucket_class_or_name )

    include_or_extend_for_persistence_if_necessary

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

    include_or_extend_for_persistence_if_necessary

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
  alias_method :persistence_key_method=,    :persistence_key_source=
  alias_method :persistence_key_variable=,  :persistence_key_source=
  alias_method :persists_by,                :persistence_key_source=

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

  #####################################
  #  Klass.persists_ivars_by_default  #
  #  persists_ivars_by_default        #
  #####################################

  def persists_ivars_by_default

    include_or_extend_for_persistence_if_necessary

    @__rpersistence__persists_ivars_by_default__  = true
    
    return self
    
  end

  ########################################
  #  Klass.persists_no_ivars_by_default  #
  #  persists_no_ivars_by_default        #
  ########################################

  def persists_no_ivars_by_default

    include_or_extend_for_persistence_if_necessary
    
    @__rpersistence__persists_ivars_by_default__  = false

    return self

  end

  #######################################
  #  Klass.persists_atomic_by_default!  #
  #  persists_atomic_by_default!        #
  #######################################

  def persists_atomic_by_default!
    
    include_or_extend_for_persistence_if_necessary
    
    @__rpersistence__persists_atomic_by_default__  = true
    
    extend Rpersistence::KlassAndInstance::Accessors
    class << self
      extend Rpersistence::KlassAndInstance::Accessors
    end
    
    return self
    
  end

  ###########################################
  #  Klass.persists_non_atomic_by_default!  #
  #  persists_non_atomic_by_default!        #
  ###########################################

  def persists_non_atomic_by_default!

    include_or_extend_for_persistence_if_necessary
    
    @__rpersistence__persists_atomic_by_default__  = false

    return self

  end

  #######################
  #  Klass.attr_atomic  #
  #  attr_atomic        #
  #######################

	# declare one or more attributes to persist atomically
  def attr_atomic( *attributes )

    include_or_extend_for_persistence_if_necessary

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

    include_or_extend_for_persistence_if_necessary

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

    include_or_extend_for_persistence_if_necessary

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
    
    include_or_extend_for_persistence_if_necessary
    
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

    include_or_extend_for_persistence_if_necessary

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

    include_or_extend_for_persistence_if_necessary

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

    include_or_extend_for_persistence_if_necessary

    persists_no_ivars_by_default

		# move all explicitly declared non-atomic elements into atomic
    attr_atomic( *@__rpersistence__include_as_non_atomic__.keys )

    return self

  end

  #############################
  #  Klass.attrs_non_atomic!  #
  #  attrs_non_atomic!        #
  #############################

	# declare all attributes persist non-atomically
  def attrs_non_atomic!

    include_or_extend_for_persistence_if_necessary

    persists_no_ivars_by_default

		# move all declared elements from atomic into non-atomic
    attr_non_atomic( *@__rpersistence__include_as_atomic__.keys )

    return self

  end

  ###############################
  #  Klass.attr_non_persistent  #
  #  attr_non_persistent        #
  ###############################

	def attr_non_persistent( *attributes )

    include_or_extend_for_persistence_if_necessary

		attributes.each do |this_attribute|

  	  if this_attribute.is_a?( Hash )

        attr_non_persistent( *this_attribute.keys )

      else
        
  			add_attribute( false, false, this_attribute, :accessor )
			  remove_atomic_accessor( this_attribute, :accessor )

  	  end

		end

	end
  alias_method :attr_exclude, :attr_non_persistent

  ################################
  #  Klass.attr_non_persistent!  #
  #  attr_non_persistent!        #
  ################################

	def attr_non_persistent!

    include_or_extend_for_persistence_if_necessary

    persists_no_ivars_by_default

		# move all declared elements from atomic into non-atomic
    attr_non_persistent!( @__rpersistence__include__.keys )

    return self

  end
  
  ######################################
  #  Klass.attr_non_persistent_reader  #
  #  attr_non_persistent_reader        #
  ######################################

	def attr_non_persistent_reader( *attributes )

    include_or_extend_for_persistence_if_necessary

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

    include_or_extend_for_persistence_if_necessary

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

  ######################
  #  Klass.attr_clear  #
  #  attr_clear        #
  ######################

  # clear accessors for one or more attributes
  def attr_clear!

    attr_clear( @__rpersistence__include__ )
    attr_clear( @__rpersistence__exclude__ )

    return self
    
  end

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
    
      included_attributes = @__rpersistence__includes__.keys
          
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
    
      excluded_attributes = @__rpersistence__excludes__.keys
          
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

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################
  
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

  ##################################################################
  #  Klass.included_or_excluded_attribute_accessor_reader_writers  #
  #  included_or_excluded_attribute_accessor_reader_writers        #
  ##################################################################

  def included_or_excluded_attribute_accessor_reader_writers( included_not_excluded, reader_writer_accessor )
  
    included_excluded_variable  = ( included_not_excluded ?   @__rpersistence__includes__
                                                          :   @__rpersistence__excludes__ )

    attribute_accessor_reader_writers         = included_excluded_variable.select { |accessor, status| status == reader_writer_accessor }
  
    if self.class != Class
      
      class_attribute_accessor_reader_writers = self.class.included_or_excluded_attribute_accessor_reader_writers( included_or_excluded, reader_writer_accessor )
      attribute_accessor_reader_writers       = self_attribute_accessor_reader_writers.merge( class_attribute_accessor_reader_writers )
      
    end

    return attribute_accessor_reader_writers.uniq
  
  end
  
  #######################################################
  #  Klass.atomic_non_atomic_readers_writers_accessors  #
  #  atomic_non_atomic_readers_writers_accessors        #
  #######################################################

	def atomic_non_atomic_readers_writers_accessors( atomic, reader_writer_accessor )
    
    atomic_reader_writer_accessors = nil

    if instance_variable_defined?( :@__rpersistence__includes__ )
      
      atomic_non_atomic_attributes  = ( atomic  ? @__rpersistence__include_as_atomic__ 
                                                : @__rpersistence__include_as_non_atomic__ )
      
      if reader_writer_accessor

        atomic_reader_writer_accessors  = atomic_non_atomic_attributes.select { |accessor, status| status == reader_writer_accessor }

      else

        atomic_reader_writer_accessors  = atomic_non_atomic_attributes
          
      end
      
      atomic_reader_writer_accessors  = atomic_reader_writer_accessors.keys
      
    elsif self.class != Class

      atomic_reader_writer_accessors = self.class.atomic_non_atomic_readers_writers_accessors( atomic, reader_writer_accessor )

    end

    return atomic_reader_writer_accessors
    
  end
  
  ########################################  Actually Private  ###############################################

	private

  ##########################################################
  #  Klass.include_or_extend_for_persistence_if_necessary  #
  #  include_or_extend_for_persistence_if_necessary        #
  ##########################################################

  def include_or_extend_for_persistence_if_necessary

    # we know this object needs to be evaluated as a persistence object
    # for now we are not allowing classes to become enhanced this way
    if self.class == Class
      include( Rpersistence::Instance::Variables )
    else
      self.extend( Rpersistence::Instance::Variables )
    end
    
  end

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

        property_value  = __send__( prior_accessor_name, property_value )

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

    if attribute.to_s.chars.first == '@'
      
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
      @__rpersistence__persists_ivars_by_default__		 		    = true
  		# enable or disable atomic persistence if no explicit include/exclude is specified
  		# if @__rpersistence__persists_ivars_by_default__ is true and a var is ! explicitly included/excluded, var will be atomic
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

end


