
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------------  Rpersistence Port  ---------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

class Rpersistence::Port

  attr_accessor :name, :enabled, :adapter, :persists_classes

  ################
  #  initialize  #
  ################

  def initialize( port_name, adapter_instance, *persists_classes )
    @name             = port_name
    @adapter          = adapter_instance
    @persists_classes = persists_classes
  end

  ############
  #  enable  #
  ############

  def enable
    @enabled = true
    @adapter.enable
    return self
  end
  
  #############
  #  disable  #
  #############

  def disable
    @enabled  = false
    adapter.disable
    return self
  end

  ############################
  #  set_to_persist_classes  #
  ############################

  def set_to_persist_classes( *args )
    args.each do |this_arg|
      # array
      if this_arg.is_a?( Array )
        classes_hash.each do |this_class|
          @persists_classes[ this_class ] = :read_write
        end
      # hash
      elsif this_arg.is_a?( Hash )
        classes_hash.each do |this_class, read_write_status|
          @persists_classes[ this_class ] = read_write_status
        end
      # klass
      else
        @persists_classes[ this_class ] = :read_write        
      end
    end
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
        return @persists_classes[ klass ]
      end
    end
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

  ##########################
  #  persist_file_by_path  #
  ##########################

  def persist_file_by_path
    @__rpersistence__persists_file_by_path__ =  true
    return self
  end

  ###########################
  #  persist_file_contents  #
  ###########################

  def persist_file_contents
    @__rpersistence__persists_file_by_path__ =  false
    return self
  end

  ############################
  #  persists_file_by_path?  #
  ############################

  def persists_file_by_path?
    return @__rpersistence__persists_file_by_path__
  end
  
end

