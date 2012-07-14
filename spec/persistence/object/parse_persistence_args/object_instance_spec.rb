
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::ParsePersistenceArgs::ObjectInstance do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    class ::Persistence::Object::ParsePersistenceArgs::ObjectInstance::Mock
      include ::Persistence::Object::Flat::File
      explicit_index :index
    end
    class SubFile < File
      include ::Persistence::Object::Flat::File
    end
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ######################
  #  process_file_key  #
  ######################
  
  it 'can process a file key for flat persistence' do
    file_instance = ::SubFile.open( __FILE__ )
    instance = ::Persistence::Object::ParsePersistenceArgs::ObjectInstance::Mock.new
    instance.persistence_port.persist_files_by_path!
    instance.process_file_key( file_instance ).should == file_instance.path
    instance.persistence_port.persists_files_by_content!
    instance.process_file_key( file_instance ).should == file_instance.readlines.join
  end
  
  ################################################
  #  parse_object_args_for_index_value_no_value  #
  ################################################
  
  it 'can parse args for indexed or non-indexed processing' do
    instance = ::Persistence::Object::ParsePersistenceArgs::ObjectInstance::Mock.new
    lambda { instance.parse_object_args_for_index_value_no_value( [], true ) }.should raise_error( ::Persistence::Exception::KeyValueRequired )
    # 0 args
    args = []
    instance.parse_object_args_for_index_value_no_value( args ).should == [ nil, nil, true ]
    # 1 arg: index
    args = [ :index ]
    instance.parse_object_args_for_index_value_no_value( args ).should == [ ::Persistence::Object::ParsePersistenceArgs::ObjectInstance::Mock.index( :index ), nil, true ]
    # 2 args: index, key
    args = [ :index, :key ]
    instance.parse_object_args_for_index_value_no_value( args ).should == [ ::Persistence::Object::ParsePersistenceArgs::ObjectInstance::Mock.index( :index ), :key, false ]
    # 2 args: no index, global id
    args = [ nil, 0 ]
    instance.parse_object_args_for_index_value_no_value( args ).should == [ nil, 0, false ]    
    # test special case: file key
    file_instance = ::SubFile.open( __FILE__ )
    args = [ :index, file_instance ]
    instance.persistence_port.persist_files_by_path!
    instance.parse_object_args_for_index_value_no_value( args ).should == [ ::Persistence::Object::ParsePersistenceArgs::ObjectInstance::Mock.index( :index ), ::Persistence::Object::Flat::File::Path.new( file_instance.path ), false ]
    instance.persistence_port.persists_files_by_content!
    instance.parse_object_args_for_index_value_no_value( args ).should == [ ::Persistence::Object::ParsePersistenceArgs::ObjectInstance::Mock.index( :index ), ::Persistence::Object::Flat::File::Contents.new( file_instance.readlines.join ), false ]
  end
  
end

