
require_relative '../../../../lib/persistence.rb'
require_relative './flat_rspec_helpers.rb'

describe Rational do
  
  before :all do
    class Rational
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
  end

  it_behaves_like "a flat object with Persistence" do
    let(:object) { Rational( 42, 37 ) }
    let(:storage_key) { Rational( 42, 420 ) }
  end
  
end
