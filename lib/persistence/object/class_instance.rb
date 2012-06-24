
module ::Persistence::Object::ClassInstance
  
  include ::Persistence::Object::ParsePersistenceArgs

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash

  include ::Enumerable

  ################################
  #  instance_persistence_port=  #
  #  store_using                 #
  #  persists_using              #
  ################################

  attr_setting :instance_persistence_port

  def instance_persistence_port=( port_object_port_or_port_name )

    port = nil
    
    case port_object_port_or_port_name
      
      when nil

        port = super( nil )
      
      when ::Persistence::Port
      
        port = super( port_object_port_or_port_name )

      when ::Symbol, ::String
      
        port = super( ::Persistence.port_for_name_or_port( port_object_port_or_port_name, true ) )
      
      else

        if port_object_port_or_port_name.respond_to?( :instance_persistence_port )

          # if arg responds to :instance_persistence_port we use arg's instance port
          port = super( port_object_port_or_port_name.instance_persistence_port )

        elsif port_object_port_or_port_name.respond_to?( :persistence_port )

          # if arg responds to :persistence_port we use arg's port
          port = super( port_object_port_or_port_name.persistence_port )

        end
      
    end
    
    if port
      # check encapsulation for instance persistence bucket - that way we avoid creating a loop
      encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default )
      if bucket = encapsulation.get_configuration( self, :instance_persistence_bucket )
        if port.enabled?
          bucket.initialize_for_port( port )
        else
          bucket.disable
        end
      end
      port.register_instance( self )
    end
    
    return port
    
  end
  
  alias_method :store_using,    :instance_persistence_port=

  alias_method :persists_using, :instance_persistence_port=

  ###############################
  #  instance_persistence_port  #
  ###############################

  def instance_persistence_port

    return super || ( self.instance_persistence_port = ::Persistence.current_port )
    
  end
  
  ##################################
  #  instance_persistence_bucket=  #
  #  store_as                      #
  #  persists_in                   #
  ##################################

  attr_setting :instance_persistence_bucket

  # declare name of persistence bucket where object instances will be stored
  def instance_persistence_bucket=( persistence_bucket_class_or_name )
    
    bucket = nil

    case persistence_bucket_class_or_name
      
      when nil

        bucket = super( nil )
      
      when ::String, ::Symbol
      
        if port = instance_persistence_port
          bucket = super( port.persistence_bucket( persistence_bucket_class_or_name.to_s ) )
        else
          bucket = super( ::Persistence.pending_bucket( self, persistence_bucket_class_or_name.to_s ) )
        end
      
      when ::Persistence::Bucket
      
        bucket = super( persistence_bucket_class_or_name )
      
      else

        if persistence_bucket_class_or_name.respond_to?( :persistence_bucket )
          bucket = super( persistence_bucket_class_or_name.persistence_bucket )
        end
      
    end

    return bucket
    
  end

  alias_method :store_as, :instance_persistence_bucket=
  alias_method :persists_in, :instance_persistence_bucket=
  
  #################################
  #  instance_persistence_bucket  #
  #################################

  def instance_persistence_bucket

    bucket_instance = nil
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default )
    
    unless bucket_instance = encapsulation.get_configuration( self, :instance_persistence_bucket )
      self.instance_persistence_bucket = to_s
      bucket_instance = super
    end
    
    return bucket_instance
    
  end
  
  #############
  #  persist  #
  #############
  
  def persist( *args )

    persistence_value = nil

    index_instance, key, no_key = parse_args_for_index_value_no_value( args )

    # if no key, open a cursor for a list
    if no_key

      persistence_value = ::Persistence::Cursor.new( instance_persistence_bucket, index_instance )

    else

      global_id = index_instance ? index_instance.get_object_id( key ) : key
      
      persistence_value = instance_persistence_port.get_object( global_id )

    end
    
    return persistence_value

  end

  ################
  #  persisted?  #
  ################

  def persisted?( *args )
    
    index_instance, key, no_key = parse_args_for_index_value_no_value( args )
    
    if no_key
      raise ::Persistence::Exception::KeyValueRequired,
              'Key required when specifying index for :persist!'
    end
    
    global_id = index_instance ? index_instance.get_object_id( key ) : key
    
    return instance_persistence_port.get_bucket_name_for_object_id( global_id ) ? true : false
  
  end

  ############
  #  cease!  #
  ############
  
  ###
  # Remove object properties stored for object ID from persistence bucket and indexes.
  #
  # @param global_id Object persistence ID.
  #
  def cease!( *args )
    
    # FIX - future: archive if appropriate (distinct from delete/etc. see draft spec)
    
    index, key, no_key = parse_args_for_index_value_no_value( args, true )

    if index
      global_id = index.get_object_id( key )
    else
      global_id = key
    end

    indexes.each do |this_index_name, this_index|
      this_index.delete_keys_for_object_id!( global_id )
    end
    
    hash_in_port = instance_persistence_bucket.delete_object!( global_id )
    
    return hash_in_port
    
  end
  
  ###########
  #  index  #
  ###########

   def index( index_name, ensure_exists = false )
     
     index_instance = nil

     unless index_instance = indexes[ index_name ]
       if ensure_exists
         raise ::ArgumentError, 'No index found by name ' << index_name.to_s + '.'
       end
     end
         
     return indexes[ index_name ]

  end
  
  ################
  #  has_index?  #
  ################
  
  def has_index?( *index_names )
    
    has_index = false
    
    index_names.each do |this_index_name|
      break unless has_index = indexes.has_key?( this_index_name )
    end
    
    return has_index

  end
  
  #################
  #  block_index  #
  #################
  
  def block_index( *index_names, & indexing_block )

    index_names.each do |this_index_name|
      instance = create_block_index( this_index_name, false, & indexing_block )
    end

    return self
    
  end

  #########################
  #  block_index_ordered  #
  #########################
  
  def block_index_ordered( index_name, ordering_proc, & indexing_block )

    instance = create_block_index( index_name, true, ordering_proc, & indexing_block )

    return self

  end
  
  #################################
  #  block_index_with_duplicates  #
  #################################
  
  def block_index_with_duplicates( index_name, & indexing_block )

    instance = create_block_index( index_name, true, & indexing_block )

    indexes[ index_name ] = block_indexes[ index_name ] = instance

    return self

  end
  
  #########################################
  #  block_index_ordered_with_duplicates  #
  #########################################
  
  def block_index_ordered_with_duplicates( index_name, ordering_proc, duplicates_ordering_proc = nil, & indexing_block )
    
    raise 'Pending.'
    
    instance = create_block_index( index_name, true, ordering_proc, duplicates_ordering_proc, & indexing_block )

    indexes[ index_name ] = block_indexes[ index_name ] = instance

    return self

  end

  ######################
  #  has_block_index?  #
  ######################
  
  def has_block_index?( *index_names )
    
    has_index = false
    
    index_names.each do |this_index_name|
      break unless has_index = block_indexes.has_key?( this_index_name )
    end
    
    return has_index

  end
  
  ####################
  #  explicit_index  #
  ####################
  
  def explicit_index( *index_names )

    index_names.each do |this_index_name|
      instance = create_explicit_index( this_index_name, false )
      indexes[ this_index_name ] = explicit_indexes[ this_index_name ] = instance
    end
    
    return self

  end

  ############################
  #  explicit_index_ordered  #
  ############################
  
  def explicit_index_ordered( *index_names, & ordering_block )
    
    raise 'Pending.'
    
    index_names.each do |this_index_name|
      instance = create_explicit_index( this_index_name, false, ordering_block )
      indexes[ this_index_name ] = explicit_indexes[ this_index_name ] = instance
    end
    
    return self

  end

  ####################################
  #  explicit_index_with_duplicates  #
  ####################################
  
  def explicit_index_with_duplicates( *index_names )

    index_names.each do |this_index_name|
      instance = create_explicit_index( this_index_name, true )
      indexes[ this_index_name ] = explicit_indexes[ this_index_name ] = instance
    end

    return self
    
  end

  ############################################
  #  explicit_index_ordered_with_duplicates  #
  ############################################
  
  def explicit_index_ordered_with_duplicates( index_name, duplicates_ordering_proc = nil, & ordering_block )

    raise 'Pending.'

    instance = create_explicit_index( this_index_name, true, ordering_block, duplicates_ordering_proc )
    indexes[ index_name ] = explicit_indexes[ index_name ] = instance
    
    return self
    
  end

  #########################
  #  has_explicit_index?  #
  #########################
  
  def has_explicit_index?( *index_names )
    
    has_index = false
    
    index_names.each do |index_name|
      break unless has_index = explicit_indexes.has_key?( index_name )
    end
    
    return has_index
    
  end

  ##################
  #  delete_index  #
  ##################
  
  def delete_index( *attributes )
    
    attributes.each do |this_index|
      indexes.delete( this_index )
      persistence_port.delete_index( self, this_index )
    end
    
    return self
    
  end
  
  ############
  #  cursor  #
  ############

  ###
  # Create and return cursor instance for this bucket.
  #
  # @overload cursor( global_id )
  #
  #    @param global_id Object persistence ID for retrieval.
  #
  # @overload cursor( index_name, key )
  #
  #    @param index_name Name of index for lookup of object persistence ID.
  #
  #    @param key Key to look up in index.
  #
  # @overload cursor( index, key )
  #
  #    @param index Index instance for lookup of object persistence ID.
  #
  #    @param key Key to look up in index.
  #
  # @return [Persistence::Adapter::Mock::Cursor] New cursor instance.
  #
  def cursor( *args, & block )
    
    cursor_instance = nil
    
    index_instance, key, no_key = parse_args_for_index_value_no_value( args )
    
    if index_instance
      
      if no_key
        cursor_instance = index_instance.cursor( & block )
      else
        cursor_instance = index_instance.cursor( key, & block )        
      end
      
    else

      if no_key
        instance_persistence_bucket.cursor( & block )
      else
        instance_persistence_bucket.cursor( key, & block )
      end
      
    end
    
    return cursor_instance
    
  end

  ##########
  #  all?  #
  ##########
  
  ###
  # See Enumerable.
  #
  def all?( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).all?( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ##########
  #  any?  #
  ##########

  ###
  # See Enumerable.
  #
  def any?( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).any?( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ###########
  #  chunk  #
  ###########

  ###
  # See Enumerable.
  #
  def chunk( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).chunk( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  #############
  #  collect  #
  #############

  ###
  # See Enumerable.
  #
  def collect( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).collect( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ####################
  #  flat_map        #
  #  collect_concat  #
  ####################

  ###
  # See Enumerable.
  #
  def flat_map( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).flat_map( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end
  alias_method :collect_concat, :flat_map

  ###########
  #  cycle  #
  ###########

  ###
  # See Enumerable.
  #
  def cycle( index_name = nil, item = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).cycle( item, & block )
    else
      return_value = super( item, & block )
    end
    
    return return_value
    
  end
  
  ############
  #  detect  #
  ############

  ###
  # See Enumerable.
  #
  def detect( index_name = nil, if_none = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).detect( if_none, & block )
    else
      return_value = super( if_none, & block )    
    end
    
    return return_value
    
  end
  
  ##########
  #  drop  #
  ##########

  ###
  # See Enumerable.
  #
  def drop( index_name = nil, number = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).drop( number, & block )
    else
      return_value = super( number, & block )   
    end
    
    return return_value
    
  end
  
  ################
  #  drop_while  #
  ################

  ###
  # See Enumerable.
  #
  def drop_while( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).drop_while( & block )
    else
      return_value = super( & block )  
    end
    
    return return_value
    
  end

  ##########
  #  each  #
  ##########

  ###
  # See Enumerable.
  #
  def each( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each( & block )
    else
      return_value = instance_persistence_bucket.each( & block )
    end
    
    return return_value
    
  end
    
  ###############
  #  each_cons  #
  ###############

  ###
  # See Enumerable.
  #
  def each_cons( index_name = nil, number = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each_cons( number, & block )
    else
      return_value = super( number, & block )
    end
    
    return return_value
    
  end
  
  ################
  #  each_slice  #
  ################

  ###
  # See Enumerable.
  #
  def each_slice( index_name = nil, slice_size = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each_cons( slice_size, & block )
    else
      return_value = super( slice_size, & block )     
    end
    
    return return_value
    
  end
  
  #####################
  #  each_with_index  #
  #####################

  ###
  # See Enumerable.
  #
  def each_with_index( index_name = nil, *args, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each_with_index( *args, & block )
    else
      return_value = super( *args, & block )
    end
    
    return return_value
    
  end

  ######################
  #  each_with_object  #
  ######################

  ###
  # See Enumerable.
  #
  def each_with_object( index_name = nil, object = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each_with_object( object, & block )
    else
      return_value = super( object, & block )
    end
    
    return return_value
    
  end

  #############
  #  entries  #
  #############

  ###
  # See Enumerable.
  #
  def entries( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).entries( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ##########
  #  find  #
  ##########

  ###
  # See Enumerable.
  #
  def find( index_name = nil, if_none = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).find( if_none, & block )
    else
      return_value = super( if_none, & block )    
    end
    
    return return_value
    
  end

  ##############
  #  find_all  #
  ##############
  
  ###
  # See Enumerable.
  #
  def find_all( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).find_all( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end
  
  ############
  #  select  #
  ############

  ###
  # See Enumerable.
  #
  def select( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).select( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ################
  #  find_index  #
  ################

  ###
  # See Enumerable.
  #
  def find_index( index_name = nil, value = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).find_index( value, & block )
    else
      return_value = super( value, & block )
    end
    
    return return_value
    
  end

  ###########
  #  first  #
  ###########

  ###
  # See Enumerable.
  #
  def first( index_name = nil, number = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).first( number, & block )
    else
      return_value = super( number, & block )
    end
    
    return return_value
    
  end

  ##########
  #  grep  #
  ##########

  ###
  # See Enumerable.
  #
  def grep( index_name = nil, pattern = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).grep( pattern, & block )
    else
      return_value = super( pattern, & block )
    end
    
    return return_value
    
  end

  ##############
  #  group_by  #
  ##############

  ###
  # See Enumerable.
  #
  def group_by( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).group_by( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ##############
  #  include?  #
  #  member?   #
  ##############

  ###
  # See Enumerable.
  #
  def include?( index_name = nil, object = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).include?( object, & block )
    else
      return_value = super( object, & block )
    end
    
    return return_value
    
  end
  alias_method :member?, :include?

  ############
  #  inject  #
  #  reduce  #
  ############

  ###
  # See Enumerable.
  #
  def inject( index_name = nil, initial = nil, sym = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).inject( initial, sym, & block )
    else
      return_value = super( initial, sym, & block )
    end
    
    return return_value
    
  end
  alias_method :reduce, :inject

  #########
  #  map  #
  #########

  ###
  # See Enumerable.
  #
  def map( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).map( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  #########
  #  max  #
  #########

  ###
  # See Enumerable.
  #
  def max( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).max( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ############
  #  max_by  #
  ############

  ###
  # See Enumerable.
  #
  def max_by( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).max_by( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ############
  #  min_by  #
  ############

  ###
  # See Enumerable.
  #
  def min_by( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).min_by( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ############
  #  minmax  #
  ############

  ###
  # See Enumerable.
  #
  def minmax( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).minmax( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ###############
  #  minmax_by  #
  ###############

  ###
  # See Enumerable.
  #
  def minmax_by( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).minmax_by( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ###########
  #  none?  #
  ###########

  ###
  # See Enumerable.
  #
  def none?( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).none?( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ##########
  #  one?  # 
  ##########

  ###
  # See Enumerable.
  #
  def one?( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).one?( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ###############
  #  partition  #
  ###############

  ###
  # See Enumerable.
  #
  def partition( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).partition( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ############
  #  reject  #
  ############

  ###
  # See Enumerable.
  #
  def reject( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).reject( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ##################
  #  reverse_each  #
  ##################

  ###
  # See Enumerable.
  #
  def reverse_each( index_name = nil, *args, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).reverse_each( *args, & block )
    else
      return_value = super( *args, & block )
    end
    
    return return_value
    
  end

  ##################
  #  slice_before  #
  ##################

  ###
  # See Enumerable.
  #
  def slice_before( index_name = nil, pattern = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).slice_before( pattern, & block )
    else
      return_value = super( pattern, & block )
    end
    
    return return_value
    
  end

  ##########
  #  sort  #
  ##########

  ###
  # See Enumerable.
  #
  def sort( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).sort( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  #############
  #  sort_by  #
  #############

  ###
  # See Enumerable.
  #
  def sort_by( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).sort_by( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ################
  #  take_while  #
  ################

  ###
  # See Enumerable.
  #
  def take_while( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).take_while( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ##########
  #  to_a  #
  ##########

  ###
  # See Enumerable.
  #
  def to_a( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).to_a( & block )
    else
      return_value = super( & block )    
    end
    
    return return_value
    
  end

  ##########
  #  take  #
  ##########

  ###
  # See Enumerable.
  #
  def take( index_name = nil, number = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).take( number, & block )
    else
      return_value = super( number, & block )
    end
    
    return return_value
    
  end

  #########
  #  zip  #
  #########

  ###
  # See Enumerable.
  #
  def zip( index_name = nil, *args, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).zip( *args, & block )
    else
      return_value = super( *args, & block )
    end
    
    return return_value
    
  end

  ###########
  #  count  #
  ###########

  ###
  # See Enumerable.
  #
  def count( index_name = nil, *args, & block )
    
    return_value = 0
    
    if index_name
      return_value = index( index_name, true ).count( *args, & block )
    else
      if block_given?
        return_value = super( & block )
      elsif args.empty?
        return_value = instance_persistence_bucket.count
      else
        return_value = super( *args )
      end
    end
    
    return return_value
    
  end

  ###################
  #  persist_first  #
  ###################

  ###
  # Persist first object in cursor context.
  #
  # @param [Integer] count How many objects to persist from start of cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def persist_first( *index_name_and_or_count )
    
    objects = nil
    index_name = nil
    count = 1
    
    case index_name_or_count = index_name_and_or_count[ 0 ]
      when Symbol, String
        index_name = index_name_or_count
        count_or_nil = index_name_and_or_count[ 1 ]
        case count_or_nil
          when Integer
            count = count_or_nil
        end
      when Integer
        count = index_name_or_count
    end

    if index_name
      objects = index( index_name ).cursor.first( count )
    else
      objects = instance_persistence_bucket.cursor.first( count )
    end
    
    return objects
    
  end

  ##################
  #  persist_last  #
  ##################
  
  ###
  # Persist last object in cursor context.
  #
  # @param [Integer] count How many objects to persist from end of cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def persist_last( *index_name_and_or_count )
    
    objects = nil
    index_name = nil
    count = 1
    
    case index_name_and_or_count[ 0 ]
      when Symbol, String
        index_name = index_name_or_count
        count_or_nil = index_name_and_or_count[ 1 ]
        case count_or_nil
          when Integer
            count = count_or_nil
        end
      when Integer
        count = index_name_or_count
    end
    
    if index_name
      objects = index( index_name ).cursor.last( count )
    else
      objects = instance_persistence_bucket.cursor.last( count )
    end
    
    return objects
    
  end

  #################
  #  persist_any  #
  #################
  
  ###
  # Persist any object in cursor context.
  #
  # @param [Integer] count How many objects to persist from cursor context.
  #
  # @return [Object,Array<Object>] Object or objects requested.
  #
  def persist_any( *index_name_and_or_count )

    objects = nil
    index_name = nil
    count = 1
    
    case index_name_and_or_count[ 0 ]
      when Symbol, String
        index_name = index_name_or_count
        count_or_nil = index_name_and_or_count[ 1 ]
        case count_or_nil
          when Integer
            count = count_or_nil
        end
      when Integer
        count = index_name_or_count
    end
    
    if index_name
      objects = index( index_name ).cursor.any( count )
    else
      objects = instance_persistence_bucket.cursor.any( count )    
    end
    
    return objects
    
  end
  
  ##########################
  #  has_attribute_index?  #
  ##########################
  
  def has_attribute_index?( *attributes )
  
    has_index = false
  
    attributes.each do |this_attribute|
      break unless has_index = attribute_indexes.has_key?( this_attribute.accessor_name )
    end
  
    return has_index
  
  end

  ########################
  #  persists_flat_hash  #
  ########################

  attr_hash :persists_flat_hash

  ###############
  #  attr_flat  #
  ###############

  def attr_flat( *attributes )

    return persists_flat( *attributes )
    
  end

  ################
  #  attr_flat!  #
  ################

  def attr_flat!
    
    attr_flat( *persistent_attributes.keys )

    return self
    
  end

  ####################
  #  persists_flat?  #
  ####################

  def persists_flat?( *attributes )

    should_persist_flat = false

    if attributes.empty?
      should_persist_flat = persists_flat[ nil ]
    else
      attributes.each do |this_attribute|
        break unless should_persist_flat = persists_flat_hash[ this_attribute ]
      end
    end
    
    return should_persist_flat
    
  end

  ###################
  #  persists_flat  #
  ###################

  def persists_flat( *attributes )

    if attributes.empty?
      persists_flat_hash[ nil ] = true
    else
      attributes.each do |this_attribute|
        persists_flat_hash[ this_attribute ] = true
      end
    end
    
    return self
    
  end
  
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ###########################
  #  create_explicit_index  #
  ###########################

  def create_explicit_index( index_name, permits_duplicates, sort_by_proc = nil, sort_duplicates_by_proc = nil )
    
    ensure_index_does_not_exist( index_name, permits_duplicates )
    
    index_instance = ::Persistence::Object::Index::ExplicitIndex.new( index_name, 
                                                                      instance_persistence_bucket, 
                                                                      permits_duplicates,
                                                                      sort_duplicates_by_proc,
                                                                      & sort_by_proc )

    indexes[ index_name ] = explicit_indexes[ index_name ] = index_instance

    return index_instance
    
  end
  
  ########################
  #  create_block_index  #
  ########################

  def create_block_index( index_name, 
                          permits_duplicates, 
                          sort_by_proc = nil, 
                          sort_duplicates_by_proc = nil, 
                          & indexing_block )
    
    ensure_index_does_not_exist( index_name, permits_duplicates )
    
    index_instance = ::Persistence::Object::Index::BlockIndex.new( index_name, 
                                                                   instance_persistence_bucket, 
                                                                   permits_duplicates,
                                                                   sort_by_proc, 
                                                                   sort_duplicates_by_proc,
                                                                   & indexing_block )

    indexes[ index_name ] = block_indexes[ index_name ] = index_instance

    return index_instance

  end

  #################################
  #  ensure_index_does_not_exist  #
  #################################

  def ensure_index_does_not_exist( index_name, permits_duplicates )

    if index_instance = indexes[ index_name ] and 
       index_instance.permits_duplicates? != permits_duplicates

      raise 'Index ' << index_name.to_s + ' has already been declared, ' <<
            'and new duplicates declaration does not match existing declaration.'

    end

  end
    
end