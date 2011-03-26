
Rpersistence::Specs::Complex  = 'Complex object specs.'

describe Rpersistence::Specs::Complex do
  
  before( :all ) do
    rpersistence_open_for_spec
    rpersistence_enable_for_spec
  end

  after( :all ) do
    rpersistence_disable_for_spec
  end

  class User
    attr_accessor :username, :first_name, :last_name
  end

  it "can persist an object to and from an arbitrary bucket with an arbitrary key" do
    user = User.new
    user.username   = 'user'
    user.first_name = 'first'
    user.last_name  = 'last'
    user.persist!( 'Misc Objects', 'object storage key' )
    
    persisted_user = User.persist( 'Misc Objects', 'object storage key' )
    persisted_user.should == user
    
  end

  it "can persist an object to and from a default bucket with an arbitrary key" do
    user = User.new
    user.username   = 'user'
    user.first_name = 'first'
    user.last_name  = 'last'
    user.persist!( 'object storage key' )
    User.persist( 'object storage key' ).should == user
  end

  it "can persist an object to and from a default bucket with an arbitrary key method" do
    class User::Auto < User
      persists_by  :username
    end
    user = User::Auto.new
    user.username   = 'user'
    user.first_name = 'first'
    user.last_name  = 'last'
    user.should == user
    user.persist!
    User::Auto.persist( 'user' ).should == user
  end

  it "can persist an object to and from a default bucket with an arbitrary key variable" do
    class User::Auto < User
      persists_by  :@username
    end
    user = User::Auto.new
    user.username   = 'user'
    user.first_name = 'first'
    user.last_name  = 'last'
    user.should == user
    user.persist!
    User::Auto.persist( 'user' ).should == user
  end
  
  it "can persist an object with hash members" do
    
  end

  it "can persist an object with array members" do
    
  end
  
  it "can persist an object with other objects as members" do
    
  end

  it "can persist and cascade an object with other persistent objects as members" do
    
  end

  ##############################################  Cease  ####################################################

  ##################
  #  Klass.cease!  #
  #  cease!        #
  ##################

  it "can cease persisting a persisted object" do
    
  end


end