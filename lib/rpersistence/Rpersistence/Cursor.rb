
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rpersistence Cursor  --------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence::Cursor
	
	include Enumerable
	include Rpersistence::Cursor::ParseInitializationArgs

	################
	#  initialize  #
	################
	
	def initialize( *args )

		@persistence_port, 
		@persistence_bucket, 
		@index, 
		@index_value = parse_cursor_initialization_args( args )
		
		# use persistence port, bucket, index, value to instantiate adapter cursor
		@cursor_in_adapter = @persistence_port.adapter.class::CursorClass.new( *args )
		
	end

	##############
	#  has_key?  #
	##############

	def has_key?( key )
		return @has_position = @cursor_in_adapter.has_key?( key )
	end

	#############
	#  persist  #
	#############

	def persist( key )

	  object = nil

	  if @has_position = @cursor_in_adapter.has_key?( key )
      object = object_for_id_or_persistence_hash( @cursor_in_adapter.current )
	  end

		return object

	end

	##########
	#  each  #
	##########
	
	def each

		# we have to set position if it's not already set before we can iterate
		first unless @has_position

		return self.to_enum( :each ) unless block_given?

		# support for Enumerator#feed - permit a return value
		feed_value = nil

		begin
			feed_value = yield( current ) while self.next
		rescue StopIteration
		  # may not be raised but we don't need to do anything if it is - means we're done
		end

		return feed_value
		
	end

	###########
	#  first  #
	###########
	
	def first( count = 1 )
		objects = nil
		if @has_position = @cursor_in_adapter.has_key?
		  if count == 1
		    objects = @cursor_in_adapter.first
	    else
	      objects = Array.new
  			count.times do
  				objects.push( object_for_id_or_persistence_hash( @cursor_in_adapter.next ) )
  			end
  			# reset to first
  		  @cursor_in_adapter.first
		  end
		end
		return objects
	end

	#############
	#  current  #
	#############
	
	def current
		first unless @has_position
		return object_for_id_or_persistence_hash( @cursor_in_adapter.current )
	end

	##########
	#  next  #
	##########
	
	def next( count = 1 )
		objects = Array.new
		count.times do
			objects.push( object_for_id_or_persistence_hash( @cursor_in_adapter.next ) )
		end
		return ( count > 1 ? objects : objects[ 0 ] )
	end

end
