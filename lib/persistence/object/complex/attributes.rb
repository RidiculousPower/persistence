
###
# Module managing atomic/non-atomic attribute status to define how objects persist.
#
module ::Persistence::Object::Complex::Attributes

  include ::CascadingConfiguration::Hash
  include ::CascadingConfiguration::Array::Sorted::Unique
  include ::CascadingConfiguration::Setting

  ##########################
  #  attr_atomic_accessor  #
  ##########################

  ###
  # Declare one or more attributes to persist atomically.
  #
  # @overload attr_atomic_accessor( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return self
  #
  def attr_atomic_accessor( *attributes )

    attr_atomic_reader( *attributes )
    attr_atomic_writer( *attributes )

    return self

  end

  ########################
  #  attr_atomic_reader  #
  ########################

  ###
  # Declare one or more attributes to persist from the database atomically (but not write atomically).
  #
  # @overload attr_atomic_reader( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return self
  #
  def attr_atomic_reader( *attributes )

    atomic_attribute_readers.push( *attributes )

    attributes.each do |this_attribute|
      define_reader( this_attribute )
    end
    
    return self

  end

  ########################
  #  attr_atomic_writer  #
  ########################

  ###
  # Declare one or more attributes to persist to the database atomically (but not read atomically).
  #
  # @overload attr_atomic_writer( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return self
  #
  def attr_atomic_writer( *attributes )

    atomic_attribute_writers.push( *attributes )

    attributes.each do |this_attribute|
      define_writer( this_attribute )
    end
    
    return self

  end

  ##############################
  #  attr_non_atomic_accessor  #
  ##############################

  ###
  # Declare one or more attributes to persist only non-atomically.
  #
  # @overload attr_atomic_writer( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return self
  #
  def attr_non_atomic_accessor( *attributes )
    
    attr_non_atomic_reader( *attributes )
    attr_non_atomic_writer( *attributes )

    return self

  end

  ############################
  #  attr_non_atomic_reader  #
  ############################

  ###
  # Declare one or more attributes to read from the database (but not write to it) only non-atomically.
  #
  # @overload attr_non_atomic_reader( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return self
  #
  def attr_non_atomic_reader( *attributes )

    non_atomic_attribute_readers.push( *attributes )

    attributes.each do |this_attribute|

      define_reader( this_attribute )
      
    end
    
    return self

  end

  ############################
  #  attr_non_atomic_writer  #
  ############################

  ###
  # Declare one or more attributes to write to the database (but not read from it) only non-atomically.
  #
  # @overload attr_non_atomic_writer( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return self
  #
  def attr_non_atomic_writer( *attributes )

    non_atomic_attribute_writers.push( *attributes )

    attributes.each do |this_attribute|
      
      define_writer( this_attribute )

    end
        
    return self

  end

  ###################
  #  attrs_atomic!  #
  ###################
  
  ###
  # Declare all attributes to persist atomically.
  #
  def attrs_atomic!

    return attr_atomic_accessor( *non_atomic_attributes.keys )

  end

  #######################
  #  attrs_non_atomic!  #
  #######################

  ###
  # Declare all attributes to persist non-atomically.
  #
  def attrs_non_atomic!

    # move all declared elements from atomic into non-atomic
    return attr_non_atomic_accessor( *atomic_attributes )

  end
  
  #######################
  #  atomic_attribute?  #
  #######################
  
  ###
  # Query whether attribute(s) has atomic reader or writer.
  #
  # @overload atomic_attribute?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as atomic reader or writer.
  #
  def atomic_attribute?( *attributes )

    return atomic_attributes.has_attributes?( *attributes )

  end
  
  ################################
  #  atomic_attribute_accessor?  #
  ################################
  
  ###
  # Query whether attribute(s) are both atomic readers and writers.
  #
  # @overload atomic_attribute_accessor?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as both atomic readers and writers.
  #
  def atomic_attribute_accessor?( *attributes )

    return atomic_attribute_accessors.has_attributes?( *attributes )

  end

  ##############################
  #  atomic_attribute_reader?  #
  ##############################
    
  ###
  # Query whether attribute(s) are atomic readers.
  #
  # @overload atomic_attribute_accessor?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as atomic readers.
  #
  def atomic_attribute_reader?( *attributes )

    return atomic_attribute_readers.has_attributes?( *attributes )

  end

  ##############################
  #  atomic_attribute_writer?  #
  ##############################
  
  ###
  # Query whether attribute(s) are atomic writers.
  #
  # @overload atomic_attribute_accessor?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as atomic writers.
  #
  def atomic_attribute_writer?( *attributes )

    return atomic_attribute_writers.has_attributes?( *attributes )

  end

  #############################
  #  atomic_attribute_status  #
  #############################
  
  ###
  # Query atomic attribute(s) status (:reader/:writer/:accessor/nil).
  #
  # @param attribute Name of attribute.
  #
  # @return [:reader/:writer/:accessor/nil] Atomic attribute status.
  #
  def atomic_attribute_status( attribute )

    return atomic_attributes[ attribute ]

  end

  ###########################
  #  non_atomic_attribute?  #
  ###########################
  
  ###
  # Query whether attribute(s) has non-atomic reader or writer.
  #
  # @overload non_atomic_attribute?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as non-atomic readers or writers.
  #
  def non_atomic_attribute?( *attributes )

    return non_atomic_attributes.has_attributes?( *attributes )

  end

  ####################################
  #  non_atomic_attribute_accessor?  #
  ####################################
  
  ###
  # Query whether attribute(s) are both non-atomic readers and writers.
  #
  # @overload atomic_attribute_accessor?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as non-atomic readers and writers.
  #
  def non_atomic_attribute_accessor?( *attributes )

    return non_atomic_attribute_accessors.has_attributes?( *attributes )

  end

  ##################################
  #  non_atomic_attribute_reader?  #
  ##################################
  
  ###
  # Query whether attribute(s) are non-atomic readers.
  #
  # @overload atomic_attribute_accessor?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as non-atomic readers.
  #
  def non_atomic_attribute_reader?( *attributes )

    return non_atomic_attribute_readers.has_attributes?( *attributes )

  end

  ##################################
  #  non_atomic_attribute_writer?  #
  ##################################
  
  ###
  # Query whether attribute(s) are non-atomic writers.
  #
  # @overload atomic_attribute_accessor?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as non-atomic writers.
  #
  def non_atomic_attribute_writer?( *attributes )

    return non_atomic_attribute_writers.has_attributes?( *attributes )

  end

  #################################
  #  non_atomic_attribute_status  #
  #################################
  
  ###
  # Query non-atomic attribute(s) status (:reader/:writer/:accessor/nil).
  #
  # @param attribute Name of attribute.
  #
  # @return [:reader/:writer/:accessor/nil] Atomic attribute status.
  #
  def non_atomic_attribute_status( attribute )

    return non_atomic_attributes[ attribute ]

  end

  ###########################
  #  persistent_attribute?  #
  ###########################
  
  ###
  # Query whether attribute(s) has atomic or non-atomic reader or writer.
  #
  # @overload persistent_attribute?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as atomic or non-atomic readers or writers.
  #
  def persistent_attribute?( *attributes )

    return persistent_attributes.has_attributes?( *attributes )

  end

  ####################################
  #  persistent_attribute_accessor?  #
  ####################################
  
  ###
  # Query whether attribute(s) are either atomic or non-atomic readers and writers.
  #
  # @overload persistent_attribute_accessor?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as either atomic or non-atomic readers and writers.
  #
  def persistent_attribute_accessor?( *attributes )

    return persistent_attribute_accessors.has_attributes?( *attributes )

  end

  ##################################
  #  persistent_attribute_reader?  #
  ##################################
  
  ###
  # Query whether attribute(s) are atomic or non-atomic readers.
  #
  # @overload persistent_attribute_reader?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as atomic or non-atomic readers.
  #
  def persistent_attribute_reader?( *attributes )

    return persistent_attribute_readers.has_attributes?( *attributes )

  end

  ##################################
  #  persistent_attribute_writer?  #
  ##################################
  
  ###
  # Query whether attribute(s) are atomic or non-atomic writers.
  #
  # @overload persistent_attribute_reader?( attribute_name, ... )
  #
  #   @param attribute_name Name of attribute.
  #
  # @return [true,false] Whether object has attribute(s) as atomic or non-atomic writers.
  #
  def persistent_attribute_writer?( *attributes )

    return persistent_attribute_writers.has_attributes?( *attributes )

  end

  #################################
  #  persistent_attribute_status  #
  #################################
  
  ###
  # Query persistent attribute(s) status (:reader/:writer/:accessor/nil).
  #
  # @param attribute Name of attribute.
  #
  # @return [:reader/:writer/:accessor/nil] Persistent attribute status.
  #
  def persistent_attribute_status( attribute )

    return persistent_attributes[ attribute ]

  end
  
  #######################
  #  atomic_attributes  #
  #######################
  
  ###
  #
  # @method atomic_attributes
  #
  # Hash tracking atomic attribute status
  #
  # @return [CompositingHash] Hash extended with {::Persistence::Object::Complex::Attributes::AttributesHash 
  #   Persistence::Object::Complex::Attributes::AttributesHash}.
  #
  attr_hash  :atomic_attributes, AttributesHash do

    #=======================#
    #  update_for_addition  #
    #=======================#

    def update_for_addition( key, reader_writer_accessor )

      configuration_instance.instance_eval do

        # remove from non-atomic attributes
        non_atomic_attributes.subtract_without_hooks( key, reader_writer_accessor )
        
        # add to persistent attributes
        persistent_attributes.add_without_hooks( key, reader_writer_accessor )

        non_atomic_attribute_accessors.delete_without_hooks( key )
        
        case reader_writer_accessor

          when :reader

            atomic_attribute_readers.push_without_hooks( key )

            persistent_attribute_readers.push_without_hooks( key )

            non_atomic_attribute_readers.delete_without_hooks( key )
            
            if atomic_attribute_writers.include?( key )
              atomic_attribute_accessors.push_without_hooks( key )
            end

          when :writer

            atomic_attribute_writers.push_without_hooks( key )

            persistent_attribute_writers.push_without_hooks( key )

            non_atomic_attribute_writers.delete_without_hooks( key )

            if atomic_attribute_readers.include?( key )
              atomic_attribute_accessors.push_without_hooks( key )
            end

          when :accessor

            atomic_attribute_readers.push_without_hooks( key )
            atomic_attribute_writers.push_without_hooks( key )
            atomic_attribute_accessors.push_without_hooks( key )

            persistent_attribute_readers.push_without_hooks( key )
            persistent_attribute_writers.push_without_hooks( key )
            persistent_attribute_accessors.push_without_hooks( key )

            non_atomic_attribute_writers.delete_without_hooks( key )
            non_atomic_attribute_readers.delete_without_hooks( key )
            non_atomic_attribute_accessors.delete_without_hooks( key )

        end
        
      end
      
    end

    #==========================#
    #  update_for_subtraction  #
    #==========================#

    def update_for_subtraction( key, reader_writer_accessor )
      
      configuration_instance.instance_eval do
        
        # subtract from persistent attributes
        persistent_attributes.subtract_without_hooks( key, reader_writer_accessor )

        atomic_attribute_accessors.delete_without_hooks( key )
      
        case reader_writer_accessor
          when :reader
            atomic_attribute_readers.delete_without_hooks( key )
          when :writer
            atomic_attribute_writers.delete_without_hooks( key )
          when :accessor
            atomic_attribute_writers.delete_without_hooks( key )
            atomic_attribute_readers.delete_without_hooks( key )
        end
        
      end
      
    end
    
    #=======#
    #  []=  #
    #=======#

    def []=( key, reader_writer_accessor )

      if reader_writer_accessor

        super( key, reader_writer_accessor )
        
        unless @without_hooks

          configuration_instance.persistent_attributes.add_without_hooks( key, 
                                                                          reader_writer_accessor )
          
          case reader_writer_accessor

            when :reader

              configuration_instance.instance_eval do

                atomic_attribute_readers.push_without_hooks( key )

                persistent_attribute_readers.push_without_hooks( key )

                non_atomic_attributes.subtract_without_hooks( key, :reader )
                non_atomic_attribute_readers.delete_without_hooks( key )
                non_atomic_attribute_accessors.delete_without_hooks( key )

              end

            when :writer

              configuration_instance.instance_eval do

                atomic_attribute_writers.push_without_hooks( key )

                persistent_attribute_writers.push_without_hooks( key )

                non_atomic_attributes.subtract_without_hooks( key, :writer )
                non_atomic_attribute_writers.delete_without_hooks( key )
                non_atomic_attribute_accessors.delete_without_hooks( key )

              end

            when :accessor

              configuration_instance.instance_eval do

                atomic_attribute_writers.push_without_hooks( key )
                atomic_attribute_readers.push_without_hooks( key )
                atomic_attribute_accessors.push_without_hooks( key )

                persistent_attribute_readers.push_without_hooks( key )
                persistent_attribute_writers.push_without_hooks( key )
                persistent_attribute_accessors.push_without_hooks( key )

                non_atomic_attributes.subtract_without_hooks( key, :accessor )
                non_atomic_attribute_readers.delete_without_hooks( key )
                non_atomic_attribute_writers.delete_without_hooks( key )
                non_atomic_attribute_accessors.delete_without_hooks( key )

              end
          end
        
        end
        
      else

        # if we have nil we are actually deleting
        delete( key )
        
      end
      
      return reader_writer_accessor
      
    end

  end

  ###########################
  #  non_atomic_attributes  #
  ###########################
  
  ###
  #
  # @method non_atomic_attributes
  #
  # Hash tracking non-atomic attribute status
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesHash 
  #   Persistence::Object::Complex::Attributes::AttributesHash}.
  #
  attr_hash  :non_atomic_attributes, AttributesHash do

    #=======================#
    #  update_for_addition  #
    #=======================#

    def update_for_addition( key, reader_writer_accessor )
    
      configuration_instance.instance_eval do
        
        # remove from non-atomic attributes
        atomic_attributes.subtract( key, reader_writer_accessor )
        
        # add to persistent attributes
        persistent_attributes.add_without_hooks( key, reader_writer_accessor )

        atomic_attribute_accessors.delete( key )
        
        case reader_writer_accessor
          
          when :reader
            
            non_atomic_attribute_readers.push( key )

            persistent_attribute_readers.push_without_hooks( key )
            
            atomic_attribute_readers.delete( key )

            if non_atomic_attribute_writers.include?( key )
              non_atomic_attribute_accessors.push_without_hooks( key )
            end

          when :writer

            non_atomic_attribute_writers.push( key )

            persistent_attribute_writers.push_without_hooks( key )

            atomic_attribute_writers.delete( key )

            if non_atomic_attribute_readers.include?( key )
              non_atomic_attribute_accessors.push_without_hooks( key )
            end

          when :accessor

            non_atomic_attribute_accessors.push( key )
            non_atomic_attribute_writers.push( key )
            non_atomic_attribute_readers.push( key )

            persistent_attribute_readers.push_without_hooks( key )
            persistent_attribute_writers.push_without_hooks( key )
            persistent_attribute_accessors.push_without_hooks( key )

            atomic_attribute_writers.delete( key )
            atomic_attribute_readers.delete( key )

        end
        
      end
      
    end
    
    #==========================#
    #  update_for_subtraction  #
    #==========================#

    def update_for_subtraction( key, reader_writer_accessor )

      configuration_instance.instance_eval do
        
        # subtract from persistent attributes
        persistent_attributes.subtract_without_hooks( key, reader_writer_accessor )

        non_atomic_attribute_accessors.delete_without_hooks( key )
      
        case reader_writer_accessor
          when :reader
            non_atomic_attribute_readers.delete_without_hooks( key )
          when :writer
            non_atomic_attribute_writers.delete_without_hooks( key )
          when :accessor
            non_atomic_attribute_writers.delete_without_hooks( key )
            non_atomic_attribute_readers.delete_without_hooks( key )
        end
        
      end
      
    end
    
    #=======#
    #  []=  #
    #=======#

    def []=( key, reader_writer_accessor )

      if reader_writer_accessor

        super( key, reader_writer_accessor )
        
        unless @without_hooks

          configuration_instance.persistent_attributes.add_without_hooks( key, 
                                                                          reader_writer_accessor )
          case reader_writer_accessor

            when :reader

              configuration_instance.instance_eval do

                non_atomic_attribute_readers.push_without_hooks( key )

                persistent_attribute_readers.push_without_hooks( key )

                atomic_attributes.subtract_without_hooks( key, :reader )
                atomic_attribute_readers.delete_without_hooks( key )
                atomic_attribute_accessors.delete_without_hooks( key )


              end

            when :writer

              configuration_instance.instance_eval do

                non_atomic_attribute_writers.push_without_hooks( key )

                persistent_attribute_writers.push_without_hooks( key )

                atomic_attributes.subtract_without_hooks( key, :writer )
                atomic_attribute_writers.delete_without_hooks( key )
                atomic_attribute_accessors.delete_without_hooks( key )

              end

            when :accessor

              configuration_instance.instance_eval do

                non_atomic_attribute_writers.push_without_hooks( key )
                non_atomic_attribute_readers.push_without_hooks( key )
                non_atomic_attribute_accessors.push_without_hooks( key )

                persistent_attribute_readers.push_without_hooks( key )
                persistent_attribute_writers.push_without_hooks( key )
                persistent_attribute_accessors.push_without_hooks( key )

                atomic_attributes.subtract_without_hooks( key, :accessor )
                atomic_attribute_readers.delete_without_hooks( key )
                atomic_attribute_writers.delete_without_hooks( key )
                atomic_attribute_accessors.delete_without_hooks( key )

              end
          end
        
        end
        
      else

        # if we have nil we are actually deleting
        delete( key )
        
      end
      
      return reader_writer_accessor
      
    end
        
  end

  ###########################
  #  persistent_attributes  #
  ###########################
  
  ###
  #
  # @method persistent_attributes
  #
  # Hash tracking persistent attribute status
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesHash 
  #   Persistence::Object::Complex::Attributes::AttributesHash} and {::Persistence::Object::Complex::Attributes::AttributesHash 
  #   Persistence::Object::Complex::Attributes::DefaultAtomicNonAtomic}.
  #
  attr_hash  :persistent_attributes, AttributesHash, DefaultAtomicNonAtomic do

    #===================#
    #  default_atomic!  #
    #===================#

    def default_atomic!
      
      super
      
      unless @without_hooks
      
        configuration_instance.instance_eval do
        
          persistent_attribute_accessors.default_atomic_without_hooks!
          persistent_attribute_writers.default_atomic_without_hooks!
          persistent_attribute_readers.default_atomic_without_hooks!
        
        end

      end
      
    end

    #=======================#
    #  default_non_atomic!  #
    #=======================#

    def default_non_atomic!

      super

      unless @without_hooks
      
        configuration_instance.instance_eval do
        
          persistent_attribute_accessors.default_non_atomic_without_hooks!
          persistent_attribute_writers.default_non_atomic_without_hooks!
          persistent_attribute_readers.default_non_atomic_without_hooks!
        
        end

      end
      
    end

    #=======================#
    #  update_for_addition  #
    #=======================#

    def update_for_addition( key, reader_writer_accessor )
    end
    
    #==========================#
    #  update_for_subtraction  #
    #==========================#

    def update_for_subtraction( key, reader_writer_accessor )
    end
    
    #=======#
    #  add  #
    #=======#
    
    def add( key, reader_writer_accessor )
      
      return_value = nil
      
      if @without_hooks or @redirecting_to_atomic_or_non_atomic

        return_value = super( key, reader_writer_accessor )

      else

        @redirecting_to_atomic_or_non_atomic = true

        if @default_atomic
          atomic_attributes = configuration_instance.atomic_attributes
          return_value = atomic_attributes.add( key, reader_writer_accessor )
        else
          non_atomic_attributes = configuration_instance.non_atomic_attributes
          return_value = non_atomic_attributes.add( key, reader_writer_accessor )
        end

        @redirecting_to_atomic_or_non_atomic = false

      end
      
      return return_value
      
    end
    
    #============#
    #  subtract  #
    #============#
    
    def subtract( key, reader_writer_accessor )

      return_value = nil

      if @without_hooks or @redirecting_to_atomic_or_non_atomic
        
        return_value = super( key, reader_writer_accessor )
        
      else

        @redirecting_to_atomic_or_non_atomic = true

        if @default_atomic
          atomic_attributes = configuration_instance.atomic_attributes
          return_value = atomic_attributes.subtract( key, reader_writer_accessor )
        else
          non_atomic_attributes = configuration_instance.non_atomic_attributes
          return_value = non_atomic_attributes.subtract( key, reader_writer_accessor )
        end
      
        @redirecting_to_atomic_or_non_atomic = false
      
      end
      
      return return_value
      
    end
    
    #=======#
    #  []=  #
    #=======#
    
    def []=( key, reader_writer_accessor )
      
      return_value = nil
      
      if @without_hooks or @redirecting_to_atomic_or_non_atomic
        
        return_value = super( key, reader_writer_accessor )
        
      else

        @redirecting_to_atomic_or_non_atomic = true
        
        if @default_atomic
          return_value = configuration_instance.atomic_attributes[ key ] = reader_writer_accessor
        else
          return_value = configuration_instance.non_atomic_attributes[ key ] = reader_writer_accessor
        end

        @redirecting_to_atomic_or_non_atomic = false

      end
      
      return return_value
      
    end
    
  end

  ##############################
  #  atomic_attribute_readers  #
  ##############################

  ###
  #
  # @method atomic_attribute_readers
  #
  # Array tracking atomic attribute readers
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray}.
  #
  attr_sorted_unique_array :atomic_attribute_readers, AttributesArray do

    #=================#
    #  post_set_hook  #
    #=================#
    
    def post_set_hook( index, object, is_insert )
      
      configuration_instance.instance_eval do
        
        atomic_attributes.add_without_hooks( object, :reader )
        non_atomic_attributes.subtract_without_hooks( object, :reader )
        
        non_atomic_attribute_readers.delete_without_hooks( object )
        
      end
      
      return object
      
    end

    #====================#
    #  post_delete_hook  #
    #====================#
    
    def post_delete_hook( index, object )
      
      configuration_instance.instance_eval do
        
        atomic_attributes.subtract_without_hooks( object, :reader )
        
        atomic_attribute_accessors.delete( object )
        
        unless non_atomic_attribute_readers.include?( object )
          
          persistent_attributes.subtract_without_hooks( object, :reader )
          persistent_attribute_readers.delete_without_hooks( object )
          
        end
        
      end
      
      return object
      
    end
    
  end

  ##############################
  #  atomic_attribute_writers  #
  ##############################

  ###
  #
  # @method atomic_attribute_writers
  #
  # Array tracking atomic attribute writers.
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray}.
  #
  attr_sorted_unique_array :atomic_attribute_writers, AttributesArray do
    
    #=================#
    #  post_set_hook  #
    #=================#
    
    def post_set_hook( index, object, is_insert )
      
      configuration_instance.instance_eval do
        
        atomic_attributes.add_without_hooks( object, :writer )
        non_atomic_attributes.subtract_without_hooks( object, :writer )
        
        non_atomic_attribute_writers.delete_without_hooks( object )
        
      end
      
      return object
      
    end
    
    #====================#
    #  post_delete_hook  #
    #====================#
    
    def post_delete_hook( index, object )
      
      configuration_instance.instance_eval do
        
        atomic_attributes.subtract_without_hooks( object, :writer )
        
        atomic_attribute_accessors.delete( object )
        
        unless non_atomic_attribute_writers.include?( object )
          
          persistent_attributes.subtract_without_hooks( object, :writer )
          persistent_attribute_writers.delete_without_hooks( object )
          
        end
        
      end
      
      return object
      
    end
    
  end

  ################################
  #  atomic_attribute_accessors  #
  ################################

  ###
  #
  # @method atomic_attribute_accessors
  #
  # Array tracking atomic attribute accessors.
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray}.
  #
  attr_sorted_unique_array :atomic_attribute_accessors, AttributesArray do
    
    #=================#
    #  post_set_hook  #
    #=================#
    
    def post_set_hook( index, object, is_insert )
      
      configuration_instance.instance_eval do
        
        atomic_attributes.add_without_hooks( object, :accessor )
        non_atomic_attributes.subtract_without_hooks( object, :accessor )
        
        non_atomic_attribute_writers.delete_without_hooks( object )
        
      end
      
      return object
      
    end
    
    #====================#
    #  post_delete_hook  #
    #====================#
    
    def post_delete_hook( index, object )
      
      configuration_instance.instance_eval do
        
        atomic_attributes.delete_without_hooks( object )
        
        atomic_attribute_accessors.delete_without_hooks( object )
        atomic_attribute_readers.delete_without_hooks( object )
        atomic_attribute_writers.delete_without_hooks( object )
        
        persistent_attributes.delete_without_hooks( object )
        persistent_attribute_readers.delete_without_hooks( object )
        persistent_attribute_writers.delete_without_hooks( object )
        
      end
      
      return object
      
    end
    
  end

  ##################################
  #  non_atomic_attribute_readers  #
  ##################################

  ###
  #
  # @method non_atomic_attribute_readers
  #
  # Array tracking non-atomic attribute readers.
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray}.
  #
  attr_sorted_unique_array :non_atomic_attribute_readers, AttributesArray do

    #=================#
    #  post_set_hook  #
    #=================#
    
    def post_set_hook( index, object, is_insert )
      
      configuration_instance.instance_eval do
        
        non_atomic_attributes.add_without_hooks( object, :reader )
        atomic_attributes.subtract_without_hooks( object, :reader )
        
        atomic_attribute_readers.delete_without_hooks( object )
        
      end
      
      return object
      
    end

    #====================#
    #  post_delete_hook  #
    #====================#
    
    def post_delete_hook( index, object )
      
      configuration_instance.instance_eval do
        
        non_atomic_attributes.subtract_without_hooks( object, :reader )
        
        non_atomic_attribute_accessors.delete( object )
        
        unless atomic_attribute_readers.include?( object )
          
          persistent_attributes.subtract_without_hooks( object, :reader )
          persistent_attribute_readers.delete_without_hooks( object )
          
        end
        
      end
      
      return object
      
    end
    
  end

  ##################################
  #  non_atomic_attribute_writers  #
  ##################################

  ###
  #
  # @method non_atomic_attribute_writers
  #
  # Array tracking non-atomic attribute writers.
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray}.
  #
  attr_sorted_unique_array :non_atomic_attribute_writers, AttributesArray do
    
    #=================#
    #  post_set_hook  #
    #=================#
    
    def post_set_hook( index, object, is_insert )
      
      configuration_instance.instance_eval do
        
        non_atomic_attributes.add_without_hooks( object, :writer )
        atomic_attributes.subtract_without_hooks( object, :writer )
        
        atomic_attribute_writers.delete_without_hooks( object )
        
      end
      
      return object
      
    end
    
    #====================#
    #  post_delete_hook  #
    #====================#
    
    def post_delete_hook( index, object )
      
      configuration_instance.instance_eval do
        
        non_atomic_attributes.subtract_without_hooks( object, :writer )
        
        non_atomic_attribute_accessors.delete( object )
        
        unless atomic_attribute_writers.include?( object )
          
          persistent_attributes.subtract_without_hooks( object, :writer )
          persistent_attribute_writers.delete_without_hooks( object )
          
        end
        
      end
      
      return object
      
    end
    
  end

  ####################################
  #  non_atomic_attribute_accessors  #
  ####################################

  ###
  #
  # @method non_atomic_attribute_accessors
  #
  # Array tracking non-atomic attribute accessors.
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray}.
  #
  attr_sorted_unique_array :non_atomic_attribute_accessors, AttributesArray do
    
    #=================#
    #  post_set_hook  #
    #=================#
    
    def post_set_hook( index, object, is_insert )
      
      configuration_instance.instance_eval do
        
        non_atomic_attributes.add_without_hooks( object, :accessor )
        atomic_attributes.subtract_without_hooks( object, :accessor )
        
        atomic_attribute_writers.delete_without_hooks( object )
        
      end
      
      return object
      
    end
    
    #====================#
    #  post_delete_hook  #
    #====================#
    
    def post_delete_hook( index, object )
      
      configuration_instance.instance_eval do
        
        non_atomic_attributes.delete_without_hooks( object )
        
        non_atomic_attribute_accessors.delete_without_hooks( object )
        non_atomic_attribute_readers.delete_without_hooks( object )
        non_atomic_attribute_writers.delete_without_hooks( object )
        
        persistent_attributes.delete_without_hooks( object )
        persistent_attribute_readers.delete_without_hooks( object )
        persistent_attribute_writers.delete_without_hooks( object )
        
      end
      
      return object
      
    end
    
  end

  ##################################
  #  persistent_attribute_readers  #
  ##################################

  ###
  #
  # @method persistent_attribute_readers
  #
  # Array tracking persistent attribute readers.
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray} and 
  #   {::Persistence::Object::Complex::Attributes::DefaultAtomicNonAtomic 
  #   Persistence::Object::Complex::Attributes::DefaultAtomicNonAtomic}.
  #
  attr_sorted_unique_array :persistent_attribute_readers, AttributesArray, DefaultAtomicNonAtomic do

    #===================#
    #  default_atomic!  #
    #===================#

    def default_atomic!
      
      super
      
      unless @without_hooks

        configuration_instance.instance_eval do
        
          persistent_attributes.default_atomic_without_hooks!
          persistent_attribute_writers.default_atomic_without_hooks!
          persistent_attribute_accessors.default_atomic_without_hooks!
        
        end

      end
      
    end

    #=======================#
    #  default_non_atomic!  #
    #=======================#

    def default_non_atomic!

      super
      
      unless @without_hooks

        configuration_instance.instance_eval do
        
          persistent_attributes.default_non_atomic_without_hooks!
          persistent_attribute_writers.default_non_atomic_without_hooks!
          persistent_attribute_accessors.default_non_atomic_without_hooks!
        
        end

      end
      
    end

    #=======#
    #  []=  #
    #=======#
    
    def []=( index, reader_writer_accessor )
      
      return_value = nil
      
      if @without_hooks or @redirecting_to_atomic_or_non_atomic
        
        return_value = super( index, reader_writer_accessor )
        
      else

        @redirecting_to_atomic_or_non_atomic = true
        
        if @default_atomic
          atomic_attribute_readers = configuration_instance.atomic_attribute_readers
          return_value = atomic_attribute_readers[ index ] = reader_writer_accessor
        else
          non_atomic_attribute_readers = configuration_instance.non_atomic_attribute_readers
          return_value = non_atomic_attribute_readers[ index ] = reader_writer_accessor
        end

        @redirecting_to_atomic_or_non_atomic = false

      end
      
      return return_value
      
    end
     
     #==========#
     #  insert  #
     #==========#

     def insert( index, *reader_writer_accessors )

       return_value = nil

       if @without_hooks or @redirecting_to_atomic_or_non_atomic

         return_value = super( index, *reader_writer_accessors )

       else

         @redirecting_to_atomic_or_non_atomic = true

         if @default_atomic
           atomic_attribute_readers = configuration_instance.atomic_attribute_readers
           return_value = atomic_attribute_readers.insert( index, *reader_writer_accessors )
         else
           non_atomic_attribute_readers = configuration_instance.non_atomic_attribute_readers
           return_value = non_atomic_attribute_readers.insert( index, *reader_writer_accessors )
         end

         @redirecting_to_atomic_or_non_atomic = false

       end

       return return_value

      end
        
  end

  ##################################
  #  persistent_attribute_writers  #
  ##################################

  ###
  #
  # @method persistent_attribute_writers
  #
  # Array tracking persistent attribute writers.
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray} and 
  #   {::Persistence::Object::Complex::Attributes::DefaultAtomicNonAtomic 
  #   Persistence::Object::Complex::Attributes::DefaultAtomicNonAtomic}.
  #
  attr_sorted_unique_array :persistent_attribute_writers, AttributesArray, DefaultAtomicNonAtomic do
    
    #===================#
    #  default_atomic!  #
    #===================#

    def default_atomic!
      
      super
      
      unless @without_hooks

        configuration_instance.instance_eval do
        
          persistent_attributes.default_atomic_without_hooks!
          persistent_attribute_readers.default_atomic_without_hooks!
          persistent_attribute_accessors.default_atomic_without_hooks!
        
        end

      end
      
    end

    #=======================#
    #  default_non_atomic!  #
    #=======================#

    def default_non_atomic!

      super
      
      unless @without_hooks

        configuration_instance.instance_eval do
        
          persistent_attributes.default_non_atomic_without_hooks!
          persistent_attribute_readers.default_non_atomic_without_hooks!
          persistent_attribute_accessors.default_non_atomic_without_hooks!
        
        end

      end
      
    end
    
    #=======#
    #  []=  #
    #=======#
    
    def []=( index, reader_writer_accessor )
      
      return_value = nil
      
      if @without_hooks or @redirecting_to_atomic_or_non_atomic
        
        return_value = super( index, reader_writer_accessor )
        
      else

        @redirecting_to_atomic_or_non_atomic = true
        
        if @default_atomic
          atomic_attribute_writers = configuration_instance.atomic_attribute_writers
          return_value = atomic_attribute_writers[ index ] = reader_writer_accessor
        else
          non_atomic_attribute_writers = configuration_instance.non_atomic_attribute_writers
          return_value = non_atomic_attribute_writers[ index ] = reader_writer_accessor
        end

        @redirecting_to_atomic_or_non_atomic = false

      end
      
      return return_value
      
    end
     
     #==========#
     #  insert  #
     #==========#

     def insert( index, *reader_writer_accessors )

       return_value = nil

       if @without_hooks or @redirecting_to_atomic_or_non_atomic

         return_value = super( index, *reader_writer_accessors )

       else

         @redirecting_to_atomic_or_non_atomic = true

         if @default_atomic
           atomic_attribute_writers = configuration_instance.atomic_attribute_writers
           return_value = atomic_attribute_writers.insert( index, *reader_writer_accessors )
         else
           non_atomic_attribute_writers = configuration_instance.non_atomic_attribute_writers
           return_value = non_atomic_attribute_writers.insert( index, *reader_writer_accessors )
         end

         @redirecting_to_atomic_or_non_atomic = false

       end

       return return_value

      end
    
  end

  ####################################
  #  persistent_attribute_accessors  #
  ####################################

  ###
  #
  # @method persistent_attribute_accessors
  #
  # Array tracking persistent attribute accessors.
  #
  # @return [CompositingHash] CompositingHash extended with {::Persistence::Object::Complex::Attributes::AttributesArray 
  #   Persistence::Object::Complex::Attributes::AttributesArray} and 
  #   {::Persistence::Object::Complex::Attributes::DefaultAtomicNonAtomic 
  #   Persistence::Object::Complex::Attributes::DefaultAtomicNonAtomic}.
  #
  attr_sorted_unique_array :persistent_attribute_accessors, AttributesArray, DefaultAtomicNonAtomic do
    
    #===================#
    #  default_atomic!  #
    #===================#

    def default_atomic!
      
      super
      
      unless @without_hooks
      
        configuration_instance.instance_eval do
        
          persistent_attributes.default_atomic_without_hooks!
          persistent_attribute_writers.default_atomic_without_hooks!
          persistent_attribute_readers.default_atomic_without_hooks!
        
        end

      end
      
    end

    #=======================#
    #  default_non_atomic!  #
    #=======================#

    def default_non_atomic!

      super

      unless @without_hooks
      
        configuration_instance.instance_eval do
        
          persistent_attributes.default_non_atomic_without_hooks!
          persistent_attribute_writers.default_non_atomic_without_hooks!
          persistent_attribute_readers.default_non_atomic_without_hooks!
        
        end

      end
      
    end
    
    #=======#
    #  []=  #
    #=======#
    
    def []=( index, reader_writer_accessor )
      
      return_value = nil
      
      if @without_hooks or @redirecting_to_atomic_or_non_atomic
        
        return_value = super( index, reader_writer_accessor )
        
      else

        @redirecting_to_atomic_or_non_atomic = true
        
        if @default_atomic
          atomic_attribute_accessors = configuration_instance.atomic_attribute_accessors
          return_value = atomic_attribute_accessors[ index ] = reader_writer_accessor
        else
          non_atomic_attribute_accessors = configuration_instance.non_atomic_attribute_accessors
          return_value = non_atomic_attribute_accessors[ index ] = reader_writer_accessor
        end

        @redirecting_to_atomic_or_non_atomic = false

      end
      
      return return_value
      
    end
     
     #==========#
     #  insert  #
     #==========#

     def insert( index, *reader_writer_accessors )

       return_value = nil

       if @without_hooks or @redirecting_to_atomic_or_non_atomic

         return_value = super( index, *reader_writer_accessors )

       else

         @redirecting_to_atomic_or_non_atomic = true

         if @default_atomic
           atomic_attribute_accessors = configuration_instance.atomic_attribute_accessors
           return_value = atomic_attribute_accessors.insert( index, *reader_writer_accessors )
         else
           non_atomic_attribute_accessors = configuration_instance.non_atomic_attribute_accessors
           return_value = non_atomic_attribute_accessors.insert( index, *reader_writer_accessors )
         end

         @redirecting_to_atomic_or_non_atomic = false

       end

       return return_value

      end
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ###################
  #  define_reader  #
  ###################

  ###
  # Define attribute reader.
  #
  def define_reader( attribute )
    
    instance_controller = ::CascadingConfiguration::Core::InstanceController.create_instance_controller( self )
    
    instance_controller.define_instance_method( attribute ) do

      return get_attribute( attribute )
      
    end

    return self

  end

  ###################
  #  define_writer  #
  ###################

  ###
  # Define attribute writer.
  #
  def define_writer( attribute )

    write_accessor_name = attribute.write_accessor_name

    instance_controller = ::CascadingConfiguration::Core::InstanceController.create_instance_controller( self )

    instance_controller.define_instance_method( write_accessor_name ) do |value|

      return set_attribute( attribute, value )
      
    end
    
    return self

  end
  
  ############################
  #  define_atomic_accessor  #
  ############################

  ###
  # Define attribute accessor.
  #
  def define_atomic_accessor( attribute )
    define_reader( attribute )
    define_writer( attribute )
    return self
  end

end
