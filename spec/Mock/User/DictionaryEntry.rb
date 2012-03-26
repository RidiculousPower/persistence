
class Mock::User::DictionaryEntry < String
  
  include ::Rpersistence
  
  def populate
  
    replace( 'Some Other Word ' + rand( 100000000 ).to_s )
    
  end
  
end
