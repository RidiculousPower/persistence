
Rpersistence::Specs::Complex  = 'Complex object specs.'

describe Rpersistence::Specs::Complex do

  ##############################################  Cease  ####################################################

  ##################
  #  cease!  #
  ##################

#  it "can cease persisting a persisted object" do
#    
#  end

#######################################################
#  prune!                                     #
#  prune!( version )                          #
#  prune!( persistence_port )                     #
#  prune!( persistence_port, version )            #
#  prune!( :persistence_port )                    #
#  prune!( :persistence_port, version )           #
#  self.prune!( unique_key )                  #
#  self.prune!( persistence_port, unique_key )    #
#  self.prune!( :persistence_port, unique_key )   #
#  self.prune!( unique_key, version )         #
#  self.prune!( persistence_port, unique_key, version )   #
#  self.prune!( :persistence_port, unique_key, version )  #
#######################################################

it "can prune old versions (which are permanently deleted)" do
  
end  

it "can prune old versions by unique key (which are permanently deleted)" do
  
end  

it "can prune all versions - if it has been cease!'d (which are permanently deleted)" do
  
end

it "can prune all versions by unique key - if it has been cease!'d (which are permanently deleted)" do
  
end

###############################################
#  delete!                            #
#  delete!( persistence_port )            #
#  delete!( :persistence_port )           #
#  self.delete!( unique_key )         #
#  self.delete!( persistence_port, unique_key )   #
#  self.delete!( :persistence_port, unique_key )  #
###############################################

it "can delete itself in a revertible way" do

end

################################################
#  destroy!                            #
#  destroy!( persistence_port )            #
#  destroy!( :persistence_port )           #
#  self.destroy!( unique_key )         #
#  self.destroy!( persistence_port, unique_key )   #
#  self.destroy!( :persistence_port, unique_key )  #
################################################

it "can remove all evidence it ever existed" do

end


##########################################
#  flash_persist!                #
#  flash_persist!( persistence_port )#
#  flash_persist!( :persistence_port_name )  #
#  flash_persisted?              #
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