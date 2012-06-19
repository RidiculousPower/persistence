
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Cursor::Atomic do

  before( :all ) do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Cursor::Atomic::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      attr_non_atomic_accessor :name
    end

    class ::Persistence::Port::Bucket
      include ::Persistence::Cursor::Port::Bucket
    end

    @objects = [ ]
    5.times do |this_number|
      instance = ::Persistence::Cursor::Atomic::Mock.new
      instance.name = 'Number ' << this_number.to_s
      instance.persist!
      @objects.push( instance )
    end    

    @cursor = ::Persistence::Cursor::Atomic::Mock.instance_persistence_bucket.atomic_cursor
    
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ################
  #  persisted?  #
  ################

  it 'can report whether a key exists and set its position to the key if it does' do
    @cursor.persisted?( @objects[ 0 ].persistence_id ).should == true
  end

  ###########
  #  first  #
  ###########
  
  it 'can set its position to the first key' do
    @cursor.first.should == @objects.first
    @cursor.first.instance_variables.empty?.should == true
    @cursor.first( 2 ).should == @objects.first( 2 )
  end

  #############
  #  current  #
  #############
  
  it 'can return the current key' do
    @cursor.first
    @cursor.current.should == @objects.first
    @cursor.current.instance_variables.empty?.should == true
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
