
module ::Persistence::Object::Indexing::Cease::ObjectInstance

  ############
  #  cease!  #
  ############

  # deletes from storage (archives if appropriate)
  def cease!

    indexes.each do |this_index_name, this_index|
      this_index.delete_keys_for_object_id!( persistence_id )
    end

    super
    
    return self
    
  end
  
end
