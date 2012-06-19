
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat::Indexing do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )  
  end
  
  after :all do
    ::Persistence.disable_port( :mock )  
  end
  
  #############
  #  persist  #
  #############
  
  it 'can persist a flat object and test whether it has been persisted' do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class ::Persistence::Object::Flat::Indexing::Mock < ::String
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Flat::Indexing::ClassInstance
      include ::Persistence::Object::Flat::Indexing::ObjectInstance
      explicit_index :explicit_index
      block_index :first_letter do
        chars.first
      end
    end
    instance = ::Persistence::Object::Flat::Indexing::Mock.new
    instance.persist!
    instance.persistence_id.should_not == nil
    ::Persistence::Object::Flat::Indexing::Mock.persisted?( instance.persistence_id ).should == true
    ::Persistence::Object::Flat::Indexing::Mock.persist( instance.persistence_id ).should == instance
    instance_two = ::Persistence::Object::Flat::Indexing::Mock.new( 'test' )
    instance_two.persist!( :explicit_index => :some_value )
    instance_two.persistence_id.should_not == nil
    ::Persistence::Object::Flat::Indexing::Mock.persist( :explicit_index => :some_value ).should == instance_two
    ::Persistence::Object::Flat::Indexing::Mock.persist( :first_letter => 't' ).should == instance_two
  end
    
end
