
#-----------------------------------------------------------------------------------------------------------#
#--------------------------------------  Rpersistence Singleton  -------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  ################################
  #  self.port_for_name_or_port  #
  ################################
  
  def self.port_for_name_or_port( persistence_port_or_name )
    persistence_port = nil
    if persistence_port_or_name.is_a?( String ) or persistence_port_or_name.is_a?( Symbol )
      persistence_port = port( persistence_port_or_name )
      persistence_port.name = persistence_port_or_name
    else
      persistence_port = persistence_port_or_name
    end
    return persistence_port
  end

  #########################################
  #  self.create_pending_index_for_class  #
  #########################################

  def self.create_pending_index_for_class( klass, attribute, permits_duplicates )
    @pending_indexes.push( PendingIndex.new( klass, attribute, permits_duplicates ) )
    return self
  end

  #################################
  #  self.create_pending_indexes  #
  #################################

  def self.create_pending_indexes( port )

    @pending_indexes.delete_if do |this_pending_index|

      should_delete = false

      if port.persists_classes.empty? or port.persists_classes.include?( this_pending_index.klass )

        unless port.adapter.has_index?( this_pending_index.klass, this_pending_index.attribute )

          port.adapter.create_index( this_pending_index.klass, 
                                     this_pending_index.attribute, 
                                     this_pending_index.permits_duplicates )

          this_pending_index.klass.instance_eval do
            index_persisted_objects( this_pending_index.attribute )
          end
          
        end

        should_delete = true

      end

      should_delete

    end

    return self

  end

end
