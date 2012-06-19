
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Cursor::Indexing::Cursor do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end

    class ::Persistence::Cursor::Indexing::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
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
    @index = ::Persistence::Cursor::Indexing::Mock.index( :key )
    5.times do |this_number|
      instance = ::Persistence::Cursor::Indexing::Mock.new
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

  ################
  #  persisted?  #
  ################

  it 'can report whether a key exists and set its position to the key if it does' do
    @cursor.persisted?( @objects[ 0 ].name ).should == true
  end

  ###########
  #  first  #
  ###########
  
  it 'can set its position to the first key' do
    @cursor.first.should == @objects.first
    @cursor.first( 2 ).should == @objects.first( 2 )
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
  end

end

