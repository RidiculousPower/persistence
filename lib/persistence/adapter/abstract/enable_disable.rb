
module ::Persistence::Adapter::Abstract::EnableDisable

  attr_accessor :home_directory

  ################
  #  initialize  #
  ################

  def initialize( home_directory = nil )

    super() if defined?( super )

    @enabled = false

    @home_directory = home_directory
    
    # initialize home directory if necessary
    if home_directory and ! File.exists?( home_directory )
      Dir.mkdir( home_directory )
    end
    
  end

  ############
  #  enable  #
  ############

  def enable
    @enabled = true
    return self
  end

  #############
  #  disable  #
  #############

  def disable
    @enabled = false
    return self
  end

  ##############
  #  enabled?  #
  ##############

  def enabled?
    return @enabled
  end

  ###############
  #  disabled?  #
  ###############

  def disabled?
    return ! @enabled
  end

end
