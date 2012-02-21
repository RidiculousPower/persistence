$__rpersistence__spec__development = true
if $__rpersistence__spec__development
  require_relative '../lib/rpersistence.rb'
  require_relative '../adapters/mock/lib/rpersistence-adapter-mock.rb'
else
  require 'rpersistence'
  require 'rpersistence-port'
  require 'rpersistence-adapter-mock'
end

module Mock
end

require 'date'

require_relative 'Mock/Note.rb'
require_relative 'Mock/User.rb'
require_relative 'Mock/User/Address.rb'
require_relative 'Mock/User/DictionaryEntry.rb'
require_relative 'Mock/User/SubAccount.rb'

# FIX - Date needs to be treated as a string in and out

describe Rpersistence do

  it 'can create some objects with sub-objects and get them back' do
    
    Rpersistence.enable_port( :mock, Rpersistence::Adapter::Mock.new )
    
    user = Mock::User.new.persist!
    user.populate
    
    user.persistence_bucket.should == Mock::User.instance_persistence_bucket
    user.persistence_bucket.name.should == Mock::User.to_s.to_sym

    user.address.persistence_bucket.should == Mock::User::Address.instance_persistence_bucket
    user.address.persistence_bucket.name.should == Mock::User::Address.to_s.to_sym

    user.alternate_address.persistence_bucket.should == Mock::User::Address.instance_persistence_bucket
    user.alternate_address.persistence_bucket.name.should == Mock::User::Address.to_s.to_sym

    user.notes.persistence_bucket.should == Array.instance_persistence_bucket
    user.notes.persistence_bucket.name.should == Array.to_s.to_sym

    user.notes[0].persistence_bucket.should == Mock::Note.instance_persistence_bucket
    user.notes[0].persistence_bucket.name.should == Mock::Note.to_s.to_sym

    notes_array = Array.persist( user.notes.persistence_id )
    notes_array.should == user.notes

    dictionary_hash = Hash.persist( user.dictionary.persistence_id )
    dictionary_hash.should == user.dictionary

    persisted_user = Mock::User.persist( user.persistence_id )
    persisted_user.class.should == Mock::User

    persisted_user.should == user
    
  end

end
