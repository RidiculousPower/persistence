
class ::Persistence::Adapter::Abstract::Mock::User::DictionaryEntry < String
  
  include ::Persistence
  
  def populate
  
    replace( 'Some Other Word ' + rand( 100000000 ).to_s )
    
  end
  
end
