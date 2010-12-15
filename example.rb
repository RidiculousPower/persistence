require 'rpersistence'

Rpersistence.enable_port( :persistence, Rpersistence::Adapter::Rbdb.new( './ruby-persistence' ) )

class User
  persist_by    :username
  attr_atomic   :username, :first_name, :last_name
end

user = User.new
user.username     = 'newuser'
user.first_name   = 'New'
user.last_name    = 'User'
user.persist!

same_user = User.persist( 'newuser' )
require 'pp'
pp same_user

