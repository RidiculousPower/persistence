
module Rpersistence::Adapter::Support::Initialize

  ################
  #  initialize  #
  ################

  def initialize( home_directory = nil )
    
    @enabled           = false
    @home_directory    = home_directory
    
    # initialize home directory if necessary
    if home_directory and ! File.exists?( home_directory )
      Dir.mkdir( home_directory )
    end
    
    return self
  end

end
