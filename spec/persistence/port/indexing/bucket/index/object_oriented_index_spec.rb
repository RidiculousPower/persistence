
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Port::Indexing::Bucket::Index::ObjectOrientedIndex do

  # index_existing_objects is tested in BlockIndex since ObjectOrientedIndex does not have a way of creating keys
  # since all indexes call index_object( object ) to perform indexing, one test should apply to all cases
  
end
