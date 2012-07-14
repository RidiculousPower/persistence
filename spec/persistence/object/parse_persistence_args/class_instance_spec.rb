
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::ParsePersistenceArgs::ClassInstance do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
    class Object
      include ::Persistence::Object::Flat
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
    eigenclass = class << Class ; self ; end
    file_instance = ::SubFile.open( __FILE__ )
    instance = Object
    instance.persistence_port.persist_files_by_path!
    instance.process_file_key( file_instance ).should == file_instance.path
    instance.persistence_port.persists_files_by_content!
    instance.process_file_key( file_instance ).should == file_instance.readlines.join
  end
  
  ###############################################
  #  parse_class_args_for_index_value_no_value  #
  ###############################################
  
  it 'can parse args for indexed or non-indexed processing' do
    instance = Object
    lambda { instance.parse_class_args_for_index_value_no_value( [], true ) }.should raise_error( ::Persistence::Exception::KeyValueRequired )
    # 0 args
    args = []
    instance.parse_class_args_for_index_value_no_value( args ).should == [ nil, nil, true ]
    # 1 arg: index
    args = [ :index ]
    instance.parse_class_args_for_index_value_no_value( args ).should == [ ::Object.index( :index ), nil, true ]
    # 2 args: index, key
    args = [ :index, :key ]
    instance.parse_class_args_for_index_value_no_value( args ).should == [ ::Object.index( :index ), :key, false ]
    # 2 args: no index, global id
    args = [ nil, 0 ]
    instance.parse_class_args_for_index_value_no_value( args ).should == [ nil, 0, false ]    
    # test special case: file key
    file_instance = ::SubFile.open( __FILE__ )
    args = [ :index, file_instance ]
    instance.persistence_port.persist_files_by_path!
    instance.parse_class_args_for_index_value_no_value( args ).should == [ ::Object.index( :index ), ::Persistence::Object::Flat::File::Path.new( file_instance.path ), false ]
    instance.persistence_port.persists_files_by_content!
    instance.parse_class_args_for_index_value_no_value( args ).should == [ ::Object.index( :index ), ::Persistence::Object::Flat::File::Contents.new( file_instance.readlines.join ), false ]
  end
  
end

