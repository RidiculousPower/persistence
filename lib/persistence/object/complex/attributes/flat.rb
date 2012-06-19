
module ::Persistence::Object::Complex::Attributes::Flat

  include ::CascadingConfiguration::Hash

  ###############
  #  attr_flat  #
  ###############

  def attr_flat( *attributes )

    return persists_flat( *attributes )
    
  end

  ################
  #  attr_flat!  #
  ################

  def attr_flat!
    
    attr_flat( *persistent_attributes.keys )

    return self
    
  end

  ####################
  #  persists_flat?  #
  ####################

  def persists_flat?( *attributes )

    should_persist_flat = false

    if attributes.empty?
      should_persist_flat = persists_flat[ nil ]
    else
      attributes.each do |this_attribute|
        break unless should_persist_flat = persists_flat_hash[ this_attribute ]
      end
    end
    
    return should_persist_flat
    
  end

  ###################
  #  persists_flat  #
  ###################

  def persists_flat( *attributes )

    if attributes.empty?
      persists_flat_hash[ nil ] = true
    else
      attributes.each do |this_attribute|
        persists_flat_hash[ this_attribute ] = true
      end
    end
    
    return self
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  attr_configuration_hash :persists_flat_hash

end
