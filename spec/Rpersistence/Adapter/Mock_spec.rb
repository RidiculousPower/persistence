# development
require_relative '../../../lib/rpersistence.rb'
# mock adapter
require_relative 'Mock.rb'
require_relative 'Private/Mock.rb'
# adapter spec
require_relative 'Adapter_spec.rb'

describe Rpersistence::Adapter::Mock do
  
  $__rpersistence__spec__adapter_test_class__       = Rpersistence::Adapter::Mock
  $__rpersistence__spec__adapter_home_directory__   = "not required"
  
  require_relative 'Adapter_spec.rb'
  
end
