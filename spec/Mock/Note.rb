
class Mock::Note
  
  include ::Rpersistence
  attr_atomic_accessor :date, :subject, :content
  
  def populate

    self.date = ::Date.today.to_s
    
    self.subject = 'Subject ' + rand( 100000000 ).to_s
    
    self.content = 'Content ' + rand( 100000000 ).to_s
    
  end
  
end
