
#---------------------------------------------------------------------------------------------------------#
#-------------------------  Includes, Extends, Inherits, Default Settings  -------------------------------#
#---------------------------------------------------------------------------------------------------------#

###########################################################################################################
##############################################  Class  ####################################################
###########################################################################################################

class Class

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ClassInstance::Configuration

  include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
#############################################  Object  ####################################################
###########################################################################################################

class Object

  include Rpersistence::ObjectInstance::Attributes
  include Rpersistence::ObjectInstance::Configuration
  include Rpersistence::ObjectInstance::Inspect
  include Rpersistence::ObjectInstance::ParsePersistenceArgs
  include Rpersistence::ObjectInstance::Persistence
  include Rpersistence::ObjectInstance::Status

  extend   Rpersistence::ClassInstance::Persistence

  ######################
  #  Default Settings  #
  ######################

   persists_instance_variables_by_default!

  persists_non_atomic_by_default!

end

###########################################################################################################
##############################################  Class  ####################################################
###########################################################################################################

class Class
  
  # we have to re-open Class after Class and Object have been initialized
  # otherwise we don't have support yet for attr_index

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
#############################################  Bignum  ####################################################
###########################################################################################################

class Bignum

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key
  
end

###########################################################################################################
#############################################  Fixnum  ####################################################
###########################################################################################################

class Fixnum

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
#############################################  Complex  ###################################################
###########################################################################################################

class Complex

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
#############################################  Rational  ##################################################
###########################################################################################################

class Rational

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
##############################################  Float  ####################################################
###########################################################################################################

class Float

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration
  
  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
############################################  TrueClass  ##################################################
###########################################################################################################

class TrueClass

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
###########################################  FalseClass  ##################################################
###########################################################################################################

class FalseClass

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
#############################################  String  ####################################################
###########################################################################################################

class String

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
#############################################  Symbol  ####################################################
###########################################################################################################

class Symbol

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
#############################################  Regexp  ####################################################
###########################################################################################################

class Regexp

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
##############################################  File  #####################################################
###########################################################################################################

class File

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat
  extend   Rpersistence::ClassInstance::Persistence::Flat::FileClassInstance

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Persistence::Flat::FileInstance
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end

###########################################################################################################
############################################  NilClass  ###################################################
###########################################################################################################

class NilClass

  extend   Rpersistence::ClassInstance::Persistence
  extend   Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ObjectInstance::Persistence::Flat
  include Rpersistence::ObjectInstance::Flat::Configuration

  attr_accessor :persistence_key
  attr_index    :persistence_key

end
