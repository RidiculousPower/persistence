
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Persistence Class Configuration  --------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Configuration
  
  ##############################
  #  Klass.persistence_bucket  #
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
  ########################################

  # declare name of persistence bucket where object will be stored
  def instance_persistence_bucket=( persistence_bucket_class_or_name )

    include_or_extend_for_persistence_if_necessary

    @__rpersistence__instance_bucket__ = persistence_bucket_class_or_name.to_s

  end
  alias_method :store_as,    :instance_persistence_bucket=
  alias_method :persists_in, :instance_persistence_bucket=

  #######################################
  #  Klass.instance_persistence_bucket  #
  #######################################

  def instance_persistence_bucket
  
    return @__rpersistence__instance_bucket__ ||= self.to_s
    
  end
 
  ######################
  #  Klass.attr_index  #
  ######################
  
  def attr_index( *attributes )

    @__rpersistence__indexes__ ||= Hash.new

		attributes.each do |this_index|
			create_attr_index( this_index, false )
			@__rpersistence__indexes__[ this_index ] = :unique
		end
		
		if persists_atomic_by_default?
		  attr_atomic( attributes )
	  else
		  attr_non_atomic( attributes )
    end
		
    return self

  end

  ######################################
  #  Klass.attr_index_with_duplicates  #
  ######################################
  
  def attr_index_with_duplicates( *attributes )
		
		@__rpersistence__indexes__ ||= Hash.new

		attributes.each do |this_index|
			create_attr_index( this_index, true )
			@__rpersistence__indexes__[ this_index ] = :permits_duplicates
		end

		if persists_atomic_by_default?
		  attr_atomic( attributes )
	  else
		  attr_non_atomic( attributes )	    
    end

    return self
    
	end

  ######################
  #  Klass.has_index?  #
  ######################
  
  def has_index?( *attributes )
    
    has_index = false
    
    attributes.each do |this_attribute|
      break unless has_index = indexes.include?( this_attribute )
    end

    return has_index

  end

  #####################################
  #  Klass.index_permits_duplicates?  #
  #####################################
  
  def index_permits_duplicates?( *attributes )

    has_index = false
    
    attributes.each do |this_attribute|
      break unless has_index = indexes_with_duplicates.include?( this_attribute )
    end

    return has_index

  end
  
  ########################
  #  Klass.delete_index  #
  ########################
  
  def delete_index( *attributes )
		
		attributes.each do |this_index|
		  # since we cascade we have to track exclusions rather than simply deleting
	  	( @__rpersistence__exclude_from_indexing__ ||= Array.new ).push( this_index )
			persistence_port.adapter.delete_index( self, this_index )
  	end
		
		return self
		
	end

  ###################
  #  Klass.indexes  #
  ###################

  def indexes

    inherited_indexes = get_cascading_hash_configuration_from_Object( :indexes )

    ( @__rpersistence__exclude_from_indexing__ ||= Array.new ).each do |this_excluded_index|
      inherited_indexes.delete( this_excluded_index )
    end

    return inherited_indexes
    
  end

  ##########################
  #  Klass.unique_indexes  #
  ##########################

  def unique_indexes

    return indexes.select { |index, status| status == :unique }.keys

  end

  ###################################
  #  Klass.indexes_with_duplicates  #
  ###################################

  def indexes_with_duplicates

    return indexes.select { |index, status| status == :permits_duplicates }.keys

  end
 
end