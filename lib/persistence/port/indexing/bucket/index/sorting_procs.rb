
module ::Persistence::Port::Indexing::Bucket::Index::SortingProcs

  ########################
  #  init_sorting_procs  #
  ########################
  
  def init_sorting_procs( sorting_proc_or_sort_name, duplicates_sorting_proc_or_sort_name )
    
    if sorting_proc_or_sort_name
      
      if sorting_proc_or_sort_name.is_a?( Proc )

        @sorting_procs = sorting_proc_or_sort_name

      else
      
        @sorting_procs = sorting_proc_for_sort_name( sorting_proc_or_sort_name )
      
      end
      
    end
    
    if duplicates_sorting_proc_or_sort_name

      if duplicates_sorting_proc_or_sort_name.is_a?( Proc )
       
        @duplicates_sorting_procs = duplicates_sorting_proc_or_sort_name

      else

        @duplicates_sorting_procs = sorting_proc_for_sort_name( sorting_proc_or_sort_name )
      
      end

    end
    
  end

  ################################
  #  sorting_proc_for_sort_name  #
  ################################

  def sorting_proc_for_sort_name( sort_name )
    
    sorting_proc = nil
    
    case sort_name

      when :alpha

      when :numeric
      
      when :alpha_numeric
      
      when :numeric_alpha
    
      when :upper_lower

      when :lower_upper
    
      when :upper_lower_numeric
      
      when :lower_upper_numeric
      
      when :numeric_upper_lower
      
      when :numeric_lower_upper
    
      when :reverse_alpha
      
      when :reverse_alpha_numeric
      
      when :reverse_numeric_alpha

      when :reverse_upper_lower_numeric
      
      when :reverse_lower_upper_numeric
      
      when :reverse_numeric_upper_lower
      
      when :reverse_numeric_lower_upper
    
    end
  
    return sorting_proc
  
  end
  
end
