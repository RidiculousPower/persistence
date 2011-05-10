
module Rpersistence::Adapter::Support::PrimaryKey::Compound

  ########################################### Primary Key ###################################################

  #########################################
  #  primary_key_for_property_name        #
  #########################################

  def primary_key_for_property_name( object, property_name )

    primary_key_hash = nil

    object.instance_eval do
      primary_key_hash = [   persistence_id, 
                            persistence_locale, 
                            persistence_version, 
                            property_name, 
                            complex_property?( persistence_port, property_name ),
                            delete_cascades?( persistence_port, property_name ) ]
    end

    return primary_key_hash

  end

end
