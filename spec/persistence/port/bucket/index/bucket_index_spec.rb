
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Port::Bucket::BucketIndex do

  it 'is a block index that runs on all inserts into a bucket' do
    class ::Persistence::Port::Bucket::BucketIndex::Mock
      include ::Persistence::Object
      attr_accessor :some_value
    end
    
    object = ::Persistence::Port::Bucket::BucketIndex::Mock.new

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    index_instance = object.persistence_bucket.create_index( :bucket_index ) do |object|
      object.some_value
    end
    
    index_instance.is_a?( ::Persistence::Port::Bucket::BucketIndex ).should == true

    ::Persistence.disable_port( :mock )

  end

  ##################
  #  create_index  #
  #  has_index?    #
  #  count         #
  #  index         #
  ##################

  it 'can create an index and then separately retrieve that index' do
    # before port is open    
    class ::Persistence::Port::Bucket::BucketIndex::Mock
      include ::Persistence::Object
      attr_atomic_accessor :some_value, :some_other_value
    end
    
    bucket = ::Persistence::Port::Bucket::BucketIndex::Mock.instance_persistence_bucket
    index_instance = bucket.create_index( :index ) do |object|
      object.some_value
    end
    Proc.new { index_instance.adapter_index }.should raise_error
    bucket.index( :index ).should == index_instance

    # after port is open
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    index_instance_two = bucket.create_index_with_duplicates( :other_index ) do |object|
      object.some_other_value
    end
    index_instance_two.adapter_index.should_not == nil
    bucket.index( :other_index ).should == index_instance_two
    
    instance = ::Persistence::Port::Bucket::BucketIndex::Mock.new
    instance.some_value = :a_value

    bucket.put_object!( instance )
    bucket.index( :index ).index_object( instance )
    bucket.count.should == 1
    bucket.index( :index ).count.should == 1
    bucket.index( :other_index ).count.should == 0
    
    ::Persistence.disable_port( :mock )

  end

end
