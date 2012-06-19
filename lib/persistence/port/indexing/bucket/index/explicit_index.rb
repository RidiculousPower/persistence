
module ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex
    
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
    
    raise ::Persistence::Port::Indexing::Bucket::Index::Exceptions::IndexingObjectRequiresKeys.new,
          'No keys provided for index.' if keys.empty?
    
    # check for existing index on keys if we don't permit duplicates
    unless permits_duplicates?

      keys.each do |this_key|
        if global_id = adapter_index.get_object_id( this_key ) and
           global_id != object.persistence_id
          raise ::Persistence::Port::Indexing::Bucket::Index::Exceptions::DuplicateViolatesUniqueIndex.new,
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
