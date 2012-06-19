
module ::Persistence::Port::Indexing::Bucket::Index::BucketIndex
  
  # a bucket index is a block index that runs on all inserts into a bucket
  # this is opposed to a block index that is defined on one or more classes
  
  include ::Persistence::Port::Indexing::Bucket::Index::BlockIndex  
  
end
