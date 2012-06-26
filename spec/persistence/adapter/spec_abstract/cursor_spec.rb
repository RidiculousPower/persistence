
require_relative '../../../../lib/persistence.rb'

require_relative '../mock_helpers.rb'

describe ::Persistence::Adapter do
  
  before :all do

    @adapter = $__persistence__spec__adapter__ || ::Persistence::Adapter::Mock.new( '/tmp/persistence_home' )

    ::Persistence.enable_port( :mock, @adapter )

    class ::Persistence::Adapter::MockCursorObject
      include ::Persistence
      attr_non_atomic_accessor :attribute
      attr_index :attribute
    end
    
    @bucket = ::Persistence::Adapter::MockCursorObject.instance_persistence_bucket.adapter_bucket
    @index = @bucket.index( :attribute )

    @objects = [ ]
    ::Persistence::Adapter::Abstract::Mock::Object.instance_persistence_bucket = @bucket
    5.times do |this_number|
      this_attribute = 'Number ' << this_number.to_s
      unless instance = ::Persistence::Adapter::MockCursorObject.persist( :attribute, this_attribute )
        instance = ::Persistence::Adapter::MockCursorObject.new
        instance.attribute = this_attribute
        instance.persist!
      end
      @objects[ this_number ] = instance
    end    

  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  ################
  #  first       #
  #  get_key     #
  #  persisted?  #
  #  current     #
  #  next        #
  ################

  it 'it can return an object ID for persistence ID' do
    
    # persistence id
    bucket_cursor = @bucket.cursor
    
    if bucket_cursor.supports_bucket_order?
    
      bucket_cursor.first.should == @objects[ 0 ].persistence_id

      bucket_cursor.persisted?( @objects[ 0 ].persistence_id ).should == true
      bucket_cursor.current.should == @objects[ 0 ].persistence_id

      bucket_cursor.persisted?( @objects[ 3 ].persistence_id ).should == true
      bucket_cursor.persisted?( @objects[ 2 ].persistence_id ).should == true
      
    else
      
      begin
        has_object = false
        while this_object_id = bucket_cursor.next
          @objects.each do |this_object|
            break if has_object = ( this_object.persistence_id == this_object_id )
          end
          has_object.should == true
        end
      rescue ::StopIteration
      end
      
    end
    
    bucket_cursor.close

  end
  
  it 'it can return an object ID for key' do
    
    # index
    index_cursor = @index.cursor
    
    if index_cursor.supports_index_order?
      
      index_cursor.first.should == @objects[ 0 ].persistence_id

      index_cursor.persisted?( @objects[ 0 ].attribute ).should == true
      index_cursor.current.should == @objects[ 0 ].persistence_id

      index_cursor.persisted?( @objects[ 1 ].attribute ).should == true

    else
      
      begin
        has_object = false
        while this_object_id = index_cursor.next
          @objects.each do |this_object|
            break if has_object = ( this_object.persistence_id == this_object_id )
          end
          has_object.should == true
        end
      rescue ::StopIteration
      end
      
    end
    
    index_cursor.close
    
  end

end
