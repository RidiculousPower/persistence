
###
# Common module to all index instances that serves as base index type.
#
module ::Persistence::Object::Index
  
  include ::CascadingConfiguration::Setting

  include ::Enumerable
  
  ################
  #  initialize  #
  ################

  ###
  # 
  # @param index_name Name of index.
  #
  # @param parent_bucket Bucket index is on.
  #
  # @param permits_duplicates Whether index permits duplicate entries.
  #
  # @param sorting_proc_or_sort_names Proc to use for sorting or name of sort method.
  #
  # @param duplicates_sorting_proc_or_sort_names Proc to use for sorting duplicates or name of sort method.
  #
  # @param ancestor_index_instance Instance to use as ancestor for configuration values.
  #
  def initialize( index_name, 
                  parent_bucket, 
                  permits_duplicates = nil, 
                  sorting_proc_or_sort_names = nil, 
                  duplicates_sorting_proc_or_sort_names = nil,
                  ancestor_index_instance = nil )

    if index_name
      self.name = index_name
    end
    
    if ancestor_index_instance
      encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default )
      encapsulation.register_child_for_parent( self, ancestor_index_instance )
    end
    
    unless permits_duplicates.nil?
      self.permits_duplicates = permits_duplicates
    end
    
    if sorting_proc_or_sort_names or duplicates_sorting_proc_or_sort_names
      init_sorting_procs( sorting_proc_or_sort_names, duplicates_sorting_proc_or_sort_names )
    end
    
    initialize_for_bucket( parent_bucket )

  end

  ##########
  #  name  #
  ##########

  ###
  # Index name
  # 
  # @return [Symbol,String] Index name.
  #
  attr_setting  :name

  ########################
  #  permits_duplicates  #
  ########################

  ###
  # Query whether index permits duplicates.
  # 
  # @return [true,false] Whether index permits duplicates.
  #
  attr_setting :permits_duplicates?
  
  self.permits_duplicates = false

  ###################
  #  parent_bucket  #
  ###################

  ###
  # Get reference to bucket index indexes.
  # 
  # @return [Persistence::Port::Bucket] Bucket index is on.
  #
  attr_reader  :parent_bucket

  ###########################
  #  initialize_for_bucket  #
  ###########################
  
  ###
  # @private
  #
  # Initialize for parent bucket.
  #
  # @param parent_bucket Reference to bucket index indexes.
  #
  def initialize_for_bucket( parent_bucket )

    @parent_bucket = parent_bucket

    # object indexes are held and run by the classes/modules that define them
    # synchronize the index instance with the parent bucket's adapter instance

    if adapter_bucket = parent_bucket.instance_variable_get( :@adapter_bucket )
      
      index_name = name

      if adapter_bucket.has_index?( index_name )

        @adapter_index = adapter_bucket.index( index_name )

        # if index has aleady been declared and permits_duplicates does not match, raise error
        # double ! ensures equality for false == nil
        if ! permits_duplicates? != ! @adapter_index.permits_duplicates?
           raise ::Persistence::Exception::ConflictingIndexAlreadyDeclared, 
                 'Index ' + index_name.to_s + ' has already been declared, ' +
                 'and new duplicates declaration does not match existing declaration.'
        end

      else
      
        # get adapter index instance in adapter bucket
        @adapter_index = parent_bucket.adapter_bucket.create_index( index_name, permits_duplicates? )

      end

    else
      
      parent_bucket.pend_index( self )
    
    end
    
  end

  #############
  #  disable  #
  #############

  ###
  # @private
  # 
  # Disable bucket. Used internally by port when port is disabled.
  #
  def disable

    @adapter_index = nil
    
  end

  ########################
  #  init_sorting_procs  #
  ########################
  
  ###
  # @private
  #
  # Initializes sorting procs from procs or sorting method names.
  #
  # @param sorting_proc_or_sort_name Proc to use for sorting or name of sort method.
  #
  # @param duplicates_sorting_proc_or_sort_name Proc to use for sorting duplicates or name of sort method.
  #
  def init_sorting_procs( sorting_proc_or_sort_name, duplicates_sorting_proc_or_sort_name )
    
    if sorting_proc_or_sort_name
      
      if sorting_proc_or_sort_name.is_a?( ::Proc )

        @sorting_procs = sorting_proc_or_sort_name

      else
      
        @sorting_procs = sorting_proc_for_sort_name( sorting_proc_or_sort_name )
      
      end
      
    end
    
    if duplicates_sorting_proc_or_sort_name

      if duplicates_sorting_proc_or_sort_name.is_a?( ::Proc )
       
        @duplicates_sorting_procs = duplicates_sorting_proc_or_sort_name

      else

        @duplicates_sorting_procs = sorting_proc_for_sort_name( sorting_proc_or_sort_name )
      
      end

    end
    
  end

  ################################
  #  sorting_proc_for_sort_name  #
  ################################

  ###
  # @private
  #
  # Get sorting proc associated with sorting method name. PENDING.
  #
  # @param sort_name Name of sorting method.
  #
  # @return [Proc] Sorting proc.
  #
  def sorting_proc_for_sort_name( sort_name )
    
    raise 'Pending'
    
    sorting_proc = nil
    
    case sort_name

      when :alpha

      when :numeric
      
      when :alpha_numeric
      
      when :numeric_alpha
    
      when :upper_lower

      when :lower_upper
    
      when :upper_lower_numeric
      
      when :lower_upper_numeric
      
      when :numeric_upper_lower
      
      when :numeric_lower_upper
    
      when :reverse_alpha
      
      when :reverse_alpha_numeric
      
      when :reverse_numeric_alpha

      when :reverse_upper_lower_numeric
      
      when :reverse_lower_upper_numeric
      
      when :reverse_numeric_upper_lower
      
      when :reverse_numeric_lower_upper
    
    end
  
    return sorting_proc
  
  end

  ############
  #  cursor  #
  ############

  ###
  # Create and return cursor instance for this index.
  #
  # @return [Persistence::Cursor] New cursor instance.
  #
  def cursor( *args, & block )

    cursor_instance = ::Persistence::Cursor.new( @parent_bucket, self )
    
    if args.count > 0
      cursor_instance.persisted?( *args )
    end
    
    if block_given?
      cursor_instance = cursor_instance.instance_eval( & block )
      cursor_instance.close
    end
    
    return cursor_instance
  
  end

  ###################
  #  atomic_cursor  #
  ###################

  ###
  # Create and return cursor instance for this index enabled to load all object properties as atomic.
  #   See Persistence::Cursor#atomize.
  #
  # @return [Persistence::Cursor] New cursor instance.
  #
  def atomic_cursor( *args, & block )
  
    return cursor( *args, & block ).atomize
  
  end

  ##########
  #  each  #
  ##########

  ###
  # Iterate objects in current bucket.
  #
  # @yield [object] Current object.
  #
  # @yieldparam object Object stored in index.
  #
  def each( & block )

    return atomic_cursor.each( & block )

  end

  ############################
  #  index_existing_objects  #
  ############################

  ###
  # Index objects that currently exist in parent bucket.
  #
  # @return self
  #
  def index_existing_objects
    
    @parent_bucket.each do |this_object|
      index_object( this_object )
    end

    return self
  
  end
  alias_method :sync_index, :index_existing_objects

  ###################
  #  adapter_index  #
  ###################
  
  ###
  # Get adapter index (provided by adapter) associated with bucket index (provided by 
  #   {Persistence::Object::Index Persistence::Object::Index}). 
  #
  def adapter_index

    unless @adapter_index
      raise 'Persistence port must be enabled first.'
    end
    
    return @adapter_index
    
  end

  ###########
  #  count  #
  ###########

  ###
  # Get the number of objects in index. See {::Enumerable}.
  #
  # @return [Integer] Number of objects in current cursor context.
  #
  def count( *args, & block )
    
    return_value = 0

    if block_given?
      return_value = super( & block )
    elsif args.empty?
      return_value = adapter_index.count
    else
      return_value = super( *args )
    end
    
    return return_value
    
  end
  
  ################
  #  persisted?  #
  ################

  ###
  # Query whether key exists in index.
  #
  # @return [true,false] Whether key exists in index.
  #
  def persisted?( key )

    return get_object_id( key ) ? true : false

  end

  ###################
  #  get_object_id  #
  ###################

  ###
  # Get object ID for key in index.
  #
  # @return [Object] Object persistence ID associated with key.
  #
  def get_object_id( key )

    return adapter_index.get_object_id( key )
  
  end

  ##################
  #  index_object  #
  ##################

  ###
  # Index key for object instance.
  #
  # @param object [Object] Object to index.
  #
  # @param key [Object] Key to use for index entry.
  #
  def index_object( object, key )

    return index_object_id( object.persistence_id, key )

  end

  #####################
  #  index_object_id  # 
  #####################
                     
  ###
  # Index key for object persistence ID.
  #
  # @param global_id [Object] Persistence ID associated with object to index.
  #
  # @param key [Object] Key to use for index entry.
  #
  def index_object_id( global_id, key )

    return adapter_index.index_object_id( global_id, key )

  end

  #############################
  #  delete_keys_for_object!  #
  #############################

  ###
  # Delete keys associated with object instance.
  #
  # @param object [Object] Object to index.
  #
  def delete_keys_for_object!( object )

    return delete_keys_for_object_id!( object.persistence_id )
    
  end

  ################################
  #  delete_keys_for_object_id!  #
  ################################

  ###
  # Delete keys associated with object persistence ID.
  #
  # @param global_id [Object] Persistence ID associated with object to index.
  #
  def delete_keys_for_object_id!( global_id )

    return adapter_index.delete_keys_for_object_id!( global_id )

  end

    
end
