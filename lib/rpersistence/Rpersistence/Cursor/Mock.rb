
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------  Rpersistence Cursor Mock  ------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence::Cursor::Mock

	include Rpersistence::Cursor::ParseInitializationArgs

	################
	#  initialize  #
	################

	def initialize( *args )

		@persistence_port, 
		@persistence_bucket, 
		@index, 
		@index_value = parse_cursor_initialization_args( args )
		
		bucket_source = ( @index  ? @persistence_port.adapter.instance_variable_get( :@values )
		                          : @persistence_port.adapter.instance_variable_get( :@buckets ) )
		
		id_source = bucket_source[ @persistence_bucket ]
		
		@current_position = ( id_source || Array.new ).each
		
	end
  
	##############
	#  has_key?  #
	##############

  # has_key? is responsible for setting the cursor position
	def has_key?( *args )
	  if args.count > 0
	    # we aren't testing multiple keys here
	    key = args[ 0 ]
    else
      @current_position.rewind
      return true
    end
	  has_key = false
	  begin
	    begin
	      self.next
      end until current == key
	    has_key = true
    rescue StopIteration
    end
    return has_key
	end

	###########
	#  first  #
	###########
	
	# first should set the cursor position and return the first ID or object hash
	def first
	  first_value = nil
	  begin
	    first_value = @current_position.rewind.peek
    rescue StopIteration
    end
		return first_value
	end

	#############
	#  current  #
	#############
	
	# current should return the current ID or object hash
	def current
	  current_value = nil
	  begin
	    current_value = ( @current_item || @current_position.peek )
	  raise StopIteration
    end
		return current_value
	end

	##########
	#  next  #
	##########
	
	def next
	  begin
	    @current_item = ( @current_position ||= keys.each ).next
    raise StopIteration
    end
		return @current_item
	end
	
end
