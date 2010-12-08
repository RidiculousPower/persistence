require_relative '../lib/rpersist.rb'

require_relative './rpersistence_mocks.rb'

# we have two types of persistence
# * explicit persistence (object.persist!)
# * implicit (atomic) persistence
# additionally, we have two types of atomic persistence
# * atomic accessors
# * atomic functions

describe Rpersistence do

  ###################################################################
  #  Rpersistence.persist_with( persistence_port )                          #
  #  Rpersistence.persist_with( :persistence_port_name, persistence_port )      #
  #  Rpersistence.persist_with( persistence_port, :persistence_port_name )      #
  #  Rpersistence.persistence_port=( persistence_port )                         #
  #  Rpersistence.persistence_port=( :persistence_port_name, persistence_port )     #
  #  Rpersistence.persistence_port=( persistence_port, :persistence_port_name )     #
  #  Rpersistence.set_persistence_port( persistence_port )                      #
  #  Rpersistence.set_persistence_port( :persistence_port_name, persistence_port )  #
  #  Rpersistence.set_persistence_port( persistence_port, :persistence_port_name )  #
  ###################################################################
  
  it "requires that a storage port be specified" do
    Rpersistence.persistence_port = Rpersistence::Mock::StoragePort.new
  end
  
  it "can use a name to reference the storage port to allow multiple simultaneous storage ports" do
    Rpersistence.set_persistence_port( :persistence_port, Rpersistence::Mock::StoragePort.new )
    Rpersistence.set_persistence_port( Rpersistence::Mock::StoragePort.new, :persistence_port )
  end
  
  ####################################################
  #  persist!                                        #
  #  persist!( persistence_port )                        #
  #  persist!( :persistence_port_name )                  #
  #  persists?                                       #
  #  self.persists?( :storage_id )                   #
  #  self.persist                                    #
  #  self.persist( persistence_port )                    #
  #  self.persist( :persistence_port_name )              #
  #  cease!                                          #
  #  cease!( persistence_port )                          #
  #  cease!( :persistence_port_name )                    #
  #  self.cease!( unique_key )                       #
  #  self.cease!( persistence_port, unique_key )         #
  #  self.cease!( :persistence_port_name, unique_key )   #
  ####################################################
  
  # => object.persist!
  # => data.persist!
  # => class.persist!
  # => module.persist!
  # => struct.persist!
  #
  # => object.persists?
  # => data.persists?
  # => class.persists?
  # => module.persists?
  # => struct.persists?
  #
  # => Object.persist
  # => Data.persist
  # => Class.persist
  # => Module.persist
  # => Struct.persist
  #
  # => object.cease!
  # => data.cease!
  # => class.cease!
  # => module.cease!
  # => struct.cease!
  
  it "can persist an object to and from a storage port and later cease in this persistence (which can be reverted)" do
    
    Rpersistence.persistence_port = Rpersistence::Mock::StoragePort.new
    
    # create and persist an object
    object = Rpersistence::Mock::Object.new
    object.unique_id = 'mock object id'
    object.value = 'value' 
    object.persist!( persistence_port )
    object.persists?.should == true

    # persist object from storage
    persisted_object = Rpersistence::Mock::Object.persist( object.unique_id )
    persisted_object.value.should == object.value
    
    # cease object persistence
    persisted_object.cease!
    Rpersistence::Mock::Object.persist( object.unique_id ).should == nil
    
  end

  #######################################################
  #  prune!                                             #
  #  prune!( version )                                  #
  #  prune!( persistence_port )                             #
  #  prune!( persistence_port, version )                    #
  #  prune!( :persistence_port )                            #
  #  prune!( :persistence_port, version )                   #
  #  self.prune!( unique_key )                          #
  #  self.prune!( persistence_port, unique_key )            #
  #  self.prune!( :persistence_port, unique_key )           #
  #  self.prune!( unique_key, version )                 #
  #  self.prune!( persistence_port, unique_key, version )   #
  #  self.prune!( :persistence_port, unique_key, version )  #
  #######################################################

  it "can prune old versions (which are permanently deleted)" do
    
  end  

  it "can prune old versions by unique key (which are permanently deleted)" do
    
  end  
  
  if "can prune all versions - if it has been cease!'d (which are permanently deleted)" do
    
  end

  if "can prune all versions by unique key - if it has been cease!'d (which are permanently deleted)" do
    
  end

  ###############################################
  #  delete!                                    #
  #  delete!( persistence_port )                    #
  #  delete!( :persistence_port )                   #
  #  self.delete!( unique_key )                 #
  #  self.delete!( persistence_port, unique_key )   #
  #  self.delete!( :persistence_port, unique_key )  #
  ###############################################

  it "can delete itself in a revertible way" do
  
  end

  ################################################
  #  destroy!                                    #
  #  destroy!( persistence_port )                    #
  #  destroy!( :persistence_port )                   #
  #  self.destroy!( unique_key )                 #
  #  self.destroy!( persistence_port, unique_key )   #
  #  self.destroy!( :persistence_port, unique_key )  #
  ################################################

  it "can remove all evidence it ever existed" do
  
  end

  ##########################################
  #  flash_persist!                        #
  #  flash_persist!( persistence_port )        #
  #  flash_persist!( :persistence_port_name )  #
  #  flash_persisted?                      #
  ##########################################

  it "can flash persist an object, which means next retrieval will also delete" do
    
  end

  #########
  #  dup  #
  #########
  
  # => object.dup
  # => data.dup
  # => class.dup
  # => module.dup
  # => struct.dup
  
  it "can " do
    
  end

  ###########
  #  clone  #
  ###########

  # => object.clone
  # => data.clone
  # => class.clone
  # => module.clone
  # => struct.clone


  

  
end