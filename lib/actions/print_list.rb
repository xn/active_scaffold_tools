module ActiveScaffold::Actions
  module PrintList
    def self.included(base)
      base.before_filter :print_list_authorized?, :only => [:print_list, :print_pdf]
      base.before_filter :store_print_list_session_info
    end

    def store_print_list_session_info
      active_scaffold_session_storage[:print_list] ||= {}
      active_scaffold_session_storage[:print_list][:search] = params[:search] if !params[:search].nil? || params[:commit] == as_('Search')
    end

    def print_list
      do_print_list

      respond_to do |type|
        type.html {
          render :action => 'print_list', :layout => false
        }
        type.xml { render :xml => response_object.to_xml, :content_type => Mime::XML, :status => response_status }
        type.json { render :text => response_object.to_json, :content_type => Mime::JSON, :status => response_status }
        type.yaml { render :text => response_object.to_yaml, :content_type => Mime::YAML, :status => response_status }
      end
    end

    def print_pdf
      do_print_list
      respond_to do |type|
        type.html {
          @html = render_to_string(:action => "print_list", :layout => false)
          render :action => 'print_pdf', :layout => false      
        }
      end
    end
    
    protected
    
    def do_print_list
      active_scaffold_config.list.empty_field_text = active_scaffold_config.print_list.empty_field_text
      includes_for_print_list_columns = active_scaffold_config.print_list.columns.collect{ |c| c.includes }.flatten.uniq.compact
      self.active_scaffold_joins.concat includes_for_print_list_columns

      options = {:sorting => active_scaffold_config.list.user.sorting}

      params[:search] = active_scaffold_session_storage[:print_list][:search]
      do_search

      @records = find_page(options);
    end

    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def print_list_authorized?
      authorized_for?(:action => :read)
    end
  end
end