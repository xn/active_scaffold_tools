module ActiveScaffold::Actions
  module PrintList
    def self.included(base)
      base.before_filter :print_list_authorized?, :only => [:print_list]
      base.before_filter :init_session_var

      as_print_list_plugin_path = File.join(Rails.root, 'vendor', 'plugins', ActiveScaffold::Config::PrintList.plugin_directory, 'frontends', 'default' , 'views')

      base.add_active_scaffold_path as_print_list_plugin_path
    end

    def init_session_var
      session[:search] = params[:search] if !params[:search].nil? || params[:commit] == as_('Search')    
    end
    
    # display the customization form or skip directly to print
    def show_print_list
      print_list_config = active_scaffold_config.print_list
      respond_to do |wants|
        wants.html do
          if successful?
            render(:partial => 'show_print_list', :layout => true)
          else
            return_to_main
          end
        end
        wants.js do
          render(:partial => 'show_print_list', :layout => false)
        end
      end
    end

    # if invoked directly, will use default configuration
    def print_list
      print_list_config = active_scaffold_config.print_list
      if params[:print_list_columns].nil?
        print_list_columns = {}
        print_list_config.columns.each { |col|
          print_list_columns[col.name.to_sym] = 1
        }
      end
      options = {
        :print_list_columns => print_list_columns,
        :full_download => print_list_config.default_full_download.to_s,
        :font_size => print_list_config.font_size,
        :empty_field_text => print_list_config.empty_field_text,
        :maximum_rows => print_list_config.maximum_rows,
        :header_text => print_list_config.header_text
      }
      params.reverse_merge!(options)

      find_items_for_print_list

      respond_to do |type|
        type.html {
          render(:partial => 'print_list', :layout => false, :locals => { :print_list_config => active_scaffold_config.print_list })
        }
        type.pdf {
          prawnto :prawn => {}, :inline => false, :filename => @title + Time.now.to_datetime.strftime(" %Y-%m-%d-%I-%M%p") + '.pdf'
          @print_list_config = active_scaffold_config.print_list
          render :layout => false
        }
      end
    end

    protected

    # The actual algorithm to do the print
    def find_items_for_print_list
      print_list_config = active_scaffold_config.print_list
      print_list_columns = print_list_config.columns.reject { |col| params[:print_list_columns][col.name.to_sym].nil? }

      includes_for_print_list_columns = print_list_columns.collect{ |col| col.includes }.flatten.uniq.compact
      self.active_scaffold_includes.concat includes_for_print_list_columns

      find_options = { :sorting => active_scaffold_config.list.user.sorting }
      params[:search] = session[:search]
      do_search rescue nil
      params[:segment_id] = session[:segment_id]
      do_segment_search rescue nil
      unless params[:full_download] == 'true'
        if params[:maximum_rows].to_i > active_scaffold_config.list.user.per_page.to_i
          find_options.merge!({
              :per_page => params[:maximum_rows].to_i,
              :page => 1
            })
        else
          find_options.merge!({
              :per_page => active_scaffold_config.list.user.per_page,
              :page => active_scaffold_config.list.user.page
            })
        end
      end
      @print_list_columns = params[:print_list_columns]
      @full_download = params[:full_download]
      @font_size = params[:font_size].to_i
      @empty_field_text = params[:empty_field_text]
      @maximum_rows = params[:maximum_rows].to_i
      @header_text = params[:header_text]
      @print_list_config = print_list_config
      @print_list_columns = print_list_columns
      @records = find_page(find_options).items
    end
    
    # The default security delegates to ActiveRecordPermissions.
    # You may override the method to customize.
    def print_list_authorized?
      authorized_for?(:action => :read)
    end
    
  end
end