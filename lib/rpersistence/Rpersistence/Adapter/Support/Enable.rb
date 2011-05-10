
module Rpersistence::Adapter::Support::Enable

  ########################################## Enable/Disable #################################################

  ############
  #  enable  #
  ############

  def enable
    @enabled  =  true
    return self
  end

  #############
  #  disable  #
  #############

  def disable
    @enabled  = false
    return self
  end

  ##############
  #  enabled?  #
  ##############

  def enabled?
    return @enabled
  end

end
