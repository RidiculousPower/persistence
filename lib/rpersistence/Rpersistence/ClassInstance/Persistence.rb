
#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Class Objects  ----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Persistence

  ##################
  #  Klass.index!  #
  ##################

  # creates independent index on each object ID
  def index!

    persistence_port.adapter.index_object!( self )

  end

  ######################
  #  Klass.attr_index  #
  ######################

  # creates index for attribute
  def attr_index( *attributes )

    persistence_port.adapter.index_attribute_for_bucket!( self, *attributes )

  end

  #############################################  Persist  ###################################################

  ###################
  #  Klass.persist  #
  ###################
  
	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
  def persist( *args )

    @__rpersistence__persisting_from_port__ = true
    
		port, bucket, key               = parse_persist_args( args )

		global_persistence_id           = port.adapter.get_object_id_for_bucket_and_key( bucket, key )
		
		object                          = nil
		
		if ( global_persistence_id )

      object                        = object_for_persistence_id( port, global_persistence_id )
      
    end
    
    remove_instance_variable( :@__rpersistence__persisting_from_port__ )
    
    return object

  end

  ######################
  #  Klass.persisted?  #
  ######################

	def persisted?( *args )

    @__rpersistence__persisting_from_port__ = true

		port, bucket, key   = parse_persist_args( args )

    is_persisted  = ( persistence_port.adapter.persistence_key_exists_for_bucket?( persistence_bucket, key ) ? true : false )      
	  
	  remove_instance_variable( :@__rpersistence__persisting_from_port__ )
    
    return is_persisted
    
	end

  ##############################################  Cease  ####################################################

  ##################
  #  Klass.cease!  #
  ##################

	# deletes from storage (archives if appropriate)
	def cease!( *args )

    @__rpersistence__persisting_from_port__ = true

		port, bucket, key = parse_persist_args( args )

    # if we have Class then we are 
    global_persistence_id = port.adapter.get_object_id_for_bucket_and_key( bucket, key )
  
		port.adapter.delete_object!( global_persistence_id, bucket )
    
	  remove_instance_variable( :@__rpersistence__persisting_from_port__ )

    return self
    
	end

end
