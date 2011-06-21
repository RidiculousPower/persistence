
#-----------------------------------------------------------------------------------------------------------#
#----------------------------------------  Rpersistence Cursor  --------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

require_relative '../../lib/rpersistence.rb'

describe Rpersistence::Cursor do

  class Rpersistence::Cursor
    def object_for_id_or_persistence_hash( id_or_hash )
      return id_or_hash
    end
  end

	##############
	#  has_key?  #
	##############

  it 'can report whether a key exists and set its position to the key if it does' do
    mock_adapter = Rpersistence.enable_port( :mock_adapter, Rpersistence::Adapter::Mock.new )
    cursor = Rpersistence::Cursor.new( :mock_adapter, 'bucket' )
    cursor.instance_variable_get( :@cursor_in_adapter ).keys = [ 1, 2, 3, 4 ]
    cursor.has_key?( 2 ).should == true
  end

	###########
	#  first  #
	###########
	
  it 'can set its position to the first key' do
    mock_adapter = Rpersistence.enable_port( :mock_adapter, Rpersistence::Adapter::Mock.new )
    cursor = Rpersistence::Cursor.new( :mock_adapter, 'bucket' )
    cursor.instance_variable_get( :@cursor_in_adapter ).keys = [ 1, 2, 3, 4 ]
    cursor.first.should == 1
    cursor.first( 2 ).should == [ 1, 2 ]
  end

	#############
	#  current  #
	#############
	
  it 'can return the current key' do
    mock_adapter = Rpersistence.enable_port( :mock_adapter, Rpersistence::Adapter::Mock.new )
    cursor = Rpersistence::Cursor.new( :mock_adapter, 'bucket' )
    cursor.instance_variable_get( :@cursor_in_adapter ).keys = [ 1, 2, 3, 4 ]
    cursor.first
    cursor.current.should == 1
  end

	##########
	#  next  #
	##########
	
  it 'can set its position to the next key' do
    mock_adapter = Rpersistence.enable_port( :mock_adapter, Rpersistence::Adapter::Mock.new )
    cursor = Rpersistence::Cursor.new( :mock_adapter, 'bucket' )
    cursor.instance_variable_get( :@cursor_in_adapter ).keys = [ 1, 2, 3, 4 ]
    cursor.first.should == 1
    cursor.next.should == 1
    cursor.next.should == 2
    cursor.next( 2 ).should == [ 3, 4 ]
  end

  ##########
  #  each  #
  ##########

  it 'can iterate each record' do
    mock_adapter = Rpersistence.enable_port( :mock_adapter, Rpersistence::Adapter::Mock.new )
    cursor = Rpersistence::Cursor.new( :mock_adapter, 'bucket' )
    cursor.instance_variable_get( :@cursor_in_adapter ).keys = [ 1, 2, 3, 4 ]
    enum = cursor.each
    enum.is_a?( Enumerator ).should == true
    enum.next.should == 1
    enum.peek.should == 2
  end

end
