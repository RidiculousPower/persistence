
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Port::Indexing::Bucket::Index do
  
  it 'is a module cluster' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Port::Indexing::Bucket::Index::Mock
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      attr_atomic_accessor :some_value, :some_other_value
    end

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    index = ::Persistence::Port::Indexing::Bucket::Index.new( :index, ::Persistence::Port::Indexing::Bucket::Index::Mock.instance_persistence_bucket, false )
    index.instance_eval do
      is_a?( ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex ).should == true
      is_a?( ::Persistence::Port::Indexing::Bucket::Index::ObjectOrientedIndex ).should == false
      is_a?( ::Persistence::Port::Indexing::Bucket::Index::BlockIndex ).should == false
      is_a?( ::Persistence::Port::Indexing::Bucket::Index::AttributeIndex ).should == false
      is_a?( ::Persistence::Port::Indexing::Bucket::Index::BucketIndex ).should == false
    end
    
    object = ::Persistence::Port::Indexing::Bucket::Index::Mock.new
    object.some_value = :a_value
    indexing_proc = Proc.new do |object|
      object.some_value
    end
    index.extend( ::Persistence::Port::Indexing::Bucket::Index::BucketIndex )
    index.indexing_procs.push( indexing_proc )
    
    index.count.should == 0
    index.index_object( object )
    index.count.should == 1

    ::Persistence.disable_port( :mock )

  end
  
end
