
#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Flat Instances  ---------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Persistence::Flat
		
  #############################
  #  Klass.persistence_port=  #
  #  persistence_port=        #
  #############################
  
  def persistence_port=( port )

    @__rpersistence__port__ = port

    return self

  end

  ###############################
  #  Klass.persistence_bucket=  #
  #  persistence_bucket=        #
  ###############################

	# declare name of persistence bucket where object will be stored
  def persistence_bucket=( persistence_bucket_class_or_name )

    @__rpersistence__bucket__ = persistence_bucket_class_or_name.to_s

  end
  alias_method :store_as, :persistence_bucket=

  ####################
  #  Klass.persist!  #
  #  persist!        #
  ####################

	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
	def persist!( *args )

		port, bucket, key = parse_persist_args( args )

		port.adapter.put_object!( self )

		# return the object we're persisting
		return self
	
	end

end

