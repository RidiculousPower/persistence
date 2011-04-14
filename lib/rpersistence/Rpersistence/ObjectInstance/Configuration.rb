
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------  Persistence Object Configuration  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Configuration
  
  # All variables can be automatically persisted, or specific variables can be declared as atomic or non-atomic.
  # Atomic declarations necessitate the use of an accessor (which will be created if it does ! exist).
  # Changing the value of atomic variables directly _will not persist atomically_.
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

  ##############################
  #  Klass.persistence_bucket  #
  #  persistence_bucket        #
  ##############################
  
  def persistence_bucket( persistence_bucket_class_or_name = nil )

		bucket = nil
		
		# if specified at instance level, use specified value
		# otherwise, use value stored in class		
    if @__rpersistence__bucket__
    	
    	bucket = @__rpersistence__bucket__
    
    else
      
      bucket = self.class.instance_persistence_bucket || self.class.to_s
      
  	end

		return bucket

  end

  ###################################
  #  Klass.persistence_key_source=  #
  #  persistence_key_source=        #
  ###################################
  
  # declares method or ivar that provides key for persisting to port 
  def persistence_key_source=( persistence_key_accessor )

    include_or_extend_for_persistence_if_necessary

    @__rpersistence__key_source__ = persistence_key_accessor
    
    set_persistence_key_source_type( persistence_key_accessor )

		has_persistence_key!

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

		return get_configuration_searching_upward_from_self( :key_source )

	end

  ##################################
  #  Klass.persistence_key_method  #
  #  persistence_key_method        #
  ##################################

  def persistence_key_method

    key_source = nil

    if persistence_key_source_is_method?

      key_source  = persistence_key_source

    end
    
    return key_source

  end

  ####################################
  #  Klass.persistence_key_variable  #
  #  persistence_key_variable        #
  ####################################

  def persistence_key_variable

    key_source = nil

		if persistence_key_source_is_variable?

      key_source  = persistence_key_source
			
		end

    return key_source

  end

  ###############################
  #  Klass.persist_declared_by  #
  #  persist_declared_by        #
  ###############################

  def persist_declared_by( persistence_key_accessor )
    
    persists_no_ivars_by_default!
    
    persistence_key_source  = persistence_key_accessor
    
    return self
    
  end

  ###################################################
  #  Klass.persists_instance_variables_by_default!  #
  #  persists_instance_variables_by_default!        #
  ###################################################

  def persists_instance_variables_by_default!

    include_or_extend_for_persistence_if_necessary

    @__rpersistence__persists_instance_variables_by_default__  = true
    
    return self
    
  end

  #########################################
  #  Klass.persists_no_ivars_by_default!  #
  #  persists_no_ivars_by_default!        #
  #########################################

  def persists_no_ivars_by_default!

    include_or_extend_for_persistence_if_necessary
    
    @__rpersistence__persists_instance_variables_by_default__  = false

    return self

  end

  #######################################
  #  Klass.persists_atomic_by_default!  #
  #  persists_atomic_by_default!        #
  #######################################

  def persists_atomic_by_default!
    
    include_or_extend_for_persistence_if_necessary
    
    @__rpersistence__persists_atomic_by_default__  = true

    class << self
      include Rpersistence::ObjectInstance::Accessors
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

    persists_instance_variables_by_default!
    persists_atomic_by_default!

		# move all explicitly declared non-atomic elements into atomic
    attr_atomic( *non_atomic_attributes )

    return self

  end

  #############################
  #  Klass.attrs_non_atomic!  #
  #  attrs_non_atomic!        #
  #############################

	# declare all attributes persist non-atomically
  def attrs_non_atomic!

    include_or_extend_for_persistence_if_necessary

    persists_no_ivars_by_default!
    persists_non_atomic_by_default!

		# move all declared elements from atomic into non-atomic
    attr_non_atomic( *atomic_attributes )

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

  #################################
  #  Klass.attrs_non_persistent!  #
  #  attrs_non_persistent!        #
  #################################

	def attrs_non_persistent!

    include_or_extend_for_persistence_if_necessary

		# move all declared elements from atomic into non-atomic
    attr_non_persistent( *persistent_attributes )

    persists_no_ivars_by_default!

    return self

  end

  #####################
  #  Klass.attr_flat  #
  #  attr_flat        #
  #####################

  def attr_flat( *attributes )
    
		attributes.each do |this_attribute|
			@__rpersistence__persists_flat__[ this_attribute ] = true
		end
		
		return self
		
  end

end
