$__persistence__spec__development__ = true
if $__persistence__spec__development__
  require_relative '../../../../../lib/persistence-object-indexing.rb'
  require_relative '../../../../../../../port/indexing/lib/persistence-port-indexing.rb'
  require_relative '../../../../../../../adapters/mock/lib/persistence-adapter-mock.rb'
else
  require 'persistence-object-indexing'
  require 'persistence-port-indexing'
  require 'persistence-adapter-mock'
end

describe ::Persistence::Object::Indexing::ParsePersistenceArgs do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    class ::Persistence::Object::Indexing::ParsePersistenceArgs::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Indexing::Indexes
      extend ::Persistence::Object::Indexing::Indexes
      include ::Persistence::Object::Indexing::Indexes::Explicit::ObjectInstance
      extend ::Persistence::Object::Indexing::Indexes::Explicit::ClassInstance
      include ::Persistence::Object::Indexing::ParsePersistenceArgs
      attr_accessor :indexes
      class IndexMock
      end
      def indexes
        return { :index => IndexMock }
      end
    end
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ######################
  #  process_file_key  #
  ######################
  
  it 'can process a file key for flat persistence' do
    file_instance = File.open( __FILE__ )
    instance = ::Persistence::Object::Indexing::ParsePersistenceArgs::Mock.new
    ::Persistence.port( :mock ).persist_file_by_path
    instance.process_file_key( file_instance ).should == file_instance.path
    ::Persistence.port( :mock ).persist_file_by_content
    instance.process_file_key( file_instance ).should == file_instance.readlines.join
  end
  
  #########################################
  #  parse_args_for_index_value_no_value  #
  #########################################
  
  it 'can parse args for indexed or non-indexed processing' do
    instance = ::Persistence::Object::Indexing::ParsePersistenceArgs::Mock.new
    lambda { instance.parse_args_for_index_value_no_value( [], true ) }.should raise_error( ::Persistence::Object::Indexing::Exceptions::KeyValueRequired )
    # 0 args
    args = []
    instance.parse_args_for_index_value_no_value( args ).should == [ nil, nil, true ]
    # 1 arg: index
    args = [ :index ]
    instance.parse_args_for_index_value_no_value( args ).should == [ ::Persistence::Object::Indexing::ParsePersistenceArgs::Mock::IndexMock, nil, true ]
    # 2 args: index, key
    args = [ :index, :key ]
    instance.parse_args_for_index_value_no_value( args ).should == [ ::Persistence::Object::Indexing::ParsePersistenceArgs::Mock::IndexMock, :key, false ]
    # 2 args: no index, global id
    args = [ nil, 0 ]
    instance.parse_args_for_index_value_no_value( args ).should == [ nil, 0, false ]    
    # test special case: file key
    file_instance = File.open( __FILE__ )
    args = [ :index, file_instance ]
    ::Persistence.port( :mock ).persist_file_by_path
    instance.parse_args_for_index_value_no_value( args ).should == [ ::Persistence::Object::Indexing::ParsePersistenceArgs::Mock::IndexMock, ::Persistence::Object::Flat::File::Path.new( file_instance.path ), false ]
    ::Persistence.port( :mock ).persist_file_by_content
    instance.parse_args_for_index_value_no_value( args ).should == [ ::Persistence::Object::Indexing::ParsePersistenceArgs::Mock::IndexMock, ::Persistence::Object::Flat::File::Contents.new( file_instance.readlines.join ), false ]
  end
  
end

