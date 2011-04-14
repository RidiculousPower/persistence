
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Persistence Class Configuration  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Configuration
	
	##############################
  #  Klass.persistence_bucket  #
  #  persistence_bucket        #
  ##############################
  
  def persistence_bucket
    
		bucket = nil

		# if specified at instance level, use specified value
		# otherwise, use value stored in class		
    if @__rpersistence__bucket__
    	
    	bucket = @__rpersistence__bucket__
    
    else
      
      bucket = self.class.to_s
        
  	end

		return bucket

  end

  ########################################
  #  Klass.instance_persistence_bucket=  #
  #  instance_persistence_bucket=        #
  ########################################

	# declare name of persistence bucket where object will be stored
  def instance_persistence_bucket=( persistence_bucket_class_or_name )

    include_or_extend_for_persistence_if_necessary

    @__rpersistence__instance_bucket__ = persistence_bucket_class_or_name.to_s

  end
	alias_method :store_as, 	:instance_persistence_bucket=
  alias_method :persist_in, :instance_persistence_bucket=

	#######################################
  #  Klass.instance_persistence_bucket  #
  #  instance_persistence_bucket        #
  #######################################

  def instance_persistence_bucket
	
		bucket = nil
		
		# if specified at instance level, use specified value
		# otherwise, use value stored in class		
    if @__rpersistence__instance_bucket__
    	
    	bucket = @__rpersistence__instance_bucket__
    
    else
      
      bucket = self.to_s
      
  	end

		return bucket
		
	end
	  
end