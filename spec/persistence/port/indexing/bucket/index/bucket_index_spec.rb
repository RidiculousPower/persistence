
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Port::Indexing::Bucket::Index::BucketIndex do

  it 'is a block index that runs on all inserts into a bucket' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Port::Indexing::Bucket::Index::BucketIndex::Mock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      attr_accessor :some_value
    end
    
    object = ::Persistence::Port::Indexing::Bucket::Index::BucketIndex::Mock.new

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    index_instance = object.persistence_bucket.create_index( :bucket_index ) do |object|
      object.some_value
    end
    index_instance.extend( ::Persistence::Port::Indexing::Bucket::Index::BucketIndex )
    
    index_instance.is_a?( ::Persistence::Port::Indexing::Bucket::Index::BucketIndex ).should == true

    ::Persistence.disable_port( :mock )

  end

end
