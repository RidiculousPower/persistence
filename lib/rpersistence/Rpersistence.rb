
class Rpersistence
	
	VersionDelimiter		=	'.'
	BucketKeyDelimiter	=	'##__rp__##'

	class << self
		attr_reader	:current_port
	end

  @ports = { }

  ################
  #  initialize  #
  ################

  def initialize
	end

  ##########
  #  port  #
  ##########
  
  def port( port_name )
    return @ports[ port_name.to_sym ]
  end

  ######################
  #  self.enable_port  #
  ######################

	# Rpersistence.enable_port( :port_name, AdapterClass, directory )
	# Rpersistence.enable_port( :port_name, AdapterClass, directory, ObjectClass or [ ObjectClassAndDescending ] )
	def self.enable_port( port_name, adapter_instance, *persists_classes )
		port	=	Rpersistence::Port.new(	port_name, 
																		adapter_instance, 
																		*persists_classes ).enable
		@ports[ port_name.to_sym ] = port
		set_current_port( port ) unless current_port
		return self
	end

  #######################
  #  self.disable_port  #
  #######################

	# Rpersistence.disable_port( :port_name )
	def self.disable_port( port_name )
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
	persistence_port = nil
		if persistence_port_or_name.is_a?( String ) or persistence_port_or_name.is_a?( Symbol )
			persistence_port = port( persistence_port_or_name )
		else
			persistence_port = persistence_port_or_name
		end
		@current_port	=	persistence_port
		return self
  end

end