if $__rpersistence__spec__development
  require_relative '../../../lib/rpersistence.rb'
else
  require 'rpersistence'
end

describe Rpersistence::Adapter::Mock do
  
  $__rpersistence__spec__adapter_test_class__       = Rpersistence::Adapter::Mock
  $__rpersistence__spec__adapter_home_directory__   = "not required"
  
  # adapter spec
  require Rpersistence::Adapter.spec_location
  
end
