
#---------------------------------------------------------------------------------------------------------#
#--------------------------------  Includes, Extends, and Inherits  --------------------------------------#
#---------------------------------------------------------------------------------------------------------#

###########################################################################################################
#############################################  Object  ####################################################
###########################################################################################################

class Object

  extend 	Rpersistence::ClassInstance::Persistence

	include Rpersistence::ObjectInstance::Attributes
	include Rpersistence::ObjectInstance::Configuration
	include Rpersistence::ObjectInstance::Inspect
	include Rpersistence::ObjectInstance::ParsePersistenceArgs
	include Rpersistence::ObjectInstance::Persistence
	include Rpersistence::ObjectInstance::Status

  ###############
  #  inherited  #
  ###############

  def self.inherited( class_or_module )

    super
    
    class_or_module.instance_eval do
      
  		# if true all ivars are persisted
      @__rpersistence__persists_ivars_by_default__		= true
  		# enable or disable atomic persistence if no explicit include/exclude is specified
  		# if @__rpersistence__persists_ivars_by_default__ is true and a var is ! explicitly included/excluded, var will be atomic
      @__rpersistence__default_atomic__ 		          = true

      # explicitly include vars as atomic/non-atomic
      @__rpersistence__includes__                     = Hash.new
      # explicitly exclude vars from being atomic/non-atomic
      @__rpersistence__excludes__                     = Hash.new

      # explicitly declare atomic/non-atomic attributes
      # anything included here is also in @__rpersistence__includes__
      @__rpersistence__include_as_atomic__            = Hash.new
      @__rpersistence__include_as_non_atomic__        = Hash.new

      # explicitly exclude atomic/non-atomic attributes
      # anything excluded here is also in @__rpersistence__excludes__
      @__rpersistence__exclude_from_atomic__          = Hash.new
      @__rpersistence__exclude_from_all__             = Hash.new
    
      # attributes shared between two or more classes
      @__rpersistence__shared_attributes__            = Hash.new

    	@__rpersistence__complex_property__ 						= Hash.new
    	@__rpersistence__delete_cascades__ 							= Hash.new

    end
    
    return self
    
  end

end

###########################################################################################################
##############################################  Class  ####################################################
###########################################################################################################

class Class

  extend 	Rpersistence::ClassInstance::Persistence
	extend 	Rpersistence::ClassInstance::Persistence::Flat

	include Rpersistence::ObjectInstance::Persistence::Flat

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
