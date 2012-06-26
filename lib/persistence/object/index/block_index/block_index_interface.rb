
###
# Interface for block index instances, which index keys provided by running a Proc on an object instance.
#
module ::Persistence::Object::Index::BlockIndex::BlockIndexInterface
  
  include ::Persistence::Object::Index
  
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array
  
  ###
  #
  # @yield [object] Block to create index keys on object.
  # @yieldparam object [Object] Object to index.
  #
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

  ###
  # Whether index requires keys be generated when block is run.
  #
  # @return [true,false] Whether keys must be generated.
  #
  attr_setting  :requires_keys

  #######################
  #  permits_nil_keys?  #
  #######################
  
  ###
  # Whether index permits nil keys be generated when block is run.
  #
  # @return [true,false] Whether keys must be non-nil.
  #
  attr_setting  :permits_nil_keys?

  ####################
  #  indexing_procs  #
  ####################
  
  ###
  # Procs used to generate keys.
  #
  # @return [CompositingArray<Proc>] Procs for key generation.
  #
  attr_array  :indexing_procs
    
  ##################
  #  index_object  #
  ##################

  ###
  # Index keys for object instance.
  #
  # @param object [Object] Object to index.
  #
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
