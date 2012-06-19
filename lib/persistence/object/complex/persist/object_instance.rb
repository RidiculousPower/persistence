
module ::Persistence::Object::Complex::Persist::ObjectInstance

  #############
  #  persist  #
  #############
  
  def persist

    persistence_hash_from_port = persistence_bucket.get_object_hash( persistence_id )
    load_persistence_hash( persistence_port, persistence_hash_from_port )
    
    return self

  end

end
