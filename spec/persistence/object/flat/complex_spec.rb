
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe Complex do
  
  before :all do
    class Complex
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end

  it_behaves_like "a flat object with Persistence" do
    let(:object) { Complex( 42, 1 ) }
    let(:storage_key) { Complex( 37, 12 ) }
  end
  
end
