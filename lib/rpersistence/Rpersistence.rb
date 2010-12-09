
class Rpersistence
	
	VersionDelimiter		=	'.'
	BucketKeyDelimiter	=	'##__rp__##'

	attr_reader	:default_port

  ################
  #  initialize  #
  ################

  def initialize
    
  end

  ##########
  #  port  #
  ##########
  
  def port( port_name )
    return @ports[ port_name ]
  end

  #################
  #  enable_port  #
  #################

	# Rpersistence.enable_port( :port_name, AdapterClass, directory )
	# Rpersistence.enable_port( :port_name, AdapterClass, directory, ObjectClass or [ ObjectClassAndDescending ] )
	def enable_port( port_name, adapter_class, directory, *persists_classes )
		@ports[ port_name ]	=	Rpersistence::Port.new(	port_name, 
																									adapter_class, 
																									directory, 
																									*persists_classes ).enable
	end

  ##################
  #  disable_port  #
  ##################

	# Rpersistence.disable_port( :port_name )
	def disable_port( port_name )
		@ports[ port_name ].disable
	end

  ######################
  #  set_default_port  #
  ######################
  
  def set_default_port( persistence_name )
		@default_port	=	persistence_name
  end

	########################################
	#  global_persistence_data_for_object  #
	########################################
	
	def global_persistence_data_for_object( object )
		object.persistence_id + BucketKeyDelimiter + object.persistence_bucket
	end

  #############################
  #  storage_id_for_property  #
  #############################
  
  def storage_id_for_property( object, property_name )
		Kernel.sprintf( Rpersistence::Revisions::Format, object.persistence_id, Rpersistence::VersionDelimiter, property_name )
  end
  
  ############################
  #  persistence_ivars_hash  #
  ############################

	def persistence_ivars_hash( object )
		object.instance_eval do
			instance_variables.inject( {} ) do |hash, property_name|
				persistence_hash[ storage_id_for_property( object, property_name ) ] = object.instance_variable_get( property_name )
				hash
			end
		end
	end

end