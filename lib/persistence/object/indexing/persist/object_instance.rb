
module ::Persistence::Object::Indexing::Persist::ObjectInstance

  ##############
  #  persist!  #
  ##############
  
  def persist!( *args )
    
    index_instance, key, no_key = parse_args_for_index_value_no_value( args, false )

    # call super to ensure object is persisted
    super()

    if index_instance

      # if we have an index make sure that we have a key
      if no_key
        raise ::Persistence::Object::Indexing::Exceptions::KeyValueRequired,
              'Key required when specifying index for :persist!'
      end

      # and make sure we have an index that permits arbitrary keys
      unless explicit_indexes[ index_instance.name ] == index_instance
        raise ::Persistence::Object::Indexing::Exceptions::ExplicitIndexRequired,
              'Index ' + index_instance.name.to_s + ' was not declared as an explicit index '
              'and thus does not permit arbitrary keys.'
      end

      index_instance.index_object( self, key )
      
    end
    
    unless block_indexes.empty?
      block_indexes.each do |this_index_name, this_block_index|
        this_block_index.index_object( self )
      end
    end
    
    return self
    
  end

end
