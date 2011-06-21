# Rpersistence::Adapter::Mock
#
# Mock Adapter for Specification

#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Mock Adapter  -----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Rpersistence::Adapter::Mock

  CursorClass = Rpersistence::Cursor::Mock

  ################
  #  initialize  #
  ################

  def initialize( home_directory = nil )
    @enabled                   = false
    @bucket_class_for_id       = Hash.new
    @complex_property_for_id   = Hash.new
    @delete_cascades_for_id    = Hash.new
    @buckets                   = Hash.new
    @indexes                   = Hash.new
    @values                    = Hash.new
    @reverse_values            = Hash.new
  end

  ############
  #  enable  #
  ############

  def enable
    @enabled  =  true
    return self
  end

  #############
  #  disable  #
  #############

  def disable
    @enabled  = false
    return self
  end

  ##############
  #  enabled?  #
  ##############

  def enabled?
    return @enabled
  end

  ################################################ ID #######################################################

  ############################################
  #  get_object_id_for_bucket_index_and_key  #
  ############################################

  def get_object_id_for_bucket_index_and_key( bucket, index, key )

    bucket_location       = ( @values[ bucket ] ||= Hash.new )
    bucket_index_location = ( @values[ bucket ][ index ] ||= Hash.new )

    global_id = bucket_index_location[ key ]
    
    return global_id
  
  end

  ####################################
  #  get_bucket_class_for_object_id  #
  ####################################

  def get_bucket_class_for_object_id( global_id )

    return @bucket_class_for_id[ global_id ]
  
  end

  #######################################
  #  persistence_key_exists_for_index?  #
  #######################################

  def persistence_key_exists_for_index?( bucket, index, key )

    return ( get_object_id_for_bucket_index_and_key( bucket, index, key ) ? true : false )

  end

  ###################################
  #  primary_key_for_property_name  #
  ###################################

  def primary_key_for_property_name( object, property_name )

    return property_name

  end

  ######################################### Complex Objects #################################################
  
  #################
  #  put_object!  #
  #################

  # must be recoverable by information in the object
  # we currently use class and persistence key
  def put_object!( object )
    ensure_object_has_globally_unique_id( object )
    @buckets[ object.persistence_bucket ] ||= Hash.new
    @complex_property_for_id[ object.persistence_id ] ||= Hash.new
    @delete_cascades_for_id[ object.persistence_id ] ||= Hash.new
    object_persistence_hash = object.persistence_hash_to_port
    @buckets[ object.persistence_bucket ][ object.persistence_id ] = object_persistence_hash
    complex_properties = object.instance_variable_get( :@__rpersistence__cache__complex_property__ )
    complex_properties.each do |this_complex_property, true_or_false|
      if true_or_false
        @complex_property_for_id[ object.persistence_id ][ this_complex_property ]   = true
        @delete_cascades_for_id[ object.persistence_id ] ||= Hash.new
        @delete_cascades_for_id[ object.persistence_id ][ this_complex_property ]    = object.delete_cascades?( object.persistence_port, this_complex_property )
      end
    end if complex_properties

    return object.persistence_id
  end

  ################
  #  get_object  #
  ################

  def get_object( global_id, bucket )
    @buckets[ bucket ] ||= Hash.new
    @complex_property_for_id[ global_id ] ||= Hash.new
    existing_object_hash  =  @buckets[ bucket ][ global_id ]
    persistence_hash_from_port  =  @buckets[ bucket ][ global_id ].dup if existing_object_hash
    if persistence_hash_from_port
      persistence_hash_from_port.each do |this_property, this_value|
        if @complex_property_for_id[ global_id ][ this_property ]
          sub_object_bucket, sub_object_klass = get_bucket_class_for_object_id( this_value )
          persistence_hash_from_port[ this_property ]  = [ :__rpersistence__complex_object__, sub_object_klass, get_object( this_value, sub_object_bucket ) ]
        end
      end
    end
    return persistence_hash_from_port || Hash.new
  end
  
  ####################
  #  delete_object!  #
  ####################

  def delete_object!( global_id, bucket )
    @buckets[ bucket ] ||= Hash.new
    persistence_hash_from_port  =  @buckets[ bucket ][ global_id ]
    if persistence_hash_from_port
      persistence_hash_from_port.each do |this_property, this_value|
        if @complex_property_for_id[ global_id ][ this_property ] and @delete_cascades_for_id[ global_id ][ this_property ]
          sub_object_bucket, sub_object_klass = get_bucket_class_for_object_id( this_value )
          delete_object!( this_value, sub_object_bucket )
        end
      end
    end
    # and now delete the object's ID reference
    @buckets[ bucket ].delete( global_id )
    bucket, klass = @bucket_class_for_id[ global_id ]
    @bucket_class_for_id.delete( global_id )
    return self
  end

  ########################################### Properties ####################################################
  
  ###################
  #  put_property!  #
  ###################

  def put_property!( object, property_name, property_value )
    @buckets[ object.persistence_bucket ] ||= Hash.new
    @buckets[ object.persistence_bucket ][ object.persistence_id ] ||= Hash.new
    @buckets[ object.persistence_bucket ][ object.persistence_id ][ property_name ] = property_value
    return self
  end

  ##################
  #  get_property  #
  ##################

  def get_property( object, property_name )
    @buckets[ object.persistence_bucket ] ||= Hash.new
    @buckets[ object.persistence_bucket ][ object.persistence_id ] ||= Hash.new
    return @buckets[ object.persistence_bucket ][ object.persistence_id ][ property_name ]
  end

  ######################
  #  delete_property!  #
  ######################

  def delete_property!( object, property_name )
    @buckets[ object.persistence_bucket ] ||= Hash.new
    @buckets[ object.persistence_bucket ][ object.persistence_id ] ||= Hash.new
    @buckets[ object.persistence_bucket ][ object.persistence_id ].delete( property_name )
    return self
  end

  #######################
  #  complex_property?  #
  #######################

  def complex_property?( object, property_name )
    @complex_property_for_id[ object.persistence_id ] ||= Hash.new
    return @complex_property_for_id[ object.persistence_id ][ property_name ]
  end

  ######################
  #  delete_cascades?  #
  ######################

  def delete_cascades?( object, property_name )
    @delete_cascades_for_id[ object.persistence_id ] ||= Hash.new
    return @delete_cascades_for_id[ object.persistence_id ][ property_name ]
  end
  
  ############################################# Indexes #####################################################

  ################
  #  has_index?  #
  ################
  
  def has_index?( klass, index )
    return @indexes[ klass.instance_persistence_bucket ] && @indexes[ klass.instance_persistence_bucket ].has_key?( index )
  end

  ###############################
  #  index_permits_duplicates?  #
  ###############################

  def index_permits_duplicates?( klass, index )
    if @indexes[ klass.instance_persistence_bucket ]
      return @indexes[ klass.instance_persistence_bucket ][ index ] == :permits_duplicates
    end
    return false
  end

  ##################
  #  create_index  #
  ##################

  def create_index( klass, attribute, permits_duplicates )
    ( @indexes[ klass.instance_persistence_bucket ] ||= Hash.new )[ attribute ] = permits_duplicates
  end

  ##################
  #  delete_index  #
  ##################

  def delete_index( klass, attribute )
    ( @indexes[ klass.instance_persistence_bucket ] ||= Hash.new ).delete( attribute )
    ( @values[ klass.instance_persistence_bucket ] ||= Hash.new ).delete( attribute )
  end

  #############################
  #  delete_index_for_object  #
  #############################

  def delete_index_for_object( bucket, index, global_id )
    bucket_location = ( @values[ bucket ] ||= Hash.new )
    bucket_index_location = ( bucket_location[ index ] ||= Hash.new )
    reverse_bucket_location = ( @reverse_values[ bucket ] ||= Hash.new )
    reverse_bucket_index_location = ( reverse_bucket_location[ index ] ||= Hash.new )
    keys_for_index = reverse_bucket_index_location.delete( global_id )
    if keys_for_index.is_a?( Array )
      bucket_index_location -= keys_for_index
    else
      bucket_index_location.delete( keys_for_index )
    end
  end

  ############################
  #  index_object_attribute  #
  ############################

  def index_object_attribute( object, attribute, value )
    ( ( @values[ object.persistence_bucket ] ||= Hash.new )[ attribute ] ||= Hash.new )[ value ] = object.persistence_id
    ( ( @reverse_values[ object.persistence_bucket ] ||= Hash.new )[ attribute ] ||= Hash.new )[ object.persistence_id ] = value
  end

  ###################################
  #  object_has_attribute_indexed?  #
  ###################################

  def object_has_attribute_indexed?( object, attribute )
    return @values[ object.persistence_bucket ] && @values[ object.persistence_bucket ].has_key?( attribute ) && @values[ object.persistence_bucket ][ attribute ].has_key?( object.__send_( attribute ) )
  end

end
