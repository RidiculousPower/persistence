
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Port::Bucket::BucketIndex do

  after(:each) do
    ::Persistence.disable_port( :mock )
  end

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

  end

  ##################
  #  create_index  #
  #  has_index?    #
  #  count         #
  #  index         #
  ##################

  context "#has_index?" do
    it "should have a spec. If this is still relevant..."
  end

  context '#create_index' do
    #can create an index and then separately retrieve that index
    before :each do
      class ::Persistence::Port::Bucket::BucketIndex::Mock
        include ::Persistence::Object
        attr_atomic_accessor :some_value, :some_other_value
      end
      @bucket = ::Persistence::Port::Bucket::BucketIndex::Mock.instance_persistence_bucket
      @index_instance = @bucket.create_index( :index ) do |object|
        object.some_value
      end
    end

    it "should return a copy of the new index" do
      @bucket.index( :index ).should == @index_instance
    end

    context "- before port is open -" do
      it "should raise error if index is referenced" do
        Proc.new { @index_instance.adapter_index }.should raise_error
      end
    end

    context "- after port is open -" do
      before :each do
        ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
        @instance = ::Persistence::Port::Bucket::BucketIndex::Mock.new
        @instance.some_value = :a_value
        @bucket.put_object!( @instance )
      end

      context "#index_object" do
        it "should index the object, #count should increment by 1" do
          @bucket.index( :index ).index_object( @instance )
          @bucket.count.should == 1
        end

        it "should index the object, #count(:index) should increment by 1" do
          @bucket.index( :index ).index_object( @instance )
          @bucket.index( :index ).count.should == 1
        end
      end
      context "#count" do
        it "should be 0 when no object have been added to the index" do
          @bucket.create_index( :other_index ) do |object|
            object.some_value
          end
          @bucket.index( :other_index ).count.should == 0
        end
      end
    end
  end

  context "#create_index_with_duplicates" do
    before :each do
      class ::Persistence::Port::Bucket::BucketIndex::Mock
        include ::Persistence::Object
        attr_atomic_accessor :some_value, :some_other_value
      end
      @bucket = ::Persistence::Port::Bucket::BucketIndex::Mock.instance_persistence_bucket
      @index_with_duplicates_instance = @bucket.create_index_with_duplicates( :index_with_duplicate ) do |object|
        object.some_other_value
      end
    end

    it "should return a copy of the new index" do
      @bucket.index( :index_with_duplicate ).should == @index_with_duplicates_instance
    end

    context "- after port is open -" do
      it "should create an index" do
        ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
        @index_with_duplicates_instance.adapter_index.should_not == nil
      end
    end

  end

end
