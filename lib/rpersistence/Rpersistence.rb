
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------------  Rpersistence Singleton  -------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence
  
	extend Rpersistence::Locations

  PendingIndex     = Struct.new( :klass, :attribute, :permits_duplicates )
  
  @ports           = Hash.new
  @port_for_class  = Hash.new
  @pending_indexes = Array.new

  class << self
    attr_reader  :current_port
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
    port  =  Rpersistence::Port.new(  port_name, 
                                      adapter_instance, 
                                      *persists_classes )
    port.enable
    @ports[ port_name.to_sym ] = port
    set_current_port( port ) unless current_port
    # add any pending indexes that apply to port
    create_pending_indexes( port )
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

  #######################
  #  self.current_port  #
  #######################
  
  def self.current_port( for_class = nil )
    current_port = nil
    if for_class and @port_for_class.has_key?( for_class )
      # determine which port has been set to persist this class
      current_port = @current_port[ for_class ]
      # FIX - change to actually support classes
    else
      current_port = @current_port
    end
    return current_port
  end

  ###########################
  #  self.set_current_port  #
  ###########################
  
  def self.set_current_port( persistence_port_or_name )
    if persistence_port_or_name
      @current_port  =  port_for_name_or_port( persistence_port_or_name )
    else
      @current_port = nil
    end
    return self
  end
	
	#####################################
  #  self.enable_global_persistence!  #
  #####################################
  
	def self.enable_global_persistence!
	
		###########################################################################################################
		#############################################  Object  ####################################################
		###########################################################################################################

		Object.instance_eval do

		  include Rpersistence::ObjectInstance::Attributes
		  include Rpersistence::ObjectInstance::Configuration
		  include Rpersistence::ObjectInstance::Inspect
		  include Rpersistence::ObjectInstance::ParsePersistenceArgs
		  include Rpersistence::ObjectInstance::Persistence
		  include Rpersistence::ObjectInstance::Status

		  ######################
		  #  Default Settings  #
		  ######################

		  attr_persistent!

		  persists_non_atomic_by_default!

		end

		###########################################################################################################
		##############################################  Class  ####################################################
		###########################################################################################################

		Class.instance_eval do

		  include Rpersistence::ClassInstance::Persistence
		  include Rpersistence::ClassInstance::Persistence::Flat
		  include Rpersistence::ClassInstance::Configuration

		  attr_accessor :persistence_key
		  attr_index    :persistence_key

		end
		
	end

end