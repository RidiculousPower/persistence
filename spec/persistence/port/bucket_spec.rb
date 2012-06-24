
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Port::Bucket do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it 'is a module cluster' do
    ::Persistence::Port::Bucket.new( :mock, :some_bucket ).instance_eval do
      is_a?( ::Persistence::Port::Bucket::BucketInterface ).should == true
    end
  end
  
end
