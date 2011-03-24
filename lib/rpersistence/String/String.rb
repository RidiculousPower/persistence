
class String
  
  def is_variable_name?
    return slice( 0, 1 ) == '@'
  end
  
end
