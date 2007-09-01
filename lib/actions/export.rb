module ActiveScaffold::Actions
  module Export
    def self.included(base)
      base.before_filter :export_authorized?, :only => [:export]
      base.before_filter :store_export_session_info
    end
    
    def store_export_session_info
      active_scaffold_session_storage[:export] ||= {}
      active_scaffold_session_storage[:export][:search] = params[:search] if !params[:search].nil? || params[:commit] == as_('Search')
    end

    def export
      do_export

      response.headers['Content-Disposition'] = "attachment; filename=#{self.controller_name}.csv"
      render :partial => 'export_csv', :content_type => Mime::CSV, :status => response_status 
    end

    protected

    # The actual algorithm to do the export
    def do_export
      active_scaffold_config.list.empty_field_text = active_scaffold_config.export.empty_field_text
      includes_for_export_columns = active_scaffold_config.export.columns.collect{ |c| c.includes }.flatten.uniq.compact
      self.active_scaffold_joins.concat includes_for_export_columns

      options = {:sorting => active_scaffold_config.list.user.sorting}

      params[:search] = active_scaffold_session_storage[:export][:search]
      do_search

      @records = find_page(options);
    end

    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def export_authorized?
      authorized_for?(:action => :read)
    end
  end
end
