
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe Regexp do
  
  before :all do
    class ::Persistence::Object::Flat::RegexpMock < Regexp
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end

  it_behaves_like "a flat object with Persistence" do
    let(:object) { ::Persistence::Object::Flat::RegexpMock.new( /some_regexp_([A-Za-z])/ ) }
    let(:storage_key) { /regexp_storage_key/ }
  end
  
end
