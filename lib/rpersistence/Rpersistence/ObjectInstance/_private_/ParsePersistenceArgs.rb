
module Rpersistence::ObjectInstance::ParsePersistenceArgs

  ##################################
  #  parse_persist_args_from_port  #
  ##################################
  
  def parse_persist_args_from_port( args, require_value = false )
    
    # * nil
    #   - Cursor to primary bucket
    # * :index
    #   - Cursor to index
    # * :index => persistence_key
    #   - Object(s) for indexed key value
    
    index = nil
    value = nil
    no_value = nil
    case args.count
      when 0
        no_value = true
        raise 'Value required.' if require_value
      when 1
        index = args[0]
        if index.is_a?( Hash )
          value = index.values[0]
          index = index.keys[0]
        end
        no_value = false
      when 2
        index = args[0]
        value = args[1]
        no_value = false
      else
        raise 'Unexpected arguments ' + args.inspect + '.'
    end
    
    return index, value, no_value
    
  end







  
  ######################
  #  process_file_key  #
  ######################
  
  # do we have a file key? if so we need to replace it with File::Path or File::Contents
  def process_file_key( port, key )

    processed_key = nil
    
    if port.persists_file_by_path?
      processed_key = File::Path.new( key.path )
    else
      starting_pos  = key.pos
      processed_key = File::Contents.new( key.readlines.join )
      key.pos       = starting_pos
    end
    
    return processed_key
    
  end
  
  ###########################
  #  check_for_existing_id  #
  ###########################
  
  # if we have a persistence key we are looking for bucket, key to see if we have an existing ID
  def check_for_existing_id( port, bucket, key )

    if existing_object_id = port.adapter.get_object_id_for_bucket_index_and_key( bucket, nil, key )

      reset_persistence_id_to( existing_object_id )

    elsif ! existing_object_id and persistence_id

      reset_persistence_id_to( nil )

    end
    
    return self
    
  end
  
end
