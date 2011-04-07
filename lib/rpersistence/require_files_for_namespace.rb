
#---------------------------------------------------------------------------------------------------------#
#-----------------------------------------  Required Files  ----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

def class_hierarchized_files_for_namespace( constant_namespace, include_private_files = true , path_prefix = '' )
  
  namespaces  = paths_for_namespace( constant_namespace )
  
  files       = [ ]
  
  if path_prefix and path_prefix[ path_prefix.length - 1 ] != '/'
    path_prefix << '/'
  end
  
  namespaces.each do |this_namespace|
    
    this_namespace = this_namespace.to_s.split( '::' )

    # we want to see if we have:

    # * prefix + namespace + .rb
    class_or_module_file          = path_prefix + this_namespace.join( '/' ) + '.rb'
    files.push( class_or_module_file )

    # * prefix + namespace + Private + namespace_base + .rb
    if include_private_files
      this_namespace.insert( this_namespace.length - 1, 'Private' )
      class_or_module_private_file  = path_prefix + this_namespace.join( '/' ) + '.rb'
      files.push( class_or_module_private_file )
    end
    
  end

  return files
  
end

def paths_for_namespace( constant_namespace, accumulated_paths = [ ] )

  accumulated_paths.push( constant_namespace )

  if constant_namespace.respond_to?( :constants )

    # get constants in namespace
    constants = constant_namespace.constants - Object.constants

    # for each constant in namespace 
    constants.each do |this_constant|
      paths_for_namespace( constant_namespace.const_get( this_constant ), accumulated_paths )
    end

  end
  
  return accumulated_paths

end
