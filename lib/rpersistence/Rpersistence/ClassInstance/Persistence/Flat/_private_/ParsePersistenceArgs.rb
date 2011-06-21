
module Rpersistence::ClassInstance::Persistence::Flat::ParsePersistenceArgs

  #######################################
  #  parse_flat_persist_args_from_port  #
  #######################################
  
  def parse_flat_persist_args_from_port( args, require_value = false )
    
    # * nil
    #   - Cursor to primary bucket
    # * key
    #   - key in :arbitrary_key index
    
    key = nil
    no_key = false
    case args.count
      when 0
        no_key = true
        raise 'Value required.' if require_value
      when 1
        key = args[0]
      else
        raise 'Unexpected arguments ' + args.inspect + '.'
    end
    
    return key, no_key
    
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
