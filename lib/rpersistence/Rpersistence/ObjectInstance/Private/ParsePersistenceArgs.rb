
module Rpersistence::ObjectInstance::ParsePersistenceArgs

  ############################################
  #  parse_persist_args_with_bucket_accessor  #
  ############################################
  
  #  common args parsing routine used in all objects
  def parse_persist_args_with_bucket_accessor( args, bucket_accessor )
    
    #  args is not a splat because we are always passing in from a splat - no reason to do extra work
    
    # * persistence_key
    # * :bucket, persistence_key
    # * :port, :bucket, persistence_key
    
    port, bucket, key    = nil
    key_specified       = false
    case args.length
    when 1
      key                 = args[ 0 ]
      key_specified     = true
    when 2
      bucket            = args[ 0 ]
      key                = args[ 1 ]
      key_specified     = true
    when 3
      port              = args[ 0 ]
      bucket            = args[ 1 ]
      key                = args[ 2 ]
      key_specified     = true
    end
    
    if port      
      port  = Rpersistence.port_for_name_or_port( port )
    else
      port  = Rpersistence.current_port
    end
    
    self.persistence_port  = port
    
    if bucket
      # if we have a bucket, set it
      __send__( write_accessor_name_for_accessor( bucket_accessor ), bucket )
    else
      # otherwise get our bucket
      bucket  =  __send__( bucket_accessor )
    end
        
    # we save the key only if it was specified (otherwise can arbitrarily change based on method)
    if key_specified
      self.persistence_key   = key
    else
      key                    =  persistence_key
    end
    
    # if we are over-writing an existing storage key we need to take over its ID or we end up with unwanted duplicates
    existing_object_id  = nil
    if has_persistence_key?
      # do we have a file key? if so we need to replace it with File::Path or File::Contents
      if key.is_a?( File )
        if port.persists_file_by_path?
          key = File::Path.new( key.path )
        else
          starting_pos = key.pos
          file_key = key
          key = File::Contents.new( key.readlines.join )
          file_key.pos = starting_pos
        end
      end
      # if we have a persistence key we are looking for bucket, key to see if we have an existing ID
      if existing_object_id =  port.adapter.get_object_id_for_bucket_and_key( bucket, key )
        reset_persistence_id_to( existing_object_id )
      elsif ! existing_object_id and persistence_id
        reset_persistence_id_to( nil )
      end
    end
    
    unless port
      raise "No persistence port specified." 
    end
    
    unless bucket
      raise "No persistence bucket specified."
    end
    
    return port, bucket, key
    
  end
  
end
