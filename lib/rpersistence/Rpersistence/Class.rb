
module Rpersistence::Class

	attr_reader		:persists_attributes, :persists_atomic, :persists_non_atomic, :persists_shared_attributes,
								:persists_everything, :persists_default_atomic

  ################
  #  initialize  #
  ################

  def initialize
    @persists_everything		 			= false
    @persists_default_atomic 			= false
    @persists_atomic 							= {}
    @persists_non_atomic 					= {}
		@persists_attributes					=	{}
    @persists_shared_attributes 	= {}
  end

  #####################
  #  self.persist_by  #
  #####################
  
  def persist_by( unique_id_accessor )
    @persist_by = unique_id_accessor
    return self
  end
  alias :persist_by :persistence_key_method

  ######################
  #  self.persist_by!  #
  ######################
  
  def persist_by!( unique_id_accessor )
    persist_by( unique_id_accessor )
    @persists_everything = true
    return self
  end
  
  ###################
  #  self.store_as  #
  ###################

  def store_as( persistence_bucket_class_or_name )
    @persistence_bucket = persistence_bucket_class_or_name
  end
  alias :store_as :persistence_bucket_name

  ########################
  #  self.attrs_atomic!  #
  ########################

  def attrs_atomic!
    @persists_default_atomic = true
    @persists_non_atomic = {}
    return self
  end

  ######################
  #  self.attr_atomic  #
  ######################

  def attr_atomic( *attributes )
    if @persists_default_atomic
      attributes.each do |this_attribute|
        @persists_atomic[ this_attribute ]  	= :accessor
				@persists_attributes[ this_attribute ]	=	:accessor
      end
    else
      attributes.each do |this_attribute|
        @persists_non_atomic.delete( this_attribute )
				@persists_attributes.delete( this_attribute )
      end
    end
    return self
  end

  #############################
  #  self.attr_atomic_getter  #
  #############################

  def attr_atomic_getter( *attributes )
    if @persists_default_atomic
      attributes.each do |this_attribute|
        case accessor = @persists_atomic[ this_attribute ]
          when :setter
            @persists_atomic[ this_attribute ] 		= :accessor
						@persists_attributes[ this_attribute ]	=	:accessor
          when nil
            @persists_atomic[ this_attribute ] 		= :getter
						if @persists_attributes[ this_attribute ] == :setter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:getter
						end
        end
      end
    else
      attributes.each do |this_attribute|
        case accessor = @persists_non_atomic[ this_attribute ]
          when :accessor
            @persists_non_atomic[ this_attribute ] 	= :setter
						if @persists_attributes[ this_attribute ] == :getter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:setter
						end
          when :getter
            @persists_non_atomic.delete( this_attribute )
        end
      end
    end
    return self
  end

  #############################
  #  self.attr_atomic_setter  #
  #############################

  def attr_atomic_setter( *attributes )
    if @persists_default_atomic
      attributes.each do |this_attribute|
        case accessor = @persists_atomic[ this_attribute ]
          when :getter
            @persists_atomic[ this_attribute ] 		= :accessor
						@persists_attributes[ this_attribute ]	=	:accessor
          when nil
            @persists_atomic[ this_attribute ] 		= :setter
						if @persists_attributes[ this_attribute ] == :getter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:setter
						end
        end
      end
    else
      attributes.each do |this_attribute|
        case accessor = @persists_non_atomic[ this_attribute ]
          when :accessor
            @persists_non_atomic[ this_attribute ] 	= :getter
						@persists_attributes[ this_attribute ]		=	:getter
						if @persists_attributes[ this_attribute ] == :setter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:getter
						end
          when :setter
            @persists_non_atomic.delete( this_attribute )
        end
      end
    end
    return self
  end

  ############################
  #  self.attrs_non_atomic!  #
  ############################

  def attrs_non_atomic!
    @persists_default_atomic = false
    @persists_atomic = {}
    return self
  end

  ##########################
  #  self.attr_non_atomic  #
  ##########################

  def attr_non_atomic( *attributes )
    attributes.each { |this_attribute| @persists_atomic.delete( this_attribute ) } if @persists_atomic
    return self
  end

  #################################
  #  self.attr_non_atomic_getter  #
  #################################

  def attr_non_atomic_getter( *attributes )
    if @persists_default_atomic
      attributes.each do |this_attribute|
        case accessor = @persists_non_atomic[ this_attribute ]
          when :setter
            @persists_non_atomic[ this_attribute ] 	= :accessor
						@persists_attributes[ this_attribute ]		=	:getter
						if @persists_attributes[ this_attribute ] == :setter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:getter
						end
          when nil
            @persists_non_atomic[ this_attribute ] 	= :setter
						if @persists_attributes[ this_attribute ] == :setter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:getter
						end
        end
      end
    else
      attributes.each do |this_attribute|
        case accessor = @persists_atomic[ this_attribute ]
          when :accessor
            @persists_atomic[ this_attribute ] = :setter
						if @persists_attributes[ this_attribute ] == :setter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:getter
						end
          when :getter
            @persists_atomic.delete( this_attribute )
        end
      end
    end
    return self
  end

  #################################
  #  self.attr_non_atomic_setter  #
  #################################

  def attr_non_atomic_setter( *attributes )
    if @persists_default_atomic
      attributes.each do |this_attribute|
        case accessor = @persists_non_atomic[ this_attribute ]
          when :getter
            @persists_non_atomic[ this_attribute ] 	= :accessor
						@persists_attributes[ this_attribute ]		=	:accessor
          when nil
            @persists_non_atomic[ this_attribute ] 	= :getter
						@persists_attributes[ this_attribute ]		=	:getter
						if @persists_attributes[ this_attribute ] == :setter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:getter
						end
        end
      end
    else
      attributes.each do |this_attribute|
        case accessor = @persists_atomic[ this_attribute ]
          when :accessor
            @persists_atomic[ this_attribute ]	 		= :getter
						if @persists_attributes[ this_attribute ] == :setter
							@persists_attributes[ this_attribute ]	=	:accessor
						else
							@persists_attributes[ this_attribute ]	=	:getter
						end
          when :setter
            @persists_atomic.delete( this_attribute )
        end
      end
    end
    return self
  end

  ##############################
  #  self.attr_non_persistent  #
  ##############################

	def attr_non_persistent( this_attribute )
		@persists_atomic.delete( this_attribute )
		@persists_non_atomic.delete( this_attribute )
		@persists_attributes.delete( this_attribute )
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
    merge_method_lambda = lambda { |other_instance| return Rpersist.merge_like_hash( self, other_instance ) }
    metaclass = class << database_two ; self ; end
    metaclass.__send__( :define_method, :merge, & merge_method_lambda )
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

  #################
  #  self.cease!  #
  #################

	def cease!( *args )
		unique_key			= nil
		storage_port		=	nil
		storage_bucket	=	nil
		Rargs.define_and_parse( args ) do
			# unique key
			parameter_set(		parameter(		match_any(			unique_key ) ) )
			# storage port, unique key
			parameter_set(		parameter(		match_symbol(		) ),
												parameter(		match_any(			unique_key ) ) )
			# storage port, storage bucket, unique key
			parameter_set(		parameter(		match_symbol() ),
												parameter(		match_string_symbol(),
												 							match_class() ),
												parameter(		match_any(			unique_key ) ) )
		end
	end
  
end