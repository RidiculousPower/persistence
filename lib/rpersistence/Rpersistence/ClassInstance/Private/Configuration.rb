
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Persistence Class Configuration  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Configuration

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  #########################################################
  #  Klass::get_cascading_hash_configuration_from_Object  #
  #  get_cascading_hash_configuration_from_Object         #
  #########################################################

	def get_cascading_hash_configuration_from_Object( which_configuration )
		
		# merge downward from Object, including overrides from each subclass		
		if ancestors.index( Object )
			ancestors_from_object = ancestors.slice( 0, ancestors.index( Object ) )
		else
			ancestors_from_object = ancestors
		end

		ancestors_from_object.reverse!

		configuration_variable 	= configuration_variable( which_configuration )
	
		configuration = Hash.new
		ancestors_from_object.each do |this_ancestor|
			if this_ancestor.instance_variable_defined?( configuration_variable )
				configuration = configuration.merge( this_ancestor.object_instance_variable_get( configuration_variable ) )
			end
		end
		
		return configuration

	end
	
	##########################################################
  #  Klass::get_cascading_array_configuration_from_Object  #
  #  get_cascading_array_configuration_from_Object         #
  ##########################################################

	def get_cascading_array_configuration_from_Object( which_configuration )
		
		# merge downward from Object, including overrides from each subclass
		if ancestors.index( Object )
			ancestors_from_object = ancestors.slice( 0, ancestors.index( Object ) )
		else
			ancestors_from_object = ancestors
		end
		
		ancestors_from_object.reverse!
		
		configuration_variable 	= configuration_variable( which_configuration )

		configuration = Array.new
		ancestors_from_object.each do |this_ancestor|
			if this_ancestor.instance_variable_defined?( configuration_variable )
				configuration = configuration.concat( this_ancestor.object_instance_variable_get( configuration_variable ) ).uniq
			end
		end
		
		return configuration
			
	end
  #########################################################
  #  Klass::get_configuration_searching_upward_from_self  #
  #  get_configuration_searching_upward_from_self         #
  #########################################################

	def get_configuration_searching_upward_from_self( which_configuration )

		configuration_variable 	= configuration_variable( which_configuration )
		configuration 					= nil

		# search upward for first explicitly set value
		ancestors.each do |this_ancestor|
			if this_ancestor.instance_variable_defined?( configuration_variable )
				configuration = this_ancestor.object_instance_variable_get( configuration_variable )
				break
			end			
		end

		return configuration
		
	end
	
end

