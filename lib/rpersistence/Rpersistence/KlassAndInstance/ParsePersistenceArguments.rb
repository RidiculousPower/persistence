
module Rpersistence::KlassAndInstance::ParsePersistenceArguments

  ########################
  #  parse_persist_args  #
  ########################
  
	#	common args parsing routine used in all objects
	def parse_persist_args( args )
		
		#	args is not a splat because we are always passing in from a splat - no reason to do extra work
		
		# * persistence_key
		# * :bucket, persistence_key
		# * :port, :bucket, persistence_key
		
		port, bucket, key		= nil
		key_specified       = false
		case args.length
		when 1
			key							 	= args[ 0 ]
			key_specified 		= true
		when 2
			bucket            = args[ 0 ]
			key								= args[ 1 ]
			key_specified 		= true
		when 3
			port              = args[ 0 ]
			bucket            = args[ 1 ]
			key								= args[ 2 ]
			key_specified 		= true
		end
		
		if port			
			port 	= Rpersistence.port_for_name_or_port( port )
		else
			port	= Rpersistence.current_port
		end
		
		self.persistence_port  = port
		
		# we save the bucket only if it was specified (object's class won't change)
		if bucket
		  self.persistence_bucket             = bucket
		else
			bucket										          =	self.persistence_bucket
		end
		
		# we save the key only if it was specified (otherwise can arbitrarily change based on method)
		if key_specified
			@__rpersistence__arbitrary_key__  	= key
		else
			key									          			=	persistence_key
		end
		
		# if we are over-writing an existing storage key we need to take over its ID or we end up with unwanted duplicates
		existing_object_id  = nil
		if existing_object_id	=	port.adapter.get_object_id_for_bucket_and_key( bucket, key )
			reset_persistence_id_to( existing_object_id )
		elsif ! existing_object_id and persistence_id
			reset_persistence_id_to( nil )
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
