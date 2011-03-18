module Rpersistence::Instance::Flat
	
	include Rpersistence::Instance::Object
	
  ##############
  #  persist!  #
  ##############

	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
	def persist!( *args )

		port, bucket, persistence_key = parse_persist_args( args )
				
		port.adapter.put_flat_object_to_persistence_port!( bucket, persistence_key, self )

		# return the object we're persisting
		return self
	
	end
	
end

class Bignum
	include Rpersistence::Instance::Flat
end

class Fixnum
	include Rpersistence::Instance::Flat
end

class Complex
	include Rpersistence::Instance::Flat
end

class Rational
	include Rpersistence::Instance::Flat
end

class Float
	include Rpersistence::Instance::Flat
end

class TrueClass
	include Rpersistence::Instance::Flat
end
class FalseClass
	include Rpersistence::Instance::Flat
end

class Class
	include Rpersistence::Instance::Flat
end

class String
	include Rpersistence::Instance::Flat
end

class Symbol
	include Rpersistence::Instance::Flat
end

class Regexp
	include Rpersistence::Instance::Flat
end

class File
	include Rpersistence::Instance::Flat
end

class NilClass
	include Rpersistence::Instance::Flat
end

