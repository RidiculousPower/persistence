
module Rpersistence::KlassAndInstance::Flat

  ##########################################################
  #  Klass.include_or_extend_for_persistence_if_necessary  #
  #  include_or_extend_for_persistence_if_necessary        #
  ##########################################################

  private

  def include_or_extend_for_persistence_if_necessary
    return self
  end

end

class Object
  
	include	Rpersistence::KlassAndInstance::Flat
	extend	Rpersistence::KlassAndInstance::Flat

end
