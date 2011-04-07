
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------------  Rpersistence Singleton  -------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################
	
	def self.port_for_name_or_port( persistence_port_or_name )
		persistence_port = nil
		if persistence_port_or_name.is_a?( String ) or persistence_port_or_name.is_a?( Symbol )
			persistence_port = port( persistence_port_or_name )
			persistence_port.name = persistence_port_or_name
		else
			persistence_port = persistence_port_or_name
		end
		return persistence_port
	end

end
