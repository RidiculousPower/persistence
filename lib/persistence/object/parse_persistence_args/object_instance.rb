
###
# @private
#
# Object-specific implementation for parsing persistence args.
#
# Internal helper for parsing args of the format: method, method( global_id ), method( index_name, value ),
#   method( index_instance, value ), method( index_name => value ), method( index_instance => value ).
#
module ::Persistence::Object::ParsePersistenceArgs::ObjectInstance
  
  include ::Persistence::Object::ParsePersistenceArgs

  ################################################
  #  parse_object_args_for_index_value_no_value  #
  ################################################
  
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
  def parse_object_args_for_index_value_no_value( args, require_value = false )
    
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

        case index_or_id

          when ::Symbol, ::String

            index = self.class.index( index_or_id, true )
            no_value = true

          when ::Hash

            key_value = index_or_id.values[ 0 ]
            index_name = index_or_id.keys[ 0 ]

            case index_name

              when ::Symbol, ::String

                index = self.class.index( index_name, true )

            end

            no_value = false
          
          else

            if index_or_id.respond_to?( :index_object )

              index = index_or_id
              no_value = true
            
            else

              # persistence_id - anything other than Symbol, String, Hash
              key_value = args[ 0 ]
              no_value = false

            end
          
        end
        
      when 2

        index_or_name = args[ 0 ]

        
        if index_or_name.respond_to?( :index_object )
          index = index_or_name
        elsif index_or_name
          index = self.class.index( index_or_name, true )
        end
        
        key_value = args[ 1 ]

        no_value = false

      else

        raise 'Unexpected arguments ' << args.inspect + '.'

    end
    
    # if we have a file we need to persist it like we would a sub-object
    if key_value.is_a?( ::File )
      key_value = process_file_key( key_value )
    end
    
    return index, key_value, no_value
    
  end
  
end
