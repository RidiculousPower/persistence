
module ::Persistence::Cursor::Indexing::Cursor
  
  ################
  #  initialize  #
  ################
  
  def initialize( bucket_instance, index_instance = nil )

    @persistence_bucket = bucket_instance
    @parent_index = index_instance
    
    # use persistence port, bucket, index, value to instantiate adapter cursor
    if index_instance
      @adapter_cursor = index_instance.adapter_index.cursor
    else
      @adapter_cursor = bucket_instance.adapter_bucket.cursor
    end
        
  end

end
