
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe ::Persistence::Object::Flat do
  
  before :all do
    class String
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end
  
  it_behaves_like "a flat object with Persistence" do
    let(:object) { "some string" }
    let(:storage_key) { "string storage key" }
  end
  
end
