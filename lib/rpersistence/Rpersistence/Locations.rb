
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------------  Rpersistence Locations  -------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::Locations

  ########################
  #  self.spec_location  #
  ########################

  def self.spec_location
    return File.expand_path( File.dirname( __FILE__ ) + '../../../spec/Rpersistence/ObjectInstance/Persistence_spec.rb' )
  end
	

end
