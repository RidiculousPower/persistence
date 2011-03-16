
module Rpersistence::KlassAndInstance::Object

  #---------------------------------------------------------------------------------------------------------#
  #-------------------------------------  Shared Object/Instance  ------------------------------------------#
  #---------------------------------------------------------------------------------------------------------#

	# The methods in this module extend Object by default and potentially are also included for instances.
	# Inclusion for instances only occurs if 'rpersistence-modules-instance' is required.
	# See rpersistence-modules-instance for details.

  #####################
  #  self.persist_by  #
  #####################
  
  def persist_by( persistence_key_accessor )
    @persist_key_method = persistence_key_accessor
    return self
  end

  #################################
  #  self.persistence_key_method  #
  #################################

	def persistence_key_method
		return @persist_key_method
	end

  ######################
  #  self.persist_by!  #
  ######################
  
  def persist_by!( persistence_key_accessor )
    persist_by( persistence_key_accessor )
    @persists_everything = true
    return self
  end
  
  ###################
  #  self.store_as  #
  ###################

  def store_as( persistence_bucket_class_or_name )
    @__rpersistence_bucket__ = persistence_bucket_class_or_name
  end
  alias_method :persistence_bucket_name, :store_as

  ########################
  #  self.attrs_atomic!  #
  ########################

  def attrs_atomic!
    @persists_defaults_atomic = true
    @persists_non_atomic = {}
    return self
  end

  ######################
  #  self.attr_atomic  #
  ######################

  def attr_atomic( *attributes )
		attributes.each do |this_attribute|
			add_attribute( true, this_attribute, :accessor )
		end
    class << self
      attr_accessor *attributes
    end unless attributes.any? { |this_attribute| respond_to?( this_attribute ) }
    return self
  end

  #############################
  #  self.attr_atomic_reader  #
  #############################

  def attr_atomic_reader( *attributes )
		attributes.each do |this_attribute|
			add_attribute( true, this_attribute, :reader )
		end
		class << self
      attr_reader *attributes
    end unless attributes.any? { |this_attribute| respond_to?( this_attribute ) }
    return self
  end

  #############################
  #  self.attr_atomic_writer  #
  #############################

  def attr_atomic_writer( *attributes )
		attributes.each do |this_attribute|
			add_attribute( true, this_attribute, :writer )
		end
    class << self
      attr_writer *attributes
    end unless attributes.any? { |this_attribute| respond_to?( this_attribute ) }
    return self
  end

  ############################
  #  self.attrs_non_atomic!  #
  ############################

  def attrs_non_atomic!
    @persists_defaults_atomic = false
    @persists_atomic = {}
    return self
  end

  ##########################
  #  self.attr_non_atomic  #
  ##########################

  def attr_non_atomic( *attributes )
		attributes.each do |this_attribute|
			add_attribute( false, this_attribute, :accessor )
		end
    return self
  end

  #################################
  #  self.attr_non_atomic_reader  #
  #################################

  def attr_non_atomic_reader( *attributes )
		attributes.each do |this_attribute|
			add_attribute( false, this_attribute, :reader )
		end
    return self
  end

  #################################
  #  self.attr_non_atomic_writer  #
  #################################

  def attr_non_atomic_writer( *attributes )
		attributes.each do |this_attribute|
			add_attribute( false, this_attribute, :writer )
		end
    return self
  end

  ##############################
  #  self.attr_non_persistent  #
  ##############################

	def attr_non_persistent( *attributes )
		attributes.each do |this_attribute|
			delete_attribute( this_attribute )
		end
	end

  #####################
  #  self.attr_share  #
  #####################

  def attr_share( klass, *attributes )
    @persists_shared_attributes[ klass ] = {} unless @persists_shared_attributes.has_key?( klass )
    attributes.each do |this_local_attribute_name, this_remote_attribute_name| 
      @persists_shared_attributes[ klass ][ this_local_attribute_name ] = this_local_attribute_name
    end
    return self
  end

  #######################
  #  self.attrs_share!  #
  #######################

  def attrs_share!( klass )
    @persists_shared_attributes[ klass ] = {}
    return self
  end

  #######################
  #  self.attr_isolate  #
  #######################

  def attr_share( klass, *attributes )
    attributes.each do |this_local_attribute_name, this_remote_attribute_name| 
      @persists_shared_attributes[ this_local_attribute_name ] = {  :class      => klass, 
                                                                    :attribute  => this_local_attribute_name }
    end
    return self
  end

  ########################
  #  self.attrs_isolate  #
  ########################

  def attrs_isolate( klass )
    @persists_shared_attributes.delete( klass )
    return self
  end

  #########################
  #  self.attrs_isolate!  #
  #########################

  def attrs_isolate!
    @persists_shared_attributes = {}
    return self
  end

  #################################
  #  self.attrs_merge_like_hash!  #
  #################################

  def attrs_merge_like_hash!
    class << database_two
	    define_method( :merge ) do |other_instance|
				Rpersist.merge_like_hash( self, other_instance )
			end
		end
    return self
  end

  #####################
  #  self.is_atomic?  #
  #####################
  
  def is_atomic?( *attributes )
    return attributes.all? { |this_attribute| @persists_atomic.has_key?[ this_attribute ] }    
  end

  #######################
  #  self.is_delegate?  #
  #######################
  
  def is_delegate?( *attributes )
    return attributes.all? { |this_attribute| @delegate_attributes.has_key?[ this_attribute ] } 
  end
  
  #######################
  #  self.is_property?  #
  #######################
  
  def is_property?( *attributes )
    return attributes.all? { |this_attribute| @property_attributes.has_key?[ this_attribute ] } 
  end

  ##################
  #  self.shared?  #
  ##################
  
  def shared?( *attributes )
    return attributes.all? { |this_attribute| @persists_shared_attributes.has_key?[ this_attribute ] } 
  end

  #####################
  #  self.persisted?  #
  #####################

	def persisted?( with_persistence_key )
    return persist( with_persistence_key ) ? true : false
	end

  #################
  #  self.cease!  #
  #################

	def cease!( *args )
	  case args.length
    when 3
      with_persistence_port, with_persistence_bucket, with_persistence_key = args
    when 2
      with_persistence_port, with_persistence_key = args
    when 1
      with_persistence_key = args.shift
    end
    with_persistence_bucket = persistence_bucket unless with_persistence_bucket
    with_persistence_port   = persistence_port unless with_persistence_port
    with_persistence_port.adapter.delete_object_from_persistence_port_by_bucket_and_key!( with_persistence_key )
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
	
end

class Object
	extend	Rpersistence::KlassAndInstance::Object
end


