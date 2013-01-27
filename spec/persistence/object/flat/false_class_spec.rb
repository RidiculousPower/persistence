
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe FalseClass do
  
  before :all do
    class FalseClass
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end

  it_behaves_like "a flat object with Persistence" do
    let(:object) { false }
    let(:storage_key) { true }
  end
  
end
