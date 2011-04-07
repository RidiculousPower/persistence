
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------- Object Inspection  ----------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Inspect
  
  #############
  #  inspect  #
  #############

#  def inspect
#
#    require 'pp'
#    
#    load_atomic_state
#    value_string_array              = instance_variables_hash.collect{ |property_name, property_value| property_name.to_s + '=' + property_value.pretty_inspect.chomp.to_s }
#    instance_variable_names_values  = value_string_array.join( ' ' )
#    instance_variable_string        = ( instance_variables_hash.empty?  ? '' : ' ' + instance_variable_names_values )
#
#    inspect_string = nil
#
#    if self.class == Class or self.is_a?( Class ) or self.class == Module or self.is_a?( Module ) or self.class == Fixnum or self.class == Bignum
#      inspect_string  = self.to_s
#    elsif self.class == TrueClass
#      inspect_string  = 'true'
#    elsif self.class == FalseClass
#      inspect_string  = 'false'
#    else
#      inspect_string  = '<' + self.class.to_s + ':' + self.__id__.to_s + ':' + persistence_id.to_s + instance_variable_string + '>'
#    end
#    
#    return inspect_string
#        
#  end
  
end