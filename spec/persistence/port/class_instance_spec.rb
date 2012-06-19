
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Port::ClassInstance do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  ################################
  #  instance_persistence_port=  #
  #  instance_persistence_port   #
  #  store_using                 #
  #  persists_using              #
  ################################

  it 'can set and return a persistence port to be used for instances' do
    class ::Persistence::Port::ClassInstance::Mock
      extend ::Persistence::Port::ClassInstance
      extend ::Persistence::Port::Bucket::ClassInstance
      method( :instance_persistence_port= ).should == method( :store_using )
      method( :instance_persistence_port= ).should == method( :persists_using )
      mock_port = ::Persistence.port( :mock )
      self.instance_persistence_port = mock_port
      instance_persistence_port.should == mock_port
      self.instance_persistence_port = nil
      ::Persistence.disable_port( :mock )
      instance_persistence_port.should == nil
      self.instance_persistence_port = nil
      instance_persistence_port.should == nil
      self.instance_persistence_port = :mock
      instance_persistence_port.should == mock_port
    end
  end
  
end
