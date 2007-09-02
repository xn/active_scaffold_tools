module ActiveScaffold::Actions
  module Export
    include ActiveScaffold::Actions::PrintList
    def self.included(base)
      base.before_filter :export_authorized?, :only => [:export]
      base.before_filter :store_print_list_session_info
    end
    
    def export
      do_print_list(active_scaffold_config.export)

      response.headers['Content-Disposition'] = "attachment; filename=#{self.controller_name}.csv"
      render :partial => 'export_csv', :content_type => Mime::CSV, :status => response_status 
    end

    protected

    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def export_authorized?
      authorized_for?(:action => :read)
    end
  end
end
