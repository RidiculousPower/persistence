
module ::Persistence::Object::Autodetermine

  ###################
  #  self.extended  #
  ###################
  
  def self.extended( persistence_object_module )

    persistence_object_module.extend ModuleCluster::Define::Block::ClassOrModuleOrInstance
    
    persistence_object_module.class_or_module_include do |class_or_module|

      # two types of objects: complex and flat
      # * complex objects persist ivars
      # * flat objects persist themselves (no ivars)
      #
      # if you want a different result, use the appropriate module directly
      # * ::Persistence::Complex
      # * ::Persistence::Flat

      # if we have a flat object, extend for flat object
      if class_or_module <= ::Array
        
        class_or_module.module_eval do
          include ::Persistence::Object::Complex::Array
        end
        
      elsif class_or_module <= ::Hash
        
        class_or_module.module_eval do
          include ::Persistence::Object::Complex::Hash
        end
        
      elsif  class_or_module <= ::Bignum      or
             class_or_module <= ::Fixnum      or
             class_or_module <= ::Complex     or
             class_or_module <= ::Rational    or
             class_or_module <= ::TrueClass   or
             class_or_module <= ::FalseClass  or
             class_or_module <= ::String      or
             class_or_module <= ::Symbol      or
             class_or_module <= ::Regexp      or
             class_or_module <= ::File        or
             class_or_module <= ::NilClass

        class_or_module.module_eval do
          include ::Persistence::Object::Flat
        end

      # otherwise extend as a complex object
      else

        class_or_module.module_eval do
          include ::Persistence::Object::Complex
        end

      end

    end

    persistence_object_module.class_or_module_or_instance_extend do
      raise 'Persistence does not expect to be used without class-level support.'
    end
    
  end
  
end
