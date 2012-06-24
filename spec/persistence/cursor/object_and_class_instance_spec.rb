
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Cursor do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Cursor::ClassInstanceMock
      include ::Persistence
      attr_non_atomic_accessor :name
      explicit_index :key
    end

    @objects = [ ]
    @index = ::Persistence::Cursor::ClassInstanceMock.index( :key )
    5.times do |this_number|
      instance = ::Persistence::Cursor::ClassInstanceMock.new
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
    ::Persistence::Cursor::ClassInstanceMock.instance_persistence_bucket.count.should == 5
    ::Persistence::Cursor::ClassInstanceMock.instance_persistence_bucket.count do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::ClassInstanceMock.instance_persistence_bucket.count( @objects[ 2 ] ).should == 1

    ::Persistence::Cursor::ClassInstanceMock.count.should == 5
    ::Persistence::Cursor::ClassInstanceMock.count do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::ClassInstanceMock.count( nil, @objects[ 2 ] ).should == 1
  end

  ###########
  #  count  #
  ###########

  it 'can count' do

    ::Persistence::Cursor::ClassInstanceMock.index( :key ).count.should == 5
    ::Persistence::Cursor::ClassInstanceMock.index( :key ).count do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::ClassInstanceMock.index( :key ).count( @objects[ 2 ] ).should == 1

    ::Persistence::Cursor::ClassInstanceMock.count( :key ).should == 5
    ::Persistence::Cursor::ClassInstanceMock.count( :key ) do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::ClassInstanceMock.count( :key, @objects[ 2 ] ).should == 1
  end

end

