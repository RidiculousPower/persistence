
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------  Rpersistence Atomic Cursor  ----------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence::Cursor::Atomic < Rpersistence::Cursor

	#############
	#  persist  #
	#############

	def persist( key )
		return super.attr_atomic!
	end

	###########
	#  first  #
	###########
	
	def first( count = 1 )
	  first_values = super
	  if first_values.is_a?( Array )
	    first_values.each do |this_value|
        this_value.attr_atomic!
      end
    elsif first_values
  	  first_values.attr_atomic!
    end
		return first_values
	end

	#############
	#  current  #
	#############
	
	def current
	  current_value = super
	  current_value.attr_atomic! if current_value
	  return current_value
	end

	##########
	#  next  #
	##########
	
	def next( count = 1 )
	  next_values = super
	  if next_values.is_a?( Array )
	    next_values.each do |this_value|
        this_value.attr_atomic!
      end
    elsif next_values
  	  next_values.attr_atomic!
    end
		return next_values
	end

end
