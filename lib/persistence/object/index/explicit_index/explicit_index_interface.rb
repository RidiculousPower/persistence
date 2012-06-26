
###
# Interface for explicit index instances, which index keys that are explicitly provided.
#
module ::Persistence::Object::Index::ExplicitIndex::ExplicitIndexInterface
  
  include ::Persistence::Object::Index
  
  ###
  #
  # @method index_existing_objects
  #
  # We undefine :index_existing_objects because it makes no sense on an index requiring explicit keys.
  # 
  undef_method( :index_existing_objects )

  ##################
  #  index_object  #
  ##################

  ###
  # Index keys for object instance.
  #
  # @param object [Object] Object to index.
  #
  # @param keys [Array<Object>] Keys to use for index entries.
  #
  def index_object( object, *keys )
    
    if keys.empty?
      raise ::Persistence::Exception::IndexingObjectRequiresKeys.new,
            'No keys provided for index.'
    end
    
    # check for existing index on keys if we don't permit duplicates
    unless permits_duplicates?

      keys.each do |this_key|
        if global_id = adapter_index.get_object_id( this_key ) and
           global_id != object.persistence_id
          raise ::Persistence::Exception::DuplicateViolatesUniqueIndex.new,
                'Attempt to create index for key ' + this_key.to_s +
                ' would create duplicates in unique index :' + @name.to_s + '.'
        end
      end
    
    end

    keys.each do |this_key|
      adapter_index.index_object_id( object.persistence_id, this_key )
    end

    return self
    
  end
  
end
