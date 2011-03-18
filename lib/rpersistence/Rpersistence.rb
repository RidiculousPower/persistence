
class Rpersistence
	
	VersionDelimiter		=	'.'
	BucketKeyDelimiter	=	'#'

	class << self
		attr_reader	:current_port
	end

  @ports = { }

  ################
  #  initialize  #
  ################

  def initialize
	end

  ###############
  #  self.port  #
  ###############
  
  def self.port( port_name )
    return @ports[ port_name.to_sym ]
  end

  ######################
  #  self.enable_port  #
  ######################

	# Rpersistence.enable_port( :port_name, AdapterClass, directory )
	# Rpersistence.enable_port( :port_name, AdapterClass, directory, ObjectClass or [ ObjectClass ], which implies also descending classes )
	def self.enable_port( port_name, adapter_instance, *persists_classes )
		port	=	Rpersistence::Port.new(	port_name, 
																		adapter_instance, 
																		*persists_classes ).enable
		@ports[ port_name.to_sym ] = port
		set_current_port( port ) unless current_port
		return port
	end

  #######################
  #  self.disable_port  #
  #######################

	# Rpersistence.disable_port( :port_name )
	def self.disable_port( port_name )
		if current_port.name == port_name
			set_current_port( nil )
		end
		@ports[ port_name.to_sym ].disable
		return self
	end

  ##################
  #  current_port  #
  ##################
  
  def self.current_port
		return @current_port
  end

  ######################
  #  set_current_port  #
  ######################
  
  def self.set_current_port( persistence_port_or_name )
		if persistence_port_or_name
			@current_port	=	port_for_name_or_port( persistence_port_or_name )
		else
			@current_port = nil
		end
		return self
  end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

	private
	
	def self.port_for_name_or_port( persistence_port_or_name )
		persistence_port = nil
		if persistence_port_or_name.is_a?( String ) or persistence_port_or_name.is_a?( Symbol )
			persistence_port = port( persistence_port_or_name )
			persistence_port.name = persistence_port_or_name
		else
			persistence_port = persistence_port_or_name
		end
		return persistence_port
	end

end