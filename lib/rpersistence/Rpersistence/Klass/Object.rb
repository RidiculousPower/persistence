
#---------------------------------------------------------------------------------------------------------#
#---------------------------------------------  Classes  -------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::Klass::Object

	include Rpersistence::KlassAndInstance::ParsePersistenceArguments

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

  ###################
  #  Klass.persist  #
  ###################
  
	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
  def persist( *args )

		port, bucket, key               = parse_persist_args( args )

		global_persistence_id           = persistence_port.adapter.get_object_id_for_bucket_and_key( persistence_bucket, key )
		
		object                          = nil
		
		if ( global_persistence_id )
      
      object_hash                   = persistence_hash_from_port( global_persistence_id )

      object                        = object_from_persistence_hash( object_hash )

      object.persistence_id         = global_persistence_id
      
      # we know this object needs to be evaluated as a persistence object
      object.extend( Rpersistence::Instance::Variables )
      
    end
    
    return object

  end

  ######################
  #  Klass.persisted?  #
  ######################

	def persisted?( key )

    is_persisted  = ( Rpersistence.current_port( self ).adapter.persistence_key_exists_for_bucket?( persistence_bucket, key ) ? true : false )      
	  
    return is_persisted
    
	end


  ##############################################  Cease  ####################################################

  ##################
  #  Klass.cease!  #
  ##################

	def cease!( *args )

		port, bucket, key = parse_persist_args( args )

    global_id = port.adapter.get_object_id_for_bucket_and_key( bucket, key )

    port.adapter.delete_object!( global_id )

    remove_instance_variable( :@__rpersistence__id__ )

	end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  private

  ##################################
  #  object_from_persistence_hash  #
  ##################################
  
  def object_from_persistence_hash( persistence_ivar_hash )

    object = new

    persistence_ivar_hash.each do |this_persistence_key, this_persistence_value|
      object.instance_variable_set( this_persistence_key, this_persistence_value )
    end

		return object

  end

end

#---------------------------------------------------------------------------------------------------------#
#--------------------------------------------  Includes  -------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Object

  extend Rpersistence::Klass::Object

end
