
require 'module-cluster'

require 'cascading-configuration'
#require_relative '../../ruby/cascading-configuration/lib/cascading-configuration.rb'
 
# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

###
# Primary interface for enabling persistence for a given object type.
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
module ::Persistence
  
  extend ::Persistence::Port::Controller
  
  extend ::Persistence::Object::Autodetermine

  extend ::Persistence::Object::Flat::File::FilePersistence
  
  persist_files_by_path!
  persist_file_paths_as_strings!
        
end

