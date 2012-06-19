
class ::Persistence::Adapter::Abstract::Mock::Port
  
  def initialize( name, adapter )
    @name = name
    @adapter = adapter
  end
  
  def enable
    @enabled = true
  end

  def enabled?
    return @enabled
  end
  
  def disable
    @enabled = false
  end

end