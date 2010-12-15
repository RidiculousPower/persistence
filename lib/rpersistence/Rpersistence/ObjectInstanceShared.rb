
module Rpersistence::ObjectClassAndInstance

  ################
  #  initialize  #
  ################

	# When object initializes, copy class settings to instance.
	# Changes to instance after initialize are instance-specific.
	# Changes to class configuration after initialize have no effect on instance until object is persisted
	# from storage, in which case it will take on class configuration (unless it has instance configuration
	# saved).
	def initialize
    @persists_everything		 			= self.class.persists_everything?
    @persists_defaults_atomic 		= self.class.defaults_atomic?
    @persists_atomic 							= self.class.persists_atomic
    @persists_non_atomic 					= self.class.persists_non_atomic
		@persists_attributes					=	self.class.persists_attributes
    @persists_shared_attributes 	= self.class.persists_shared_attributes
	end
	ensure_initialize!

  #---------------------------------------------------------------------------------------------------------#
  #-------------------------------------  Shared Object/Instance  ------------------------------------------#
  #---------------------------------------------------------------------------------------------------------#

	# The methods in this module extend Object by default and potentially are also included for instances.
	# Inclusion for instances only occurs if 'rpersistence-modules-instance' is required.

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
    @persistence_bucket = persistence_bucket_class_or_name
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
      @persists_shared_attributes[ this_local_attribute_name ] = {   :class      => klass, 
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








  #---------------------------------------------------------------------------------------------------------#
  #--------------------------------------  Shared Class/Object  --------------------------------------------#
  #---------------------------------------------------------------------------------------------------------#

	# These methods are defined both on Object and on instances of Object.
	# When an instance is created it is given the persistence characteristics of its class.
	# Instance persistence characteristics will only be saved if :persist_by_instance! is called on the 
	# instance. If instance persistence characteristics are not saved, all saved parameters will be loaded,
	# but future persistence will behave the same as any other instance of the class as currently configured
	# at the time of the call to :persist!, or at the calling of any atomic accessors.


  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

	private
	
	
end

class Object
	extend	Rpersistence::ClassAndObject	
	include	Rpersistence::ClassAndObject	
end


