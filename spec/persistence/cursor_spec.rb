
require_relative '../../lib/persistence.rb'

describe ::Persistence::Cursor do

  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class ::Persistence::Cursor::Mock
      include ::Persistence
      attr_non_atomic_accessor :name
      explicit_index :key
    end

    #None of these test do assignments, before :all will work just as well as before :each.

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

    @normal_cursor = ::Persistence::Cursor::Mock.instance_persistence_bucket.cursor
    @index_cursor = @index.cursor

  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  before :each do
    @objects.first
    @normal_cursor.first
    @index_cursor.first
  end


  cursors = [:normal_cursor, :index_cursor]

  ################
  #  persisted?  #
  ################
  context "#persisted?" do
    it "with persistence_id should a return true if the object is in the normal cursor" do
      @normal_cursor.persisted?( @objects[ 0 ].persistence_id ).should == true
    end

    it "with object name should a return true if the object is in the index cursor" do
      @index_cursor.persisted?( @objects[ 0 ].name ).should == true
    end
  end

  #########
  #  any  #
  #########
  context "#any" do
    it "should return a object in the cursor" do
      @objects.include?( @normal_cursor.any ).should == true
    end

    it "with 2 should return two objects in the cursor" do
      @normal_cursor.any( 2 ).each do |this_object|
        @objects.include?( this_object ).should == true
      end
    end

    it "should return a random value"

  end

  #################
  #  first, last  #
  #################
  [:first, :last].each do |method|
    context "##{method}" do
      cursors.each do |object|
        let(:var) { instance_variable_get("@#{object}")}
        context "with #{ object }" do
          it "should return the #{method} object" do
            var.send(method).should == @objects.send(method)
          end

          it "should return the #{method} 2 object" do
            var.send(method, 2 ).should == @objects.send(method, 2 )
          end
        end
      end
    end
  end

  ##########
  #  next  #
  ##########
  context "#next" do
    #can set its position to the next key
    cursors.each do |object|
      context "- #{ object } -" do
        let(:var) { instance_variable_get("@#{object}") }

        it "first call should return the 0th object" do
          var.next.should == @objects.first
        end

        it "should return the next object in the sequence" do
          5.times do |index|
            var.next.should == @objects[index]
          end
        end

        it "first call with numeric argument should return the next number of objects in the sequence equal to the numeric argument" do
          5.times do |index|
            var.first
            var.next( index ).should == @objects[ 0..index-1 ] if index > 1 # next of 0 or 1 is not an array
          end
        end

        it "with the argument of 1 should return the next object in the sequence" do
          var.next( 1 ).should == @objects.first
        end

        it "with the argument of 0 should return nil" do
          var.next( 0 ).should == nil
        end

        it "with the argument of -1 should be treated as an absolute value and return the next object in the sequence" do
          var.next( -1 ).should == @objects.first
        end

      end
    end
  end

  #############
  #  current  #
  #############
  context "#current" do
    it 'should return the current key' do
      @normal_cursor.current.should == @objects.first
    end

    it 'should return the current key' do
      @normal_cursor.next(2)
      @normal_cursor.current.should == @objects[1]
    end
  end

  ##########
  #  each  #
  ##########
  context "#each" do
    #can iterate each record
    cursors.each do |object|
      context "- #{ object } -" do

        let(:enum) {instance_variable_get("@#{object}").each}

        it "should return an enumerator" do
          enum.is_a?( Enumerator ).should == true
        end

        context "returned enumerator" do
          it "with next should return the first object" do
            enum.next.should == @objects[ 0 ]
          end

          it "with next twice should return the second object" do
            enum.next
            enum.next.should == @objects[ 1 ]
          end
        end
      end
    end
  end

  context "#each_with_index" do
    #can iterate each record
    cursors.each do |object|
      context "- #{ object } -" do
        it "should return each object and index key pair" do
          instance_variable_get("@#{object}").each_with_index do |this_object, this_index|
            this_object.should == @objects[ this_index ]
          end
        end
      end
    end
  end

end
