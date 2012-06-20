
module ::Persistence::Object::Flat::ClassInstance

  #############
  #  persist  #
  #############
  
  def persist( global_id )

    return instance_persistence_bucket.get_flat_object( global_id )

  end

end
