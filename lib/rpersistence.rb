
require 'module-cluster'

if $__rpersistence__spec__development
  require_relative '../port/indexing/lib/rpersistence-port-indexing.rb'
  require_relative '../cursor/indexing/lib/rpersistence-cursor-indexing.rb'
  require_relative '../object/flat/indexing/lib/rpersistence-object-flat-indexing.rb'
  require_relative '../object/complex/indexing/lib/rpersistence-object-complex-indexing.rb'
else
  require 'rpersistence-port-indexing'
  require 'rpersistence-cursor-indexing'
  require 'rpersistence-object-flat-indexing'
  require 'rpersistence-object-complex-indexing'
end

module Rpersistence
  module Complex
  end
  module Flat
  end
end

require_relative 'rpersistence/Rpersistence/Complex.rb'
require_relative 'rpersistence/Rpersistence/Flat.rb'

require_relative 'rpersistence/Rpersistence.rb'

class Rpersistence::Cursor
  include Rpersistence::Cursor::Indexing::Port::Bucket  
end

class Rpersistence::Port::Bucket
  include Rpersistence::Port::Indexing::Bucket  
  include Rpersistence::Cursor::Indexing::Port::Bucket  
end

class Rpersistence::Port::Bucket::Index
  include Rpersistence::Cursor::Indexing::Port::Bucket::Index  
end


