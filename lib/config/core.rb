module ActiveScaffold::Config
  class Core
    # configures where the active_scaffold_tools plugin itself is located. there is no instance version of this.
    cattr_accessor :tools_plugin_directory
    @@tools_plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]

    cattr_accessor :left_handed
    @@left_handed = false
    
    cattr_accessor :upper_case_form_fields
    @@upper_case_form_fields = false

    # the active_scaffold_tools template path
    def template_search_path_with_tools(frontend = self.frontend)
      search_path = template_search_path_without_tools

      # Insert ourselves before active_scaffold
      new_search_path = []
      new_search_path << search_path.slice(0)
      new_search_path << "../../vendor/plugins/#{ActiveScaffold::Config::Core.tools_plugin_directory}/frontends/default/views/left_handed" if self.left_handed
      new_search_path << "../../vendor/plugins/#{ActiveScaffold::Config::Core.tools_plugin_directory}/frontends/default/views"
      new_search_path << search_path.slice(1..search_path.length)

      return new_search_path.flatten
    end
    alias_method_chain :template_search_path, :tools

    ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:print_list] = :get

    def columns_by_key_value(*args)
      val = args.collect {|a| a.collect {|value| value.is_a?(Array) ? value.first.keys.to_s.to_sym : value.to_sym}}
      val.flatten!
      @columns._inheritable = val.collect {|c| c}
      # Add virtual columns
      @columns << val.collect {|c| c unless @columns[c.to_sym]}.compact
      args.flatten!
      field_search_columns = []
      args.each do |arg|
        if arg.is_a?(Hash)
          arg.each do |column_name, values|
            @columns.add(column_name)
            field_search_columns << column_name
            if values.is_a?(Hash)
              values.each do |attr, value|
                attr = :form_ui if attr == :type
                case attr
                when :exclude, :except
                  if value.is_a?(Array)
                    value.each do |v| 
                      eval("#{v}.columns.exclude column_name") if @actions.include?(v.to_sym)
                      field_search_columns.delete(column_name) if v == :field_search
                    end
                  else
                    eval "#{value}.columns.exclude column_name" if @actions.include?(v.to_sym)
                    field_search_columns.delete(column_name) if value == :field_search
                  end
                when :reverse
                  @columns[column_name].association.send "#{attr}=", value                  
                else
                  @columns[column_name].send "#{attr}=", value
                end
              end
            end
          end
        else
          @columns.add arg
        end
      end
      #FIXME 2007-07-11 (EJM) Level=0 - field_search is a strange animal, :exclude is not working as the others
      field_search.columns = field_search_columns if @actions.include?(:field_search) and field_search_columns.length > 0
    end
    alias_method :has_columns, :columns_by_key_value
    
  end
end
