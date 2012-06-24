
class ::Persistence::Adapter::Abstract::Mock::User::Address
  
  include ::Persistence

  attr_atomic_accessor :number, :street, :city, :state, :zipcode
  
  def populate
        
    self.number = rand( 100000000 )
    self.street = 'Street ' + rand( 100000000 ).to_s
    self.city = 'City ' + rand( 100000000 ).to_s
    self.state = 'State ' + rand( 100000000 ).to_s
    self.zipcode = rand( 10000 ).to_s
  
  end
  
end
