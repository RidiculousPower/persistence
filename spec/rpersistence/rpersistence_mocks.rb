require_relative '../lib/rpersist.rb'

class Rpersistence::Mock::Object
  
  attr_accessor     :unique_id, :value, :atomic_value
  
  persist_by        :unique_id
  attr_atomic   :atomic_value
  attr_shared  Rpersistence::Mock::Object::Other, :shared_value
    
end

class Rpersistence::Mock::Object::Subclass < Rpersistence::Mock::Object

  store_as        self.superclass
  
end
