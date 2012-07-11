
###
# @private
###
# Module used internally to extend Persistence and Persistence::Object to automatically determine what type of object
#   (of types: Complex, Flat, Hash, Array, File) module is being included in, and to include the appropriate
#   corresponding module branch.
module ::Persistence::Object::Autodetermine

  ###################
  #  self.extended  #
  ###################
  
  def self.extended( persistence_object_module )

    persistence_object_module.extend( ::Module::Cluster )
    persistence_object_module.cluster( :persistence ).after_include( :class, :module ) do |class_or_module|
      
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

    persistence_object_module.cluster( :persistence ).before_extend( :class, :module ) do
      raise 'Persistence does not expect to be used without class-level support.'
    end
    
  end
  
end
