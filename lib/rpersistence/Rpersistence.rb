
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
		return self
	end

  ##################
  #  disable_port  #
  ##################

	# Rpersistence.disable_port( :port_name )
	def disable_port( port_name )
		@ports[ port_name ].disable
		return self
	end

  ######################
  #  set_default_port  #
  ######################
  
  def set_default_port( persistence_name )
		@default_port	=	persistence_name
		return self
  end

	########################################
	#  global_persistence_data_for_object  #
	########################################
	
	def global_persistence_data_for_object( object )
		return Rpersistence::Adapter::ObjectTable.new( object.persistence_bucket, object.persistence_key )
	end

end