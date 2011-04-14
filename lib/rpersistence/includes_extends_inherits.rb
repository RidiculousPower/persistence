
#---------------------------------------------------------------------------------------------------------#
#-------------------------  Includes, Extends, Inherits, Default Settings  -------------------------------#
#---------------------------------------------------------------------------------------------------------#

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

  extend 	Rpersistence::ClassInstance::Persistence

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

  extend 	Rpersistence::ClassInstance::Persistence

	include Rpersistence::ObjectInstance::Persistence::Flat

	include Rpersistence::ClassInstance::Configuration
	include Rpersistence::ClassInstance::Persistence::Flat

end

###########################################################################################################
#############################################  Bignum  ####################################################
###########################################################################################################

class Bignum

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
#############################################  Fixnum  ####################################################
###########################################################################################################

class Fixnum

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
#############################################  Complex  ###################################################
###########################################################################################################

class Complex

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
#############################################  Rational  ##################################################
###########################################################################################################

class Rational

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
##############################################  Float  ####################################################
###########################################################################################################

class Float

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
############################################  TrueClass  ##################################################
###########################################################################################################

class TrueClass

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
###########################################  FalseClass  ##################################################
###########################################################################################################

class FalseClass

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
#############################################  String  ####################################################
###########################################################################################################

class String

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
#############################################  Symbol  ####################################################
###########################################################################################################

class Symbol

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
#############################################  Regexp  ####################################################
###########################################################################################################

class Regexp

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
##############################################  File  #####################################################
###########################################################################################################

class File

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end

###########################################################################################################
############################################  NilClass  ###################################################
###########################################################################################################

class NilClass

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

end
