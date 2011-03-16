
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

  #############################
  #  self.parse_persist_args  #
  #############################
  
	def self.parse_persist_args( args )

		# * property_name
		# * :bucket, property_name
		# * :port, :bucket, property_name
		
		port, bucket, property_name = nil
		case args.length
			when 3
				port, bucket, property_name = *args
			when 2
				bucket, property_name = *args
			when 1
				key = *args
			default
				raise ArgError "Expected property_name; :bucket, property_name; or :port, :bucket, property_name"
		end

		# if a port was specified explicitly in passed args, use it- otherwise use default port
		if port
			port = port_for_name_or_port( persistence_port_or_name )
		else
			port = Rpersistence.current_port
		end

		return port, bucket, property_name
		
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