
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
		
		port, bucket, key							 									= nil
		port_specified, bucket_specified, key_specified = nil
		case args.length
		when 1
			key							 	= args[ 0 ]
			key_specified 		= true
		when 2
			bucket, 
			key								= args
			bucket_specified	= true
			key_specified 		= true
		else
			port, 
			bucket, 
			key								= args
			port_specified		= true
			bucket_specified	= true
			key_specified 		= true
		end
		
		if ! port_specified			
			port = Rpersistence.current_port
		else
			port 							= port_for_name_or_port( persistence_port_or_name )
		end
		
		#	we always save the port in case the current port changes
		@__rpersistence_port__		 	= port
		
		# we save the bucket only if it was specified (object's class won't change)
		if bucket_specified
			@__rpersistence_bucket__ 	= bucket
		else
			bucket										=	persistence_bucket
		end
		
		# we save the key only if it was specified (otherwise can arbitrarily change based on method)
		if key_specified
			@__rpersistence_key__  	 	= key
		else
			key												=	persistence_key
		end
			
		# if we are over-writing an existing storage key we need to take over its ID or we end up with unwanted duplicates
		if existing_object_id	=	port.adapter.get_object_id( bucket, persistence_key )
			reset_persistence_id_to( existing_object_id )
		end
		
		return port, bucket, key
		
	end
	
end
