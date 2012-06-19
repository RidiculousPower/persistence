
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Port::Bucket::ClassInstance do
  
  ##################################
  #  instance_persistence_bucket   #
  #  instance_persistence_bucket=  #
  #  store_as                      #
  #  persists_in                   #
  ##################################

  it 'can set and return a persistence bucket to be used for instances' do
    class ::Persistence::Port::Bucket::ClassInstance::Mock
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::Bucket::ObjectInstance
      extend ::Persistence::Port::Bucket::ClassInstance
      method( :instance_persistence_bucket= ).should == method( :store_as )
      method( :instance_persistence_bucket= ).should == method( :persists_in )
      instance_persistence_bucket.name.to_s.should == ::Persistence::Port::Bucket::ClassInstance::Mock.to_s
      self.instance_persistence_bucket = 'some other bucket'
      instance_persistence_bucket.name.to_s.should == 'some other bucket'
    end
    ::Persistence::Port::Bucket::ClassInstance::Mock.instance_persistence_bucket = ::Persistence::Port::Bucket::ClassInstance::Mock.to_s
    ::Persistence::Port::Bucket::ClassInstance::Mock.instance_persistence_bucket.name.to_s.should == ::Persistence::Port::Bucket::ClassInstance::Mock.to_s
  end
  
end
