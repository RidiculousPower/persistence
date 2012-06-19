
module ::Persistence::Port::Indexing::Bucket::Index::BlockIndex
  
  include ::Persistence::Port::Indexing::Bucket::Index::ObjectOrientedIndex

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array

  attr_configuration       :requires_keys, :permits_nil_keys
  attr_configuration_array :indexing_procs
    
  ##################
  #  index_object  #
  ##################

  def index_object( object )

    # get key(s) from block(s)
    keys = [ ]
    indexing_procs.each do |this_indexing_proc|

      if block_return = object.instance_eval( & this_indexing_proc ) or
         permits_nil_keys

        keys.push( block_return )

      end

    end

    if keys.empty?

      if requires_keys
        raise ::Persistence::Port::Indexing::Bucket::Index::Exceptions::IndexingBlockFailedToGenerateKeys.new,
              'Indexing block failed to generate keys, which were required.'      
      end

    else
      
      super( object, *keys )

    end
    
    return self
    
  end
  
end
