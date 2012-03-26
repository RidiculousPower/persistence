
module ::Rpersistence
  
  extend ModuleCluster

  class_or_module_include do |class_or_module|
    
    # two types of objects: complex and flat
    # * complex objects persist ivars
    # * flat objects persist themselves (no ivars)
    
    # if we have a flat object, extend for flat object
    if  class_or_module.is_a?( Bignum )                                              or
        class_or_module.is_a?( Fixnum )                                              or
        class_or_module.is_a?( Complex )                                             or
        class_or_module.is_a?( Rational )                                            or
        class_or_module.is_a?( TrueClass )                                           or
        class_or_module.is_a?( FalseClass )                                          or
        class_or_module.is_a?( String )                                              or
        class_or_module.is_a?( Symbol )                                              or
        class_or_module.is_a?( Regexp )                                              or
        class_or_module.is_a?( File )                                                or
        class_or_module.is_a?( NilClass )
      
      class_or_module.module_eval do
        include ::Rpersistence::Flat
      end
      
    # otherwise extend as a complex object
    else

      class_or_module.module_eval do
        include ::Rpersistence::Complex
      end
      
    end
        
    # if you want a different result, use the appropriate module directly
    # * ::Rpersistence::Complex
    # * ::Rpersistence::Flat
    
  end
  
  class_or_module_or_instance_extend do
    raise 'Rpersistence does not expect to be used without class-level support.'
  end
    
end
