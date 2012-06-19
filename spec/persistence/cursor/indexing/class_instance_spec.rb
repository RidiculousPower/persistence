
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Cursor::Indexing::ClassInstance do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end

    class ::Persistence::Cursor::Indexing::ClassInstance::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      extend ::Persistence::Cursor::ClassInstance
      extend ::Persistence::Cursor::Indexing::ClassInstance
      attr_non_atomic_accessor :name
      explicit_index :key
    end

    class ::Persistence::Cursor
      include ::Persistence::Cursor::Indexing::Cursor
    end
    
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
      include ::Persistence::Cursor::Port::Bucket
      include ::Persistence::Cursor::Indexing::Port::Bucket
    end

    class ::Persistence::Port::Indexing::Bucket::Index
      include ::Persistence::Cursor::Indexing::Port::Bucket::Index
    end

    @objects = [ ]
    @index = ::Persistence::Cursor::Indexing::ClassInstance::Mock.index( :key )
    5.times do |this_number|
      instance = ::Persistence::Cursor::Indexing::ClassInstance::Mock.new
      instance.name = 'Number ' << this_number.to_s
      instance.persist!
      @index.index_object( instance, instance.name )
      @index.get_object_id( instance.name ).should == instance.persistence_id
      @objects.push( instance )
    end

    @cursor = @index.cursor

  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  ###########
  #  count  #
  ###########

  it 'can count' do
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.instance_persistence_bucket.count.should == 5
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.instance_persistence_bucket.count do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.instance_persistence_bucket.count( @objects[ 2 ] ).should == 1

    ::Persistence::Cursor::Indexing::ClassInstance::Mock.count.should == 5
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.count do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.count( nil, @objects[ 2 ] ).should == 1

    ::Persistence::Cursor::Indexing::ClassInstance::Mock.index( :key ).count.should == 5
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.index( :key ).count do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.index( :key ).count( @objects[ 2 ] ).should == 1

    ::Persistence::Cursor::Indexing::ClassInstance::Mock.count( :key ).should == 5
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.count( :key ) do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::Indexing::ClassInstance::Mock.count( :key, @objects[ 2 ] ).should == 1
  end

end

