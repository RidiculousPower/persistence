
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe Symbol do
  
  before :all do
    class Symbol
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end

  it_behaves_like "a flat object with Persistence" do
    let(:object) { :symbol }
    let(:storage_key) { :symbol_storage_key }
  end

end
