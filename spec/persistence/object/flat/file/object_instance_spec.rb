
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat::File::ObjectInstance do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )  
  end
  
  after :all do
    ::Persistence.disable_port( :mock )  
  end

  ##############
  #  persist!  #
  ##############
  
  it 'can persist a flat object and test whether it has been persisted' do
    class ::Persistence::Object::Flat::File::ObjectInstance::FileMock < File
      include ::Persistence::Object::Flat::File
    end
    class ::Persistence::Object::Flat::File::Contents
      include ::Persistence::Object::Flat
    end
    class ::Persistence::Object::Flat::File::Path
      include ::Persistence::Object::Flat
    end
    
    ::Persistence::Object::Flat::File::ObjectInstance::FileMock.instance_persistence_port = :mock
    instance = ::Persistence::Object::Flat::File::ObjectInstance::FileMock.open( __FILE__, 'r' )

    # by content
    instance.persists_files_by_content?.should == false
    instance.persist_files_by_content!
    instance.persists_files_by_content?.should == true
    instance.persists_files_by_path?.should == false
    instance.persist!
    instance.persistence_id.should_not == nil
    instance.persistence_port.get_flat_object( instance.persistence_id ).should == instance.readlines.join
    instance.cease!

    # by path
    instance.persistence_id = nil
    instance.persist_files_by_path!
    instance.persist!
    instance.persistence_id.should_not == nil
    instance.persistence_port.get_flat_object( instance.persistence_id ).should == instance.path
  end

  ###############################
  #  persist_files_by_path      #
  #  persists_files_by_content  #
  #  persists_files_by_path?    #
  ###############################
  
  it 'can persist files either by path or contents' do
    module ::Persistence::Object::Flat::File::ObjectInstance::PersistFileByPathMock
      
      class FileMock < ::File
        include ::Persistence::Object::Flat::File
      end
      
      # Controller
      ::Persistence.persists_files_by_path?.should == true
      ::Persistence.persist_files_by_content!
      ::Persistence.persists_files_by_path?.should == false
      ::Persistence.persists_files_by_content?.should == true
      ::Persistence.persist_files_by_path!
      ::Persistence.persists_files_by_path?.should == true
      ::Persistence.persists_files_by_content?.should == false
      
      # Port
      port_instance = FileMock.instance_persistence_port
      port_instance.persists_files_by_path?.should == true
      port_instance.persist_files_by_content!
      port_instance.persists_files_by_path?.should == false
      port_instance.persists_files_by_content?.should == true
      port_instance.persist_files_by_path!
      port_instance.persists_files_by_path?.should == true
      port_instance.persists_files_by_content?.should == false
      port_instance.persist_files_by_content!
      
      # Bucket
      bucket_instance = FileMock.instance_persistence_bucket
      bucket_instance.persists_files_by_path?.should == false
      port_instance.persist_files_by_path!
      bucket_instance.persists_files_by_path?.should == true
      bucket_instance.persists_files_by_content!
      bucket_instance.persists_files_by_path?.should == false
      port_instance.persist_files_by_path!
      bucket_instance.persists_files_by_path?.should == false
      bucket_instance.persist_files_by_path!
      port_instance.persists_files_by_content!
      bucket_instance.persists_files_by_path?.should == true
      bucket_instance.persists_files_by_content!
      port_instance.persist_files_by_path!
      
      # Class
      FileMock.class_eval do
        persists_files_by_path?.should == false
        bucket_instance.persist_files_by_path!
        persists_files_by_path?.should == true
        bucket_instance.persist_files_by_content!
        persists_files_by_path?.should == false
        port_instance.persist_files_by_path!
        persists_files_by_path?.should == false
        persist_files_by_path!
        persists_files_by_path?.should == true
        persists_files_by_content!
        persists_files_by_path?.should == false
        bucket_instance.persists_files_by_path?.should == false
        port_instance.persists_files_by_path?.should == true
      end
      
      # Instance
      FileMock.new( __FILE__ ).instance_eval do
        persists_files_by_path?.should == false
        self.class.persist_files_by_path!
        persists_files_by_path?.should == true
        bucket_instance.persist_files_by_content!
        persists_files_by_path?.should == true
        self.class.persist_files_by_path!
        persists_files_by_path?.should == true
        self.class.persists_files_by_content!
        persists_files_by_path?.should == false
        bucket_instance.persist_files_by_path!
        persists_files_by_path?.should == false      
        port_instance.persist_files_by_path!
        persists_files_by_path?.should == false
        persist_files_by_path!
        persists_files_by_path?.should == true
        persists_files_by_content!
        persists_files_by_path?.should == false
        self.class.persists_files_by_path?.should == false
        bucket_instance.persists_files_by_path?.should == true
        port_instance.persists_files_by_path?.should == true
      end
      
    end

  end
    
end
