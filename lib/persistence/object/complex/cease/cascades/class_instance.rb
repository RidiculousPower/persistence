
module ::Persistence::Object::Complex::Cease::Cascades::ClassInstance

  ######################
  #  delete_cascades?  #
  ######################

  def delete_cascades?( variable_name )

    should_cascade = false

    accessor_name = variable_name.accessor_name

    if ( should_cascade = delete_cascades[ accessor_name ] ) == nil

      # default is to cascade deletes
      delete_cascades[ accessor_name ] = should_cascade = true

    end

    return should_cascade

  end

end
