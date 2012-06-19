
module ::Persistence::Adapter::Mock::Bucket::Index::Interface

  attr_accessor :parent_bucket

  ################
  #  initialize  #
  ################

  def initialize( index_name, parent_bucket, permits_duplicates )
    
    super() if defined?( super )

    @name = index_name

    @keys = { }
    @reverse_keys = { }
    @permits_duplicates = permits_duplicates
    @parent_bucket = parent_bucket

  end
  
  ############
  #  cursor  #
  ############

  def cursor
    
    return ::Persistence::Adapter::Mock::Cursor.new( @parent_bucket, self )

  end

  ###########
  #  count  #
  ###########
  
  def count
    
    return @keys.count
    
  end
  
  #########################
  #  permits_duplicates?  #
  #########################

  def permits_duplicates?
    
    return @permits_duplicates

  end

  ###################
  #  get_object_id  #
  ###################

  def get_object_id( key )

    return @keys[ key ]
  
  end

  #####################
  #  index_object_id  #
  #####################

  def index_object_id( global_id, key )

    @keys[ key ] = global_id
    @reverse_keys[ global_id ] = key

  end

  ################################
  #  delete_keys_for_object_id!  #
  ################################

  def delete_keys_for_object_id!( global_id )
    
    index_value_or_keys = @reverse_keys.delete( global_id )

    if index_value_or_keys.is_a?( Array )

      index_value_or_keys.each do |this_key|
        @keys.delete( this_key )
      end

    else

      @keys.delete( index_value_or_keys )

    end

  end

end
