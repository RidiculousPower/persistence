
module Rpersistence::Class

  ################
  #  initialize  #
  ################

  def initialize
    @attributes_default_atomic = false
    @atomic_attributes = {}
    @non_atomic_attributes = {}
    @shared_attributes = {}
  end

  #####################
  #  self.persist_by  #
  #####################
  
  def persist_by( unique_id_accessor )
    @persist_by = unique_id_accessor
    return self
  end
  alias persist_by persistence_key_method

  ##############################
  #  self.persist_declared_by  #
  ##############################
  
  def persist_declared_by( unique_id_accessor )
    persist_by( unique_id_accessor )
    @persist_declared_only = true
    return self
  end
  
  ###################
  #  self.store_as  #
  ###################

  def store_as( persistence_bucket_class_or_name )
    @persistence_bucket = persistence_bucket_class_or_name
  end
  alias store_as persistence_bucket_name

  ########################
  #  self.attrs_atomic!  #
  ########################

  def attrs_atomic!
    @attributes_default_atomic = true
    @non_atomic_attributes = {}
    return self
  end

  ######################
  #  self.attr_atomic  #
  ######################

  def attr_atomic( *attributes )
    if @attributes_default_atomic
      attributes.each do |this_attribute|
        @atomic_attributes[ this_attribute ]  = :accessor
      end
    else
      attributes.each do |this_attribute|
        @non_atomic_attributes.delete( this_attribute )
      end
    end
    return self
  end

  #############################
  #  self.attr_atomic_getter  #
  #############################

  def attr_atomic_getter( *attributes )
    if @attributes_default_atomic
      attributes.each do |this_attribute|
        case accessor = @atomic_attributes[ this_attribute ]
          when :setter
            @atomic_attributes[ this_attribute ] = :both
          when nil
            @atomic_attributes[ this_attribute ] = :getter
        end
      end
    else
      attributes.each do |this_attribute|
        case accessor = @non_atomic_attributes[ this_attribute ]
          when :both
            @non_atomic_attributes[ this_attribute ] = :setter
          when :getter
            @non_atomic_attributes.delete( this_attribute )
        end
      end
    end
    return self
  end

  #############################
  #  self.attr_atomic_setter  #
  #############################

  def attr_atomic_setter( *attributes )
    if @attributes_default_atomic
      attributes.each do |this_attribute|
        case accessor = @atomic_attributes[ this_attribute ]
          when :getter
            @atomic_attributes[ this_attribute ] = :both
          when nil
            @atomic_attributes[ this_attribute ] = :setter
        end
      end
    else
      attributes.each do |this_attribute|
        case accessor = @non_atomic_attributes[ this_attribute ]
          when :both
            @non_atomic_attributes[ this_attribute ] = :getter
          when :setter
            @non_atomic_attributes.delete( this_attribute )
        end
      end
    end
    return self
  end

  ############################
  #  self.attrs_non_atomic!  #
  ############################

  def attrs_non_atomic!
    @attributes_default_atomic = false
    @atomic_attributes = {}
    return self
  end

  ##########################
  #  self.attr_non_atomic  #
  ##########################

  def attr_non_atomic( *attributes )
    attributes.each { |this_attribute| @atomic_attributes.delete( this_attribute ) } if @atomic_attributes
    return self
  end

  #################################
  #  self.attr_non_atomic_getter  #
  #################################

  def attr_non_atomic_getter( *attributes )
    if @attributes_default_atomic
      attributes.each do |this_attribute|
        case accessor = @non_atomic_attributes[ this_attribute ]
          when :setter
            @non_atomic_attributes[ this_attribute ] = :both
          when nil
            @non_atomic_attributes[ this_attribute ] = :setter
        end
      end
    else
      attributes.each do |this_attribute|
        case accessor = @atomic_attributes[ this_attribute ]
          when :both
            @atomic_attributes[ this_attribute ] = :setter
          when :getter
            @atomic_attributes.delete( this_attribute )
        end
      end
    end
    return self
  end

  #################################
  #  self.attr_non_atomic_setter  #
  #################################

  def attr_non_atomic_setter( *attributes )
    if @attributes_default_atomic
      attributes.each do |this_attribute|
        case accessor = @non_atomic_attributes[ this_attribute ]
          when :getter
            @non_atomic_attributes[ this_attribute ] = :both
          when nil
            @non_atomic_attributes[ this_attribute ] = :getter
        end
      end
    else
      attributes.each do |this_attribute|
        case accessor = @atomic_attributes[ this_attribute ]
          when :both
            @atomic_attributes[ this_attribute ] = :getter
          when :setter
            @atomic_attributes.delete( this_attribute )
        end
      end
    end
    return self
  end

  #####################
  #  self.attr_share  #
  #####################

  def attr_share( klass, *attributes )
    @shared_attributes[ klass ] = {} unless @shared_attributes.has_key?( klass )
    attributes.each do |this_local_attribute_name, this_remote_attribute_name| 
      @shared_attributes[ klass ][ this_local_attribute_name ] = this_local_attribute_name
    end
    return self
  end

  #######################
  #  self.attrs_share!  #
  #######################

  def attrs_share!( klass )
    @shared_attributes[ klass ] = {}
    return self
  end

  #######################
  #  self.attr_isolate  #
  #######################

  def attr_share( klass, *attributes )
    attributes.each do |this_local_attribute_name, this_remote_attribute_name| 
      @shared_attributes[ this_local_attribute_name ] = {   :class      => klass, 
                                                            :attribute  => this_local_attribute_name }
    end
    return self
  end

  ########################
  #  self.attrs_isolate  #
  ########################

  def attrs_isolate( klass )
    @shared_attributes.delete( klass )
    return self
  end

  #########################
  #  self.attrs_isolate!  #
  #########################

  def attrs_isolate!
    @shared_attributes = {}
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
    return attributes.all? { |this_attribute| @atomic_attributes.has_key?[ this_attribute ] }    
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
    return attributes.all? { |this_attribute| @shared_attributes.has_key?[ this_attribute ] } 
  end
  
end