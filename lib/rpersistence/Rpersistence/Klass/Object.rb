
module Rpersistence::Klass::Object

	attr_reader		:persists_attributes, :persists_atomic, :persists_non_atomic, :persists_shared_attributes,
								:persists_everything, :persists_defaults_atomic

  ##############
  #  extended  #
  ##############

  def extended( class_or_module )
    @persists_everything		 			= false
    @persists_defaults_atomic 		= false
    @persists_atomic 							= {}
    @persists_non_atomic 					= {}
		@persists_attributes					=	{}
    @persists_shared_attributes 	= {}		
  end

  #################
  #  self.index!  #
  #################

  # creates independent index on each object ID
  def index!
    persistence_port.adapter.index_object!( self )
  end

  #####################
  #  self.attr_index  #
  #####################

  # creates index for attribute
  def attr_index( *attributes )
    persistence_port.adapter.index_attribute_for_bucket!( self, *attributes )
  end

  ##################
  #  self.persist  #
  ##################
  
	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
  def persist( *args )

		port, bucket, property_name = Rpersistence.parse_persist_args( args )
		
    persistence_ivar_hash  = persistence_port.adapter.get_from_persistence_port( bucket, property_name )

    return object_from_persistence_hash( persistence_ivar_hash )

  end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  private

  ##################################
  #  object_from_persistence_hash  #
  ##################################
  
  def object_from_persistence_hash( persistence_ivar_hash )
    object = self.new
    persistence_ivar_hash.each do |this_persistence_name, this_persistence_value|
      instance_variable_set( "@" + this_persistence_name, this_persistence_value )
    end
  end

end

class Object
	def self.inherited( klass )
		# extend all object classes with Rpersistence
		klass.extend( Rpersistence::Klass::Object )
	end
end
