
require_relative '../../../lib/persistence.rb'

describe ::Persistence::Object::PersistenceID do
  
  #####################
  #  persistence_id=  #
  #  persistence_id   #
  #####################
  
  it 'can set and get a persistence id that uniquely identifies the object instance' do
    class ::Persistence::Object::PersistenceID::Mock
      include ::Persistence::Object::PersistenceID
    end
    ::Persistence::Object::PersistenceID::Mock.new.instance_eval do
      persistence_id.should == nil
      self.persistence_id = 1
      persistence_id.should == 1
    end
  end
  
end
