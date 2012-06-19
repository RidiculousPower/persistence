
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Cursor::ClassInstance do

  before( :all ) do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Cursor::ClassInstance::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::ObjectInstance
      extend ::Persistence::Object::Complex::ClassInstance
      extend ::Persistence::Cursor::ClassInstance
      attr_non_atomic_accessor :name
    end

    class ::Persistence::Port::Bucket
      include ::Persistence::Cursor::Port::Bucket
    end

    @objects = [ ]
    5.times do |this_number|
      instance = ::Persistence::Cursor::ClassInstance::Mock.new
      instance.name = 'Number ' << this_number.to_s
      instance.persist!
      @objects.push( instance )
    end    

    @cursor = ::Persistence::Cursor::ClassInstance::Mock.instance_persistence_bucket.atomic_cursor
    
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ###########
  #  count  #
  ###########

  it 'can count' do
    ::Persistence::Cursor::ClassInstance::Mock.instance_persistence_bucket.count.should == 5
    ::Persistence::Cursor::ClassInstance::Mock.instance_persistence_bucket.count do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::ClassInstance::Mock.instance_persistence_bucket.count( @objects[ 2 ] ).should == 1

    ::Persistence::Cursor::ClassInstance::Mock.count.should == 5
    ::Persistence::Cursor::ClassInstance::Mock.count do |object|
      object == @objects[ 2 ]
    end.should == 1
    ::Persistence::Cursor::ClassInstance::Mock.count( @objects[ 2 ] ).should == 1
  end

end
