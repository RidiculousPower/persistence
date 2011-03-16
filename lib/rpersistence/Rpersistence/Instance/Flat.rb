module Rpersistence::Instance::Flat
	
	include Rpersistence::Instance::Object
	
  ##############
  #  persist!  #
  ##############

	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
	def persist!( *args )

		port, bucket, property_name = Rpersistence.parse_persist_args( args )
		
		# store bucket and key for simple reference later
		# any object in Ruby can have ivars, so this is legit
		# also, this function uniquely handles persistence for this object, so ivars we set here will not be accidentally persisted
		@__rpersistence_bucket__ = bucket
		@__rpersistence_key__    = property_name
				
		#	with a flat object we have only one value, so we need a key specified to use as the property name
		#	the flat object still gets an object ID; treating the key as the property name allows retrieval
		# to be treated the same for flat objects and object properties
		port.adapter.put_flat_object_to_persistence_port!( port, bucket, property_name, self )
		
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

