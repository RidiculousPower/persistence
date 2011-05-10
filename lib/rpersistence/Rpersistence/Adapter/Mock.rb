# Rpersistence::Adapter::Mock
#
# Mock Adapter for Specification

#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Mock Adapter  -----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Rpersistence::Adapter::Mock

  include Rpersistence::Adapter::Support::Initialize
  include Rpersistence::Adapter::Support::Enable
  include Rpersistence::Adapter::Support::PrimaryKey::Simple

  ################
  #  initialize  #
  ################

  def initialize( home_directory = nil )
    super( home_directory )
    @id_for_bucket_key         = Hash.new
    @bucket_key_class_for_id   = Hash.new
    @complex_property_for_id   = Hash.new
    @delete_cascades_for_id   = Hash.new
    @buckets                  =  Hash.new
  end

  ################################################ ID #######################################################

  ######################################
  #  get_object_id_for_bucket_and_key  #
  ######################################

  def get_object_id_for_bucket_and_key( bucket, key )

    @id_for_bucket_key[ bucket ] ||= Hash.new
    
    return @id_for_bucket_key[ bucket ][ key ]
  
  end

  ########################################
  #  get_bucket_key_class_for_object_id  #
  ########################################

  def get_bucket_key_class_for_object_id( global_id )

    return @bucket_key_class_for_id[ global_id ]
  
  end

  ########################################
  #  persistence_key_exists_for_bucket?  #
  ########################################

  def persistence_key_exists_for_bucket?( bucket, key )

    return ( get_object_id_for_bucket_and_key( bucket, key ) ? true : false )

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
    @delete_cascades_for_id[ object.persistence_id ] || Hash.new
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
          sub_object_bucket, sub_object_key, sub_object_klass = get_bucket_key_class_for_object_id( this_value )
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
          sub_object_bucket, sub_object_key, sub_object_klass = get_bucket_key_class_for_object_id( this_value )
          delete_object!( this_value, sub_object_bucket )
        end
      end
    end
    # and now delete the object's ID reference
    @buckets[ bucket ].delete( global_id )
    bucket, key, klass = @bucket_key_class_for_id[ global_id ]
    @bucket_key_class_for_id.delete( global_id )
    @id_for_bucket_key[ bucket ][ key ]
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
  
  ###################
  #  index_object!  #
  ###################
  
  def index_object!
    
  end

  #################################
  #  index_attribute_for_bucket!  #
  #################################
  
  def index_attribute_for_bucket!
    
  end

end
