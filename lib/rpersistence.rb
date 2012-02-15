require 'module-cluster'

require_relative '../port/indexing/lib/rpersistence-port-indexing.rb'
require_relative '../persistence/cursor/indexing/lib/rpersistence-persistence-cursor-indexing.rb'
require_relative '../persistence/flat/indexing/lib/rpersistence-persistence-flat-indexing.rb'
require_relative '../persistence/complex/indexing/lib/rpersistence-persistence-complex-indexing.rb'

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


