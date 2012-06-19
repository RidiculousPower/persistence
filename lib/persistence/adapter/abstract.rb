
module ::Persistence::Adapter::Abstract
            
  ########################
  #  self.spec_location  #
  ########################

  def self.spec_location
    return File.expand_path( File.dirname( __FILE__ ) + '/../../../spec_abstract/persistence/adapter/abstract/' )    
  end

end
