
require_relative '../../../../lib/persistence.rb'

require_relative '../mock_helpers.rb'

describe ::Persistence::Adapter::Mock::Cursor do

  before :all do

    adapter = ::Persistence::Adapter::Mock.new

    @objects = [ ]
    @bucket = adapter.persistence_bucket( ::Persistence::Adapter::Abstract::Mock::Object.to_s )
    ::Persistence::Adapter::Abstract::Mock::Object.instance_persistence_bucket = @bucket
    @index = @bucket.create_index( :name, false )
    5.times do |this_number|
      instance = ::Persistence::Adapter::Abstract::Mock::Object.new
      instance.name = 'Number ' << this_number.to_s
      @bucket.put_object!( instance )
      @bucket.index( :name ).index_object_id( instance.persistence_id, instance.name )
      @objects.push( instance )
    end    

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
    bucket_cursor.first.should == 0
    bucket_cursor.persisted?( 1 ).should == true
    bucket_cursor.current.should == 1
    bucket_cursor.next.should == 2
    bucket_cursor.next.should == 3
    bucket_cursor.next.should == 4
    bucket_cursor.persisted?( 3 ).should == true
    bucket_cursor.persisted?( 2 ).should == true
    
  end

  it 'it can return an object ID for key' do
    
    # index
    index_cursor = @index.cursor
    index_cursor.first.should == 0
    index_cursor.persisted?( "Number 1" ).should == true
    index_cursor.current_key.should == "Number 1"
    index_cursor.current.should == 1
    index_cursor.next_key.should == "Number 2"
    index_cursor.next.should == 3
    index_cursor.persisted?( "Number 2" ).should == true
    index_cursor.next.should == 3
    
  end

end
