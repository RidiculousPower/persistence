
module ::Persistence::Cursor::Indexing::ClassInstance

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
        super( & block )
      else
        super( key, & block )
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
  #  count  #
  ###########

  ###
  # See Enumerable.
  #
  def count( index_name = nil, *args, & block )
    
    return_value = 0
    
    if index_name
      return_value = index( index_name ).count( & block )
    else
      return_value = super( *args, & block )
    end
    
    return return_value
    
  end
  
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
      return_value = super( & block )
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
      return_value = index( index_name ).count( *args, & block )
    else
      return_value = super( *args, & block )
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
      objects = super( count )   
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
      objects = super( count )
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
      objects = super( count )    
    end
    
    return objects
    
  end

end
