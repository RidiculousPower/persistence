
class ::Persistence::Adapter::Abstract::Mock::User::SubAccount
  
  include ::Persistence
  
  attr_atomic_accessor :username, :parent_user

  def populate( parent_user = nil )
    
    self.user = ::Persistence::Adapter::Abstract::Mock::User.new
    self.parent_user = parent_user
    
  end
  
end
