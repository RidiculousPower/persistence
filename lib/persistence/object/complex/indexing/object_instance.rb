
module ::Persistence::Object::Complex::Indexing::ObjectInstance

  include ::Persistence::Object::Complex::Indexing::Indexes::Attributes
  include ::Persistence::Object::Complex::Indexing::PersistAndCease::ObjectInstance
  
  ###################
  #  set_attribute  #
  ###################

  def set_attribute( attribute, value )

    super

    if has_attribute_index?( attribute )  and 
       persistence_id                     and 
       atomic_attribute?( attribute )

       attribute_indexes[ attribute ].index_object( self )

    end
    
  end
  
end
