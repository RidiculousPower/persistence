
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Persistence Class Configuration  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence::ClassInstance::Configuration
	
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
  
end