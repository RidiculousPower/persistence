
module ::Persistence::Port::Indexing::Bucket::Index::IndexInterface

  include ::Persistence::Port::Indexing::Bucket::Index::SortingProcs

  include ::CascadingConfiguration::Setting
  
  attr_configuration :permits_duplicates

  attr_reader   :name, :parent_bucket

  ################
  #  initialize  #
  ################

  def initialize( index_name, 
                  parent_bucket, 
                  permits_duplicates = false, 
                  sorting_proc_or_sort_names = nil, 
                  duplicates_sorting_proc_or_sort_names = nil )
    
    super() if defined?( super )

    @name = index_name
    self.permits_duplicates = permits_duplicates
    
    init_sorting_procs( sorting_proc_or_sort_names, duplicates_sorting_proc_or_sort_names )
    
    initialize_for_bucket( parent_bucket )
      
  end

  ###########################
  #  initialize_for_bucket  #
  ###########################
  
  def initialize_for_bucket( parent_bucket )

    @parent_bucket = parent_bucket

    # object indexes are held and run by the classes/modules that define them
    # synchronize the index instance with the parent bucket's adapter instance

    if adapter_bucket = parent_bucket.instance_variable_get( :@adapter_bucket )

      if adapter_bucket.has_index?( @name )

        @adapter_index = adapter_bucket.index( @name )

        # if index has aleady been declared and permits_duplicates does not match, raise error
        # double ! ensures equality for false == nil
        if ! permits_duplicates != ! @adapter_index.permits_duplicates?
           raise ::Persistence::Port::Indexing::Bucket::Index::Exceptions::ConflictingIndexAlreadyDeclared, 
                 'Index ' + @name.to_s + ' has already been declared, ' +
                 'and new duplicates declaration does not match existing declaration.'
        end

      else
      
        # get adapter index instance in adapter bucket
        @adapter_index = parent_bucket.adapter_bucket.create_index( @name, @permits_duplicates )

      end

    else
      
      parent_bucket.pend_index( self )
    
    end
    
  end

  ##############################
  #  disable_adapter_instance  #
  ##############################

  def disable_adapter_instance

    @adapter_index = nil
    
  end

end
