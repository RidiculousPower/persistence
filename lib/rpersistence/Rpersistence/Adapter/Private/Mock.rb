
#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Mock Adapter  -----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Rpersistence::Adapter::Mock

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################
    
    #######################################
    #  declare_storage_secondary_indexes  #
    #######################################

    def index_object( object )

      # persistence_bucket_key: [ 0:  persistence_id
      #                            1:  locale, 
      #                            2:  version,
      #                            3:  property_name,
      #                           4:  complex_property,
      #                            5:  delete_cascades ]
      

      # 1: locale
      database.has_index_with_sorted_duplicates( :locale ) do |persistence_bucket_key, persistence_value|
        locale = persistence_bucket_key[ 1 ]
        locale
      end

      # 2: version
      database.has_index_with_sorted_duplicates( :version ) do |persistence_bucket_key, persistence_value|
        version = persistence_bucket_key[ 2 ]
        version
      end

      # 3: property_name
      database.has_index_with_sorted_duplicates( :property_name ) do |persistence_bucket_key, persistence_value|
        property_name = persistence_bucket_key[ 3 ]
        property_name
      end

      # 4: property_value
      database.has_index_with_sorted_duplicates( :property_value ) do |persistence_bucket_key, persistence_value|
        persistence_value
      end
    
    end

    ##########################################
    #  ensure_object_has_globally_unique_id  #
    ##########################################
    
    def ensure_object_has_globally_unique_id( object )
    
      if object.persistence_id_required?

        # in which case we need to create a new ID
         @id_sequence = ( @id_sequence ||= -1 ) + 1
         object.persistence_id = @id_sequence
    
        @id_for_bucket_key[ object.persistence_bucket ] ||= Hash.new

        @id_for_bucket_key[ object.persistence_bucket ][ object.persistence_key ]  =  @id_sequence
      
        @bucket_key_class_for_id[ object.persistence_id ] = [ object.persistence_bucket, object.persistence_key, object.class ]
      
      end
    
      return object.persistence_id
    
    end

end
