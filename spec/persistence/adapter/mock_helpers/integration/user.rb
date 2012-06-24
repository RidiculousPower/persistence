
class ::Persistence::Adapter::Abstract::Mock::User

  include ::Persistence
  
  attr_atomic_accessor :username, :firstname, :lastname, :address, :alternate_address, :url, :notes, :dictionary, :subaccount
  
  def populate

    self.username = 'User ' + rand( 100000000 ).to_s
    self.firstname = 'First ' + rand( 100000000 ).to_s
    self.lastname = 'Last ' + rand( 100000000 ).to_s
      
    # new visitors have an address
    self.address = ::Persistence::Adapter::Abstract::Mock::User::Address.new

    ::Persistence::Adapter::Abstract::Mock::User::Address.instance_persistence_bucket

    # new visitors have an address
    self.alternate_address = ::Persistence::Adapter::Abstract::Mock::User::Address.new
    
    self.notes = [ ]

    new_note = ::Persistence::Adapter::Abstract::Mock::Note.new
    self.notes.push( new_note )

    self.notes.persist!

    self.dictionary = { }

    new_entry = ::Persistence::Adapter::Abstract::Mock::User::DictionaryEntry.new
    new_entry.populate
    self.dictionary[ 'Some Word ' + rand( 100000000 ).to_s ] = new_entry
    self.dictionary.persist!
    
#    self.subaccount = ::Persistence::Adapter::Abstract::Mock::User::SubAccount.new( self )

    if rand( 100000000 ) > 75000000
      self.url = 'URL ' + rand( 100000000 ).to_s
    end

  end
  
end
