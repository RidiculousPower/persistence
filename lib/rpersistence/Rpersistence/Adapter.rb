
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Rpersistence Adapter Singleton  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence::Adapter

  ########################
  #  self.spec_location  #
  ########################

  def self.spec_location
    return File.expand_path( File.dirname( __FILE__ ) + '../../../../spec/Rpersistence/Adapter/Adapter_spec.rb' )    
  end

end
