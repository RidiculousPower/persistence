
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe Fixnum do
  
  before :all do
    class Fixnum
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end
  
  it_behaves_like "a flat object with Persistence" do
    let(:object) { 420 }
    let(:storage_key) { 12 }
  end

end
