
module ::Persistence::Port::Indexing::Bucket::Index::ObjectOrientedIndex
  
  # an ObjectOrientedIndex indexes values relative to an object
  # this is used primarily for inheritance purposes
  
  include ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex

  ############################
  #  index_existing_objects  #
  ############################

  def index_existing_objects
    
    @parent_bucket.each do |this_object|
      index_object( this_object )
    end

    return self
  
  end
  alias_method :sync_index, :index_existing_objects

end
