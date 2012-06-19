
module ::Persistence::Object::Indexing::Indexes
  
  include ::CascadingConfiguration::Hash

   attr_configuration_hash :indexes

  ###########
  #  index  #
  ###########

   def index( index_name )
     return indexes[ index_name ]
  end
  
  ################
  #  has_index?  #
  ################
  
  def has_index?( *index_names )
    
    has_index = false
    
    index_names.each do |this_index_name|
      break unless has_index = indexes.has_key?( this_index_name )
    end
    
    return has_index

  end

end
