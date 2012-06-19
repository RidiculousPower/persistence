
module ::Persistence::Cursor::Indexing::ClassInstance

  ############
  #  cursor  #
  ############

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

  def cycle( index_name = nil, item = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).cycle( item, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end
  
  ############
  #  detect  #
  ############

  def detect( index_name = nil, if_none = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).detect( if_none, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end
  
  ##########
  #  drop  #
  ##########

  def drop( index_name = nil, number = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).drop( number, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end
  
  ################
  #  drop_while  #
  ################

  def drop_while( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).drop_while( & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ##########
  #  each  #
  ##########

  def each( index_name = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each( & block )
    else
      return_value = super()
    end
    
    return return_value
    
  end
    
  ###############
  #  each_cons  #
  ###############

  def each_cons( index_name = nil, number = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each_cons( number, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end
  
  ################
  #  each_slice  #
  ################

  def each_cons( index_name = nil, slice_size = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each_cons( slice_size, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end
  
  #####################
  #  each_with_index  #
  #####################

  def each_with_index( index_name = nil, *args, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each_with_index( *args, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ######################
  #  each_with_object  #
  ######################

  def each_with_object( index_name = nil, object = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).each_with_object( object, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  #############
  #  entries  #
  #############

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

  def find( index_name = nil, if_none = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).find( if_none, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ##############
  #  find_all  #
  ##############
  
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

  def find_index( index_name = nil, value = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).find_index( value, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ###########
  #  first  #
  ###########

  def first( index_name = nil, number = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).first( number, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ##########
  #  grep  #
  ##########

  def grep( index_name = nil, pattern = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).grep( pattern, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ##############
  #  group_by  #
  ##############

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

  def include?( index_name = nil, object = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).include?( object, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end
  alias_method :member?, :include?

  ############
  #  inject  #
  #  reduce  #
  ############

  def inject( index_name = nil, initial = nil, sym = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).inject( initial, sym, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end
  alias_method :reduce, :inject

  #########
  #  map  #
  #########

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

  def reverse_each( index_name = nil, *args, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).reverse_each( *args, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ##################
  #  slice_before  #
  ##################

  def slice_before( index_name = nil, pattern = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).slice_before( pattern, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ##########
  #  sort  #
  ##########

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

  def take( index_name = nil, number = nil, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).take( number, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  #########
  #  zip  #
  #########

  def zip( index_name = nil, *args, & block )
    
    return_value = nil
    
    if index_name
      return_value = index( index_name ).zip( *args, & block )
    else
      return_value = super      
    end
    
    return return_value
    
  end

  ###########
  #  count  #
  ###########

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
