
module ::Persistence::Object::Index::ExplicitIndex::ExplicitIndexInterface
  
  include ::Persistence::Object::Index
  
  ############################
  #  index_existing_objects  #
  ############################
  
  def index_existing_objects
    
   # implement in module as necessary
   # arbitrary key/value indexing does not ever index existing objects automatically

  end

  ##################
  #  index_object  #
  ##################

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
