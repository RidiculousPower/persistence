
###
# @private
#
# Internal helper for parsing args of the format: method, method( global_id ), method( index_name, value ),
#   method( index_instance, value ), method( index_name => value ), method( index_instance => value ).
module ::Persistence::Object::ParsePersistenceArgs

  #########################################
  #  parse_args_for_index_value_no_value  #
  #########################################
  
  ###
  # Parse *args for index, key_value, no_value.
  #
  # @param args [Array] An array of args of the format: method, method( global_id ), method( index_name, value ),
  #   method( index_instance, value ), method( index_name => value ), method( index_instance => value ).
  #
  # @param require_value [true,false] Whether key value must be provided; will throw exception if true and
  #   key value is not provided.
  #
  # @return [Array] Array containing index instance, key value, whether key value was provided.
  #
  def parse_args_for_index_value_no_value( args, require_value = false )
    
    # * nil
    #   - Cursor to primary bucket
    # * :index
    #   - Cursor to index
    # * :index => persistence_key
    #   - Object(s) for indexed key value
    
    index = nil
    key_value = nil
    no_value = nil
    case args.count

      when 0

        no_value = true
        if require_value
          raise ::Persistence::Exception::KeyValueRequired, 
                'Key value required.'
        end

      when 1

        index_or_id = args[ 0 ]
        if index_or_id.is_a?( Symbol ) or
           index_or_id.is_a?( String )

           index = indexes[ index_or_id ]
           unless index
             raise ::Persistence::Exception::ExplicitIndexRequired,
                   'Explicit index ' + index_or_id.to_s + ' did not exist.'
           end
           no_value = true
        
        elsif index_or_id.respond_to?( :index_object )
          
          index = index_or_id
          no_value = true
          
        elsif index_or_id.is_a?( Hash )
        
          key_value = index_or_id.values[ 0 ]
          index_name = index_or_id.keys[ 0 ]
          if index_name.is_a?( Symbol ) or
             index_name.is_a?( String )
             
            index = indexes[ index_name ]
            unless index
              raise ::Persistence::Exception::ExplicitIndexRequired,
                    'Explicit index :' + index_name.to_s + ' did not exist.'
            end

          end
          no_value = false

        else

          # persistence_id - anything other than Symbol, String, Hash
          key_value = args[ 0 ]
          no_value = false
          
        end
        
      when 2

        index_or_name = args[ 0 ]

        index = index_or_name.respond_to?( :index_object ) ? index_or_name : indexes[ index_or_name ]
        key_value = args[ 1 ]

        if ! index and ! key_value
          raise ::Persistence::Exception::ExplicitIndexRequired,
                'Index ' + index_or_name.to_s + ' did not exist.'
        end
        no_value = false

      else

        raise 'Unexpected arguments ' + args.inspect + '.'

    end
    
    # if we have a file we need to persist it like we would a sub-object
    if key_value.is_a?( File )
      key_value = process_file_key( key_value )
    end
    
    return index, key_value, no_value
    
  end

  ######################
  #  process_file_key  #
  ######################
  
  ###
  # Internal helper method to handle instances of File as key.
  #
  # @param file_key [File] File instance to process as key.
  #
  # @return [Persistence::Object::Flat::File::Path,Persistence::Object::Flat::File::Contents] Processed key.
  #
  def process_file_key( file_key )

    # do we have a file key? if so we need to replace it with File::Path or File::Contents

    processed_key = nil
    
    if persists_files_by_path?
      processed_key = ::Persistence::Object::Flat::File::Path.new( file_key.path )
    else
      starting_pos  = file_key.pos
      processed_key = ::Persistence::Object::Flat::File::Contents.new( file_key.readlines.join )
      file_key.pos  = starting_pos
    end
    
    return processed_key
    
  end
    
end
