
###
# Convenience module for extending object of any type with persistence capabilities.
#
# If object is a {::Bignum}, {::Fixnum}, {::Complex}, {::Rational}, {::TrueClass}, {::FalseClass}, 
# {::String}, {::Symbol}, {::Regexp}, or {::NilClass} then object will include 
# {::Persistence::Object::Flat Persistence::Object::Flat}.
#
# If object is a File then object will include {::Persistence::Object::Flat::File Persistence::Object::Flat::File}.
#
# If object is an Array then object will include {::Persistence::Object::Complex::Array Persistence::Object::Complex::Array}.
#
# If object is a Hash then object will include {::Persistence::Object::Complex::Hash Persistence::Object::Complex::Hash}.
#
# If object is any other class then object will include {::Persistence::Object::Complex Persistence::Object::Complex}.
#
module ::Persistence::Object
  
  extend ::Persistence::Object::Autodetermine
  
end
