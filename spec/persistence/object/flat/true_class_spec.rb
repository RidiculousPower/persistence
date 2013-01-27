
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe TrueClass do
  
  before :all do
    class TrueClass
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end

  it_behaves_like "a flat object with Persistence" do
    let(:object) { true }
    let(:storage_key) { false }
  end
  
end
