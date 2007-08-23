module ActiveScaffold::Actions
  module PrintList
    def self.included(base)
      base.before_filter :print_list_authorized?, :only => [:row, :print_list]
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

    protected
    
    # def do_print_html
    #   @html = '<table cellpadding="0" cellspacing="0" border="1"><tr>'
    #   active_scaffold_config.list.columns.each do |column|
    #     @html << '<th'
    #     @html << "width=\"#{column.options[:print_width]}\"" if column.options[:print_width]
    #     @html << '>'
    #     @html << column.label
    #     @html << '</th>'
    #   end
    #   @html << '</tr></thead><tbody>'
    #   @records.each do |record|
    #     @html << '<tr>'
    #     active_scaffold_config.list.columns.each do |column|
    #       column_value = get_column_value(record, column)
    #       @html << '<td' 
    #       @html << "width=\"#{column.options[:print_width]}\"" if column.options[:print_width]
    #       @html << '>'
    #       @html << column_value
    #       @html << '</td>'
    #     end
    #     @html << '</tr>'
    #   end
    #   @html << '</tbody></table>'
    # end
    
    def do_print_list
      includes_for_print_list_columns = active_scaffold_config.print_list.columns.collect{ |c| c.includes }.flatten.uniq.compact
      self.active_scaffold_joins.concat includes_for_print_list_columns

      options = {:sorting => active_scaffold_config.print_list.user.sorting,}
      # paginate = (params[:format].nil?) ? (accepts? :html, :js) : [:html, :js].include?(params[:format])
      # if paginate
      #   options.merge!({
      #     :per_page => active_scaffold_config.print_list.user.per_page,
      #     :page => active_scaffold_config.print_list.user.page
      #   })
      # end
      # 
      page = find_page(options);
      if page.items.empty?
        page = page.pager.first
        active_scaffold_config.print_list.user.page = 1
      end
      @page, @records = page, page.items
    end

    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def print_list_authorized?
      authorized_for?(:action => :read)
    end
  end
end