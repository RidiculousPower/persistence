
module Rpersistence::ObjectClass

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
  
  def persist( with_persistence_key )
    persistence_hash  = persistence_port.adapter.get_from_persistence_port( persistence_bucket, with_persistence_key )
    return object_from_persistence_hash( persistence_hash )
  end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  private

	def add_attribute( atomic, attribute, reader_writer_accessor )
		current_attribute_status = ( atomic ? @persists_atomic : @persists_non_atomic )[ attribute ]
		case current_attribute_status
		when :reader
			case reader_writer_accessor
			when :writer
				( atomic ? @persists_atomic : @persists_non_atomic )[ attribute ] = :accessor
			when nil
				( atomic ? @persists_atomic : @persists_non_atomic )[ attribute ] = :reader
			end
		when :writer
			case reader_writer_accessor
			when :reader
				( atomic ? @persists_atomic : @persists_non_atomic )[ attribute ] = :accessor
			when nil
				( atomic ? @persists_atomic : @persists_non_atomic )[ attribute ] = :writer				
			end
		end
		current_declared_status = @persists_attributes[ attribute ]
	 	case reader_writer_accessor
		when :accessor
			@persists_attributes[ attribute ] = :accessor
		when :reader
			@persists_attributes[ attribute ] = ( current_declared_status == :writer ? :accessor : :reader )
		when :writer
			@persists_attributes[ attribute ] = ( current_declared_status == :reader ? :accessor : :writer )
		end
		flip_attribute_if_necessary( atomic, attribute, reader_writer_accessor )
	end

	def flip_attribute_if_necessary( atomic, attribute, reader_writer_accessor )
		# making attribute atomic/non-atomic, ensuring it's not listed as non-atomic/atomic
		current_attribute_status = ( atomic ? @persists_non_atomic : @persists_atomic )[ attribute ]
		case current_attribute_status
		when :accessor
			( atomic ? @persists_non_atomic : @persists_atomic ).delete( attribute )
		when :reader
			case reader_writer_accessor
			when :accessor
				( atomic ? @persists_non_atomic : @persists_atomic )[ attribute ] = :writer
			when :reader
				( atomic ? @persists_non_atomic : @persists_atomic ).delete( attribute )
			end
		when :writer
			case reader_writer_accessor
			when :accessor
				( atomic ? @persists_non_atomic : @persists_atomic )[ attribute ] = :reader
			when :writer
				( atomic ? @persists_non_atomic : @persists_atomic ).delete( attribute )
			end
		end
	end

	def delete_attribute( attribute )
		@persists_atomic.delete( attribute )
		@persists_non_atomic.delete( attribute )
		@persists_attributes.delete( attribute )
	end

  ##################################
  #  object_from_persistence_hash  #
  ##################################
  
  def object_from_persistence_hash( persistence_hash )
    object = self.new
    persistence_hash.each do |this_persistence_name, this_persistence_value|
      instance_variable_set( "@" + this_persistence_name, this_persistence_value )
    end
  end
  
end

class Class
	extend Rpersistence::Class
end