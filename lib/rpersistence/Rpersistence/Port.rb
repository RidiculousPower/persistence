
class Rpersistence::Port

  attr_accessor :enabled

  ############
  #  enable  #
  ############

	def enable
		@enabled = true
	end
	
  #############
  #  disable  #
  #############

	def disable
		@enabled  = false
	end

  ############################
  #  set_to_persist_classes  #
  ############################

	def set_to_persist_classes( *args )
	  classes_array = nil
	  classes_hash  = nil
	  klass         = nil
    Rargs.define_and_parse( args ) do
      parameter_set(   parameter(   match_class(  klass ),
                                    match_array(  classes_array ),
                                    match_hash(   classes_hash ) )
    end
    do
      if klass
        @persists_classes[ this_class ] = :read_write        
      elsif classes_array
        classes_hash.each |this_class|
          @persists_classes[ this_class ] = :read_write
        end
      elsif classes_hash
        classes_hash.each |this_class, read_write_status|
          @persists_classes[ this_class ] = read_write_status
        end
      end
    end while Rargs.parse
	end

  ######################
  #  persists_classes  #
  ######################

	def persists_classes
		return @persists_classes
	end

  #####################################
  #  persists_read_write_for_classes  #
  #####################################

	def persists_write_for_classes
		return @persists_classes.select { |this_class, read_write_status| read_write_status == :read_write }
	end

  ###############################
  #  persists_read_for_classes  #
  ###############################

	def persists_read_for_classes
		return @persists_classes.select { |this_class, read_write_status| read_write_status == :read }
	end

  ################################
  #  persists_write_for_classes  #
  ################################

	def persists_write_for_classes
		return @persists_classes.select { |this_class, read_write_status| read_write_status == :write }
	end

  #######################
  #  persists_classes?  #
  #######################

	def persists_classes?( *args )
	  classes_array = nil
	  classes_hash  = nil
	  klass         = nil
    Rargs.define_and_parse( args ) do
      parameter_set(   parameter(   match_class(  klass ),
                                    match_array(  classes_array ),
                                    match_hash(   classes_hash ) )
    end
    do
      if klass
        return @persists_classes[ klass ]
      elsif classes_array
        return_array = [ ]
        classes_hash.each |this_class|
          return return_array.push( persists_classes?( this_class ) )
        end
        return return_array
      elsif classes_hash
        return_hash = { }
        classes_hash.each |this_class, read_write_status|
           return_hash[ this_class ] = persists_classes?( this_class )
        end
        return return_hash
      end
    end while Rargs.parse
	end

  ######################################
  #  persists_classes_for_read_write?  #
  ######################################

	def persists_classes_for_read_write?( *args )
    return internal_persists_classes_for( :read_write, *args )
  end

  ################################
  #  persists_classes_for_read?  #
  ################################

	def persists_classes_for_read?( *args )
    return internal_persists_classes_for( :read, *args )
  end

  #################################
  #  persists_classes_for_write?  #
  #################################

	def persists_classes_for_write?( *args )
    return internal_persists_classes_for( :write, *args)
  end
  
  ###########################################################################################################
  ###########################################  Private  #####################################################
  ###########################################################################################################

  private

  ####################################
  #  internal_persists_classes_for?  #
  ####################################

	def internal_persists_classes_for?( read_write_setting, *args )
	  classes_array = nil
	  classes_hash  = nil
	  klass         = nil
    Rargs.define_and_parse( args ) do
      parameter_set(   parameter(   match_class(  klass ),
                                    match_array(  classes_array ),
                                    match_hash(   classes_hash ) )
    end
    do
      if klass
        return @persists_classes[ klass ] == read_write_setting
      elsif classes_array
        return_array = [ ]
        classes_hash.each |this_class|
          return return_array.push( persists_classes?( this_class ) )
        end
        return return_array
      elsif classes_hash
        return_hash = { }
        classes_hash.each |this_class, read_write_status|
           return_hash[ this_class ] = persists_classes?( this_class )
        end
        return return_hash
      end
    end while Rargs.parse
	end
	
end

