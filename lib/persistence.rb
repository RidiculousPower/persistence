
require 'module-cluster'
#require 'cascading-configuration'
require_relative '../../ruby/cascading-configuration/lib/cascading-configuration.rb'
 
# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

# post-require setup in Ruby namespace
require_relative './setup.rb'

###
# Primary interface for enabling persistence for a given object type.
#
module ::Persistence
  
  extend ::Persistence::Port::Controller
  
  extend ::Persistence::Object::Autodetermine

  extend ::Persistence::Object::Flat::File::FilePersistence
  
  persist_files_by_path!
  persist_file_paths_as_strings!
        
end

