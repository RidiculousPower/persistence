
module ::Persistence::Adapter::Abstract::Mock
end

basepath = 'mock_helpers'

files = [ 
  
  'bucket',
  'object',
  'port',
  
  'integration/note',
  'integration/notes_array',
  'integration/dictionary_hash',
  'integration/user',
  'integration/user/address',
  'integration/user/dictionary_entry',
  'integration/user/sub_account'
  
  ]

  files.each do |this_file|
    require_relative( File.join( basepath, this_file ) + '.rb' )
  end

  require_relative( basepath + '.rb' )
