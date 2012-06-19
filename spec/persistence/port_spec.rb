
require_relative '../../lib/persistence.rb'

describe ::Persistence::Port do

  it 'integrates port modules into a class' do
    class ::Persistence::Port
      is_a?( ::Persistence::Port::AdapterInterface )
    end
  end
  
end
