
module ::Persistence::Object::Indexing::Indexes::ClassInstance

  ##################
  #  delete_index  #
  ##################
  
  def delete_index( *attributes )
    
    attributes.each do |this_index|
      indexes.delete( this_index )
      persistence_port.delete_index( self, this_index )
    end
    
    return self
    
  end

end
