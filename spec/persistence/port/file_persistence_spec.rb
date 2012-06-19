
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Port::FilePersistence do

  ##############################
  #  persist_file_by_path      #
  #  persist_file_by_content   #
  #  persists_file_by_path?    #
  ##############################
  
  it 'can persist files either by path or contents' do
    
    # port instance
    class ::Persistence::Port::FilePersistence::PortMock
      include ::Persistence::Port::FilePersistence
      include ::Persistence::Port::FilePersistence::PortInstance
      def self.instance
        return @instance ||= ::Persistence::Port::FilePersistence::PortMock.new
      end
    end
    port_instance = ::Persistence::Port::FilePersistence::PortMock.instance
    port_instance.persists_file_by_path?.should == false
    port_instance.persist_file_by_path
    port_instance.persists_file_by_path?.should == true
    port_instance.persist_file_by_content
    port_instance.persists_file_by_path?.should == false
    
    # bucket instance
    ::Persistence::Port::FilePersistence::BucketMock = Class.new
    ::Persistence::Port::FilePersistence::BucketMock.module_eval do
      include ::Persistence::Port::FilePersistence
      include ::Persistence::Port::FilePersistence::BucketInstance
      def persistence_port
        return ::Persistence::Port::FilePersistence::PortMock.instance
      end
      def self.instance
        return @instance ||= ::Persistence::Port::FilePersistence::BucketMock.new
      end
    end
    bucket_instance = ::Persistence::Port::FilePersistence::BucketMock.instance
    bucket_instance.persists_file_by_path?.should == false
    port_instance.persist_file_by_path
    bucket_instance.persists_file_by_path?.should == true
    bucket_instance.persist_file_by_content
    bucket_instance.persists_file_by_path?.should == false
    port_instance.persist_file_by_path
    bucket_instance.persists_file_by_path?.should == false
    bucket_instance.persist_file_by_path
    port_instance.persist_file_by_content
    bucket_instance.persists_file_by_path?.should == true
    
    # reset internals for testing
    port_instance.persists_file_by_path = nil
    bucket_instance.persists_file_by_path = nil
    
    # class instance
    ::Persistence::Port::FilePersistence::ClassMock = Class.new
    ::Persistence::Port::FilePersistence::ClassMock.module_eval do
      include ::Persistence::Port::FilePersistence
      extend ::Persistence::Port::FilePersistence
      extend ::Persistence::Port::FilePersistence::ClassInstance
      def self.persistence_bucket
        return ::Persistence::Port::FilePersistence::BucketMock.instance
      end
      persists_file_by_path?.should == false
      port_instance.persist_file_by_path
      persists_file_by_path?.should == true
      bucket_instance.persist_file_by_content
      persists_file_by_path?.should == false
      port_instance.persist_file_by_path
      persists_file_by_path?.should == false
      persist_file_by_path
      persists_file_by_path?.should == true
      persist_file_by_content
      persists_file_by_path?.should == false
      bucket_instance.persists_file_by_path?.should == false
      port_instance.persists_file_by_path?.should == true
    end

    # reset internals for testing
    port_instance.persists_file_by_path = nil
    bucket_instance.persists_file_by_path = nil
    ::Persistence::Port::FilePersistence::ClassMock.persists_file_by_path = nil

    # object instance
    ::Persistence::Port::FilePersistence::ClassMock.new.instance_eval do
      persists_file_by_path?.should == false
      port_instance.persist_file_by_path
      persists_file_by_path?.should == true
      bucket_instance.persist_file_by_content
      persists_file_by_path?.should == false
      self.class.persist_file_by_path
      persists_file_by_path?.should == true
      self.class.persist_file_by_content
      persists_file_by_path?.should == false
      bucket_instance.persist_file_by_path
      persists_file_by_path?.should == false      
      port_instance.persist_file_by_path
      persists_file_by_path?.should == false
      persist_file_by_path
      persists_file_by_path?.should == true
      persist_file_by_content
      persists_file_by_path?.should == false
      self.class.persists_file_by_path?.should == false
      bucket_instance.persists_file_by_path?.should == true
      port_instance.persists_file_by_path?.should == true
    end
  end
  
end
