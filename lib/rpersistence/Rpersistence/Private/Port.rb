
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------------  Rpersistence Port  ---------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence::Port

  ####################################
  #  internal_persists_classes_for?  #
  ####################################

	def internal_persists_classes_for?( read_write_setting, *args )
    args.each do |this_arg|
      # array
      if this_arg.is_a?( Array )
        return_array = [ ]
        classes_hash.each do |this_class|
          return return_array.push( persists_classes?( this_class ) )
        end
        return return_array
      # hash
      elsif this_arg.is_a?( Hash )
        return_hash = { }
        classes_hash.each do |this_class, read_write_status|
           return_hash[ this_class ] = persists_classes?( this_class )
        end
        return return_hash
      # klass
      else
        return @persists_classes[ klass ] == read_write_setting
      end
    end
	end
  
end
