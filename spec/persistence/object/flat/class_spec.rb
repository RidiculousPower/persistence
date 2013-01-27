
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe Class do
  
  before :all do
    class Class
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end

  it_behaves_like "a flat object with Persistence" do
    let(:object) { Object }
    let(:storage_key) { String }
  end
  
end
