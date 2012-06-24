
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat do
  
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
    class ::Persistence::Object::Flat::Mock < ::String
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
      block_index :first_letter do
        chars.first
      end
    end
    instance = ::Persistence::Object::Flat::Mock.new
    instance.persist!
    instance.persistence_id.should_not == nil
    ::Persistence::Object::Flat::Mock.persisted?( instance.persistence_id ).should == true
    ::Persistence::Object::Flat::Mock.persist( instance.persistence_id ).should == instance
    instance_two = ::Persistence::Object::Flat::Mock.new( 'test' )
    instance_two.persist!( :explicit_index => :some_value )
    instance_two.persistence_id.should_not == nil
    ::Persistence::Object::Flat::Mock.persist( :explicit_index, :some_value ).should == instance_two
    ::Persistence::Object::Flat::Mock.persist( :first_letter => 't' ).should == instance_two
  end
    
end
