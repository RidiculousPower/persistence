
###
# Subclass of {::String} used for persisting file paths and automatically re-creating File instances from them.
#
class ::Persistence::Object::Flat::File::Path < ::String

  attr_accessor :mode
  
end