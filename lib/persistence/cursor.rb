
###
# Cursor class. Interface implementation provided in module so methods can be easily overridden.
#
class ::Persistence::Cursor
  
  include ::Enumerable

  include ::Persistence::Cursor::CursorInterface
  
end
