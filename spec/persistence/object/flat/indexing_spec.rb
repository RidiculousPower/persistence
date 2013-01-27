
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe ::Persistence::Object::Flat do
  
  before :all do
    class ::Persistence::Object::Flat::Mock < ::String
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
      block_index :first_letter do
        chars.first
      end
    end
  end
  
  it_behaves_like "a flat object with Persistence" do
    let(:object) { ::Persistence::Object::Flat::Mock.new }
    let(:storage_key) { :some_value }
  end

  #############
  #  block_index  #
  #############
  context "block_index" do
    it 'should return instance given expected logic' do
      ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )  

      instance = ::Persistence::Object::Flat::Mock.new( 'test' )
      instance.persist!( :explicit_index => :some_value )
      ::Persistence::Object::Flat::Mock.persist( :first_letter => 't' ).should == instance

      ::Persistence.disable_port( :mock )  
    end
  end
    
end
