
###
# @private
###
# Singleton providing helper methods for writing adapters.
#
module ::Persistence::Adapter::Abstract
            
  ########################
  #  self.spec_location  #
  ########################

  ###
  # Returns location of abstract adapter spec files. Intended for re-usable testing of adapter implementations.
  #
  # @return [String] Path to location of spec files.
  #
  def self.spec_location
    return File.expand_path( File.dirname( __FILE__ ) + '/../../../spec_abstract/persistence/adapter/abstract/' )    
  end

end
