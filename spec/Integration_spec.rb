
require_relative '../lib/persistence.rb'

require 'date'

require_relative 'persistence/adapter/mock_helpers.rb'

# FIX - Date needs to be treated as a string in and out

describe ::Persistence do

  it 'can create some objects with sub-objects and get them back' do
    
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    user = ::Persistence::Adapter::Abstract::Mock::User.new.persist!
    user.populate
    
    user.persistence_bucket.should == ::Persistence::Adapter::Abstract::Mock::User.instance_persistence_bucket
    user.persistence_bucket.name.should == ::Persistence::Adapter::Abstract::Mock::User.to_s.to_sym
    
    user.address.persistence_bucket.should == ::Persistence::Adapter::Abstract::Mock::User::Address.instance_persistence_bucket
    user.address.persistence_bucket.name.should == ::Persistence::Adapter::Abstract::Mock::User::Address.to_s.to_sym
    
    user.alternate_address.persistence_bucket.should == ::Persistence::Adapter::Abstract::Mock::User::Address.instance_persistence_bucket
    user.alternate_address.persistence_bucket.name.should == ::Persistence::Adapter::Abstract::Mock::User::Address.to_s.to_sym
    
    user.notes.persistence_bucket.should == Array.instance_persistence_bucket
    user.notes.persistence_bucket.name.should == Array.to_s.to_sym
    
    user.dictionary.persistence_bucket.should == Hash.instance_persistence_bucket
    user.dictionary.persistence_bucket.name.should == Hash.to_s.to_sym
    
    user.notes[0].persistence_bucket.should == ::Persistence::Adapter::Abstract::Mock::Note.instance_persistence_bucket
    user.notes[0].persistence_bucket.name.should == ::Persistence::Adapter::Abstract::Mock::Note.to_s.to_sym
    
    notes_array = Array.persist( user.notes.persistence_id )
    notes_array.should == user.notes
    
    dictionary_hash = Hash.persist( user.dictionary.persistence_id )
    dictionary_hash.should == user.dictionary
    
    persisted_user = ::Persistence::Adapter::Abstract::Mock::User.persist( user.persistence_id )
    persisted_user.class.should == ::Persistence::Adapter::Abstract::Mock::User
    
    persisted_user.should == user
    
    ::Persistence.disable_port( :mock )
    
  end

end
