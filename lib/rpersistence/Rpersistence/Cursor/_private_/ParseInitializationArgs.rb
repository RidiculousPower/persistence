
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rpersistence Cursor  --------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::Cursor::ParseInitializationArgs

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

	######################################
	#  parse_cursor_initialization_args  #
	######################################

	def parse_cursor_initialization_args( args )
		
		# port, bucket, index => value
		# port, bucket, index
		# bucket, index => value
		# bucket, index
		# bucket
		
		port, bucket, index, index_value, index_descriptor  = nil
    case args.length
	    when 1
	      bucket             = args[ 0 ]
	    when 2
	      bucket             = args[ 0 ]
	      index_descriptor   = args[ 1 ]
	    when 3
	      port               = args[ 0 ]
	      bucket             = args[ 1 ]
	      index_descriptor   = args[ 2 ]
	    when 4
	      port               = args[ 0 ]
	      bucket             = args[ 1 ]
	      index_index        = args[ 2 ]
	      index_value        = args[ 3 ]
			else
				raise 'Unexpected arguments.'
    end

    if port      
      port  = Rpersistence.port_for_name_or_port( port )
    else
      port  = Rpersistence.current_port
    end

		if index.is_a?( Hash )
			index       = index_descriptor.keys.first
			index_value = index_descriptor.data.first
		end
    
		return port, bucket, index, index_value

	end

end
