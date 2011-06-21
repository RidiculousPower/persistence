
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------  Persistence Flat Configuration  ---------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Configuration::Flat
  
  ########################################
  #  Klass.instance_persistence_bucket=  #
  #  instance_persistence_bucket=        #
  ########################################

  # declare name of persistence bucket where object will be stored
  def instance_persistence_bucket=( persistence_bucket_class_or_name )

    @__rpersistence__instance_bucket__ = persistence_bucket_class_or_name.to_s

  end
  alias_method :store_as,    :instance_persistence_bucket=
  alias_method :persists_in, :instance_persistence_bucket=
  
end
