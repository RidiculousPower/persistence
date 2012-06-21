
###
# Provides home directory and enable/disable methods to including adapter class instances.
#
module ::Persistence::Adapter::Abstract::EnableDisable

  ################
  #  initialize  #
  ################

  ###
  # Initialize with home directory. Creates directory if it does not exist.
  #
  # @param home_directory Directory where persistence data should be stored.
  #
  def initialize( home_directory = nil )

    super() if defined?( super )

    @enabled = false

    # initialize home directory if necessary
    if @home_directory = home_directory and ! ::File.exists?( home_directory )
      ::Dir.mkdir( home_directory )
    end
    
  end

  ####################
  #  home_directory  #
  ####################

  ###
  # Track directory where persistence data is stored.
  #
  # @!attribute[r]
  # @return [String] Path to directory.
  #
  attr_accessor :home_directory

  ############
  #  enable  #
  ############

  ###
  # Enable adapter for use. Abstract method simply provides tracking of whether adapter is enabled or not.
  #
  # @return self
  #
  def enable

    @enabled = true

    return self

  end

  #############
  #  disable  #
  #############

  ###
  # Disable adapter to prohibit use. Abstract method simply provides tracking of whether adapter is enabled or not.
  #
  # @return self
  #
  def disable

    @enabled = false

    return self

  end

  ##############
  #  enabled?  #
  ##############

  ###
  # Reports whether adapter is enabled for use.
  #
  # @return [true/false] Whether adapter is enabled.
  #
  def enabled?

    return @enabled

  end

  ###############
  #  disabled?  #
  ###############

  ###
  # Reports whether adapter is disabled, prohibiting use.
  #
  # @return [true/false] Whether adapter is disabled.
  #
  def disabled?
    
    return ! @enabled

  end

end
