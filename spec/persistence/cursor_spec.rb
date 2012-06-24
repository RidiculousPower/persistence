
require_relative '../../lib/persistence.rb'

describe ::Persistence::Cursor do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Cursor::Mock
      include ::Persistence
      attr_non_atomic_accessor :name
      explicit_index :key
    end

    @objects = [ ]
    @index = ::Persistence::Cursor::Mock.index( :key )
    5.times do |this_number|
      instance = ::Persistence::Cursor::Mock.new
      instance.name = 'Number ' << this_number.to_s
      instance.persist!
      @index.index_object( instance, instance.name )
      @index.get_object_id( instance.name ).should == instance.persistence_id
      @objects.push( instance )
    end

    @cursor = ::Persistence::Cursor::Mock.instance_persistence_bucket.cursor
    @index_cursor = @index.cursor

  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  ################
  #  persisted?  #
  ################

  it 'can report whether a key exists and set its position to the key if it does' do
    @cursor.persisted?( @objects[ 0 ].persistence_id ).should == true
    @index_cursor.persisted?( @objects[ 0 ].name ).should == true
  end
  
  ###########
  #  first  #
  ###########
  
  it 'can set its position to the first key' do
    @cursor.first.should == @objects.first
    @cursor.first( 2 ).should == @objects.first( 2 )
    @index_cursor.first.should == @objects.first
    @index_cursor.first( 2 ).should == @objects.first( 2 )
  end

  ##########
  #  last  #
  ##########
  
  it 'can set its position to the last key' do
    @cursor.last.should == @objects.last
    @cursor.last( 2 ).should == @objects.last( 2 )
    @index_cursor.first
    @index_cursor.current.should == @objects.first
  end

  #########
  #  any  #
  #########
  
  it 'can set its position to the last key' do
    @objects.include?( @cursor.any ).should == true
    @cursor.any( 2 ).each do |this_object|
      @objects.include?( this_object ).should == true
    end
    @index_cursor.first.should == @objects[ 0 ]
    @index_cursor.next.should == @objects[ 0 ]
    @index_cursor.next.should == @objects[ 1 ]
    @index_cursor.next( 2 ).should == @objects[ 2..3 ]
  end

  #############
  #  current  #
  #############
  
  it 'can return the current key' do
    @cursor.first
    @cursor.current.should == @objects.first
  end

  ##########
  #  next  #
  ##########
  
  it 'can set its position to the next key' do
    @cursor.first.should == @objects[ 0 ]
    @cursor.next.should == @objects[ 0 ]
    @cursor.next.should == @objects[ 1 ]
    @cursor.next( 2 ).should == @objects[ 2..3 ]
  end

  ##########
  #  each  #
  ##########

  it 'can iterate each record' do
    @cursor.first
    @cursor.each_with_index do |this_object, this_index|
      this_object.should == @objects[ this_index ]
    end
    @cursor.first
    enum = @cursor.each
    enum.is_a?( Enumerator ).should == true
    enum.next.should == @objects[ 0 ]
    enum.next.should == @objects[ 1 ]
    @index_cursor.first
    @index_cursor.each_with_index do |this_object, this_index|
      this_object.should == @objects[ this_index ]
    end
    @index_cursor.first
    enum = @index_cursor.each
    enum.is_a?( Enumerator ).should == true
    enum.next.should == @objects[ 0 ]
    enum.next.should == @objects[ 1 ]
  end

end

