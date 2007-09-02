module ActiveScaffold::Actions
  module PrintList
    def store_print_list_session_info
      active_scaffold_session_storage[:print_list] ||= {}
      active_scaffold_session_storage[:print_list][:search] = params[:search] if !params[:search].nil? || params[:commit] == as_('Search')
    end
    
    protected
    
    def do_print_list(print_list_config)
      active_scaffold_config.list.empty_field_text = print_list_config.empty_field_text
      includes_for_print_list_columns = print_list_config.columns.collect{ |c| c.includes }.flatten.uniq.compact
      self.active_scaffold_joins.concat includes_for_print_list_columns

      options = {:sorting => active_scaffold_config.list.user.sorting}

      params[:search] = active_scaffold_session_storage[:print_list][:search]
      do_search

      @records = find_page(options);
    end

  end
end