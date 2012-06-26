
###
# @private
#
# Internal helper module with common features for hashes that store indexes.
#
module ::Persistence::Object::IndexHash

  ###################
  #  post_set_hook  #
  ###################
  
  def post_set_hook( index_name, index_instance )

    configuration_instance.indexes[ index_name ] = index_instance
    
  end
  
  ########################
  #  child_pre_set_hook  #
  ########################
  
  def child_pre_set_hook( index_name, index_instance )
    
    parent_bucket = nil
    
    case configuration_instance
      when ::Module
        parent_bucket = configuration_instance.instance_persistence_bucket
      else
        parent_bucket = configuration_instance.persistence_bucket
    end
    
    child_index_instance = index_instance.class.new( nil, parent_bucket, nil, nil, nil, index_instance )
    
    return child_index_instance
    
  end
  
end
