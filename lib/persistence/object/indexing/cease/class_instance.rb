
module ::Persistence::Object::Indexing::Cease::ClassInstance

  ############
  #  cease!  #
  ############

  # deletes from storage (archives if appropriate)
  def cease!( *args )

    index, key, no_key = parse_args_for_index_value_no_value( args, true )

    if index
      
      global_id = index.get_object_id( key )
      
    else
      
      global_id = key
      
    end

    indexes.each do |this_index_name, this_index|
      this_index.delete_keys_for_object_id!( global_id )
    end
    
    super( global_id )
    
    return self
    
  end

end
