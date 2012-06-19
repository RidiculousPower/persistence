
require 'module-cluster'
require 'cascading-configuration'

if $__persistence__spec__development__
  require_relative '../port/indexing/lib/persistence-port-indexing.rb'
  require_relative '../cursor/indexing/lib/persistence-cursor-indexing.rb'
  require_relative '../object/flat/indexing/lib/persistence-object-flat-indexing.rb'
  require_relative '../object/complex/indexing/lib/persistence-object-complex-indexing.rb'
  require_relative '../adapters/mock/lib/persistence-adapter-mock.rb'
else
  require 'persistence-port-indexing'
  require 'persistence-cursor-indexing'
  require 'persistence-object-flat-indexing'
  require 'persistence-object-complex-indexing'
  require 'persistence-adapter-mock'
end

module ::Persistence
  module Complex
  end
  module Flat
  end
end

require_relative 'persistence/Persistence/Complex.rb'
require_relative 'persistence/Persistence/Flat.rb'

require_relative 'persistence/Persistence.rb'

class ::Persistence::Cursor
  include ::Persistence::Cursor::Indexing::Port::Bucket  
end

class ::Persistence::Port::Bucket
  include ::Persistence::Port::Indexing::Bucket  
  include ::Persistence::Cursor::Indexing::Port::Bucket  
end

class ::Persistence::Port::Bucket::Index
  include ::Persistence::Cursor::Indexing::Port::Bucket::Index  
end


