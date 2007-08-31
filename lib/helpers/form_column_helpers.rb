module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a Form Column
    module FormColumns
      def active_scaffold_input_options_with_tools(column_name, scope = nil)
        options = {}
        column = active_scaffold_config.columns[column_name.to_sym]
        if active_scaffold_config.upper_case_form_fields and [:text, :string].include?(column.column.type) and column.form_ui.nil? and (!column.options.has_key?(:upper_case_form_fields) or column.options[:upper_case_form_fields] != false)
          options[:onchange] ||= ''
          options.merge!(:onchange => options[:onchange] + "ToUpper(this); return true;") 
        end
        active_scaffold_input_options_without_tools(column_name, scope = nil).merge(options)
      end
      alias_method_chain :active_scaffold_input_options, :tools

      def active_scaffold_column_usa_phone(column, record)
        number_to_phone(record[column.name].to_s)
      end

      def active_scaffold_input_usa_phone(column, options)
        column.description ||= as_("Ex. 111-333-4444")
    		text_field :record, column.name, options.merge(
                      :value => number_to_phone(@record[column.name].to_s),
                      :onblur => "PhoneDashAdd(this);return true;", 
        							:onchange => "NukeBadChars(this); return true;").merge(active_scaffold_input_text_options)
      end

      def active_scaffold_input_timezone(column, options)
        time_zone_select(:record, column.name)
      end

    end
  end
end
