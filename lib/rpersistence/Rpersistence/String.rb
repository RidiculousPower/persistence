module Rpersistence::String

  ##############
  #  persist!  #
  ##############

	# :bucket, key
	# :port, :bucket, key
	def persist!( *args )
		port, bucket, key = nil
		case args.length
		when 3
			port, bucket, key = *args
		when 2
			bucket, key = *args
		end
		port = Rpersistence.current_port unless port
		port.adapter.put_flat_object_to_persistence_port!( port, bucket, key, self )
		return self
	end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  private

  ##############################
  #  storage_key_for_property  #
  ##############################

  def storage_key
		return {  :global_persistence_id    =>  persistence_id, 
		          :persistence_key          =>  property_name }
  end  

  # something to keep track of what's being used for the key?
  # to define the initial environment definition - the definition is mutable, but once defined should be immutable (unless easily changed, or explicitly upgraded)

end

class String
	include Rpersistence::String
end