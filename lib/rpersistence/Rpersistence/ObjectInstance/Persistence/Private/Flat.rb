#---------------------------------------------------------------------------------------------------------#
#-----------------------------------------  Flat Instances  ----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Persistence::Flat
	
  ###################################
  #  primary_key_for_property_name  #
  ###################################

  def primary_key_for_property_name

    accessor_method_name, property_name  = accessor_name_for_var_or_method( property_name )
    
		return [ persistence_id, persistence_locale, persistence_version, nil, false ]

  end

  ##############################
  #  persistence_hash_to_port  #
  ##############################

	def persistence_hash_to_port

    persistence_hash  = { primary_key_for_property_name => self }

		return persistence_hash

	end

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

end
