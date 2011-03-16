
module Rpersistence::Klass::Flat

	include Rpersistence::Klass::Object

  ##############
  #  extended  #
  ##############

  def extended( class_or_module )

  end

  #############
  #  persist  #
  #############
  
	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
  def persist( *args )

		port, bucket, property_name = Rpersistence.parse_persist_args( args )
		
    persistence_value  = port.adapter.get_flat_object_from_persistence_port( bucket, property_name )

    return persistence_value

  end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  private
  
end

class Bignum
	extend Rpersistence::Klass::Flat
end

class Fixnum
	extend Rpersistence::Klass::Flat
end

class Complex
	extend Rpersistence::Klass::Flat
end

class Rational
	extend Rpersistence::Klass::Flat
end

class Float
	extend Rpersistence::Klass::Flat
end

class TrueClass
	extend Rpersistence::Klass::Flat
end
class FalseClass
	extend Rpersistence::Klass::Flat
end

class Class
	extend Rpersistence::Klass::Flat
end

class String
	extend Rpersistence::Klass::Flat
end

class Symbol
	extend Rpersistence::Klass::Flat
end

class Regexp
	extend Rpersistence::Klass::Flat
end

class File
	extend Rpersistence::Klass::Flat
end

class NilClass
	extend Rpersistence::Klass::Flat
end

