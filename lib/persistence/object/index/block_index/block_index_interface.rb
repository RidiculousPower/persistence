
module ::Persistence::Object::Index::BlockIndex::BlockIndexInterface
  
  include ::Persistence::Object::Index
  
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array

  def initialize( index_name, 
                  parent_bucket, 
                  permits_duplicates = nil, 
                  sorting_proc_or_sort_names = nil, 
                  duplicates_sorting_proc_or_sort_names = nil,
                  ancestor_index_instance = nil,
                  & indexing_block )
    
    super
    
    if block_given?
      indexing_procs.push( indexing_block )
    elsif indexing_procs.empty?
      raise ::Persistence::Exception::BlockRequired, 'Block required for index.'
    end
    
        
  end

  ###################
  #  requires_keys  #
  ###################

  attr_setting  :requires_keys

  #######################
  #  permits_nil_keys?  #
  #######################
  
  attr_setting  :permits_nil_keys?

  ####################
  #  indexing_procs  #
  ####################

  attr_array  :indexing_procs
    
  ##################
  #  index_object  #
  ##################

  def index_object( object )

    # get key(s) from block(s)
    keys = [ ]
    indexing_procs.each do |this_indexing_proc|

      if block_return = object.instance_eval( & this_indexing_proc ) or
         permits_nil_keys?

        keys.push( block_return )

      end

    end

    if keys.empty?

      if requires_keys
        raise ::Persistence::Exception::IndexingBlockFailedToGenerateKeys.new,
              'Index block failed to generate keys, which were required.'      
      end

    else
      
      super( object, *keys )

    end
    
    return self
    
  end
  
end
