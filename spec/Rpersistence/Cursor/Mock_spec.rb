
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------  Rpersistence Cursor Mock  ------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../../lib/rpersistence.rb'

describe Rpersistence::Cursor::Mock do

	##############
	#  has_key?  #
	##############

	it 'it can report if it has a key' do
	  cursor = Rpersistence::Cursor::Mock.new( :adapter, 'bucket' )
	  cursor.keys = [ 1, 2, 3, 4 ]
	  cursor.has_key?( 1 ).should == true
	  cursor.next.should == 2
	  cursor.has_key?( 3 ).should == true
	  cursor.next.should == 4	  
  end

	###########
	#  first  #
	###########
	
	it 'can return its first key' do
	  cursor = Rpersistence::Cursor::Mock.new( :adapter, 'bucket' )
	  cursor.keys = [ 1, 2, 3, 4 ]
	  cursor.first.should == 1
  end

	#############
	#  current  #
	#############
	
	it 'can return the current key' do
	  cursor = Rpersistence::Cursor::Mock.new( :adapter, 'bucket' )
	  cursor.keys = [ 1, 2, 3, 4 ]
	  cursor.first.should == 1
	  cursor.current.should == 1
  end

	##########
	#  next  #
	##########
	
	it 'can return the next key' do
	  cursor = Rpersistence::Cursor::Mock.new( :adapter, 'bucket' )
	  cursor.keys = [ 1, 2, 3, 4 ]
	  cursor.first.should == 1
	  cursor.current.should == 1
	  cursor.next.should == 1
	  cursor.next.should == 2
	  cursor.current.should == 2
  end
  
end
