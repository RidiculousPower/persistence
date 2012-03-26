
class Mock::User::SubAccount
  
  include ::Rpersistence
  
  attr_atomic_accessor :username, :parent_user

  def populate( parent_user = nil )
    
    self.user = ::Mock::User.new
    self.parent_user = parent_user
    
  end
  
end
