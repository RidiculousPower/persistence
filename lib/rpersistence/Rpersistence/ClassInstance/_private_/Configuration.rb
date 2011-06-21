
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Persistence Class Configuration  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Configuration

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  #########################################################
  #  Klass::get_cascading_hash_configuration_from_Object  #
  #########################################################

  def get_cascading_hash_configuration_from_Object( which_configuration )
    
    # merge downward from Object, including overrides from each subclass    
    if ancestors.index( Object )
      ancestors_from_object = ancestors.slice( 0, ancestors.index( Object ) )
    else
      ancestors_from_object = ancestors
    end

    ancestors_from_object.reverse!

    configuration_variable   = configuration_variable( which_configuration )
  
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
  ##########################################################

  def get_cascading_array_configuration_from_Object( which_configuration )
    
    # merge downward from Object, including overrides from each subclass
    if ancestors.index( Object )
      ancestors_from_object = ancestors.slice( 0, ancestors.index( Object ) )
    else
      ancestors_from_object = ancestors
    end
    
    ancestors_from_object.reverse!
    
    configuration_variable   = configuration_variable( which_configuration )

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
  #########################################################

  def get_configuration_searching_upward_from_self( which_configuration )

    configuration_variable   = configuration_variable( which_configuration )
    configuration           = nil

    # search upward for first explicitly set value
    ancestors.each do |this_ancestor|
      if this_ancestor.instance_variable_defined?( configuration_variable )
        configuration = this_ancestor.object_instance_variable_get( configuration_variable )
        break
      end      
    end

    return configuration
    
  end

  ############################################# Indexes #####################################################
  
  ##############################
  #  Klass::create_attr_index  #
  ##############################

	def create_attr_index( attribute, permits_duplicates )

		permits_duplicates = nil

		if has_index?( attribute )

  		# if index has aleady been declared and uniqueness does not match, raise error
			if permits_duplicates != index_permits_duplicates?( attribute )
   			raise 'Index ' + attribute.to_s + ' has already been declared ' + ( permits_duplicates ? 'to permit duplicates' : 'unique' ) + 
   			      ', so cannot be redefined as ' +  ( permits_duplicates ? 'unique' : 'to permit duplicates' )
		  end
		  
		# otherise record uniqueness if needed
  	else
  	  
  	  # if we have a port that supports this class, create the index
  	  if persistence_port
  			persistence_port.adapter.create_index( self, attribute, permits_duplicates )
    		# we need to index any objects of this class already persisted
    		index_persisted_objects( attribute )
	    else
        Rpersistence.create_pending_index_for_class( self, attribute, permits_duplicates )
      end

		end
		
		return self
		
	end

  ####################################
  #  Klass::index_persisted_objects  #
  ####################################

	def index_persisted_objects( attribute )

		# create a new atomic cursor - this will read all persisted elements atomically
		Rpersistence::Cursor::Atomic.new( persistence_port, instance_persistence_bucket, nil ).each do |this_object|
			persistence_port.adapter.index_object_property( this_object, attribute ) if this_object.is_a?( self )
		end

		return self
		
	end
  
end

