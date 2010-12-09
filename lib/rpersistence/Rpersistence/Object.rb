
module Rpersistence::Object

  ####################
  #  persistence_id  #
  ####################

  def persistence_id
    return @__rpersistence_id__
  end

  #####################
  #  persistence_id=  #
  #####################

  def persistence_id=( id )
    @__rpersistence_id__  = id.freeze
  end

  #####################
  #  persistence_key  #
  #####################
  
  def persistence_key
    return __send__.( persistence_key_method )
  end

  ################
  #  persisted?  #
  ################

	def persisted?
		
	end

  ############
  #  cease!  #
  ############

	def cease!
		
	end

end