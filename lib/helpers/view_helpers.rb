module ActiveScaffold
  module Helpers
    module ViewHelpers
      # Add the tools plugin includes
      def active_scaffold_includes_with_tools(frontend = :default)
        css = stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path('tools-stylesheet.css', frontend))
        css << stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path('tools-left-handed-stylesheet.css', frontend)) if ActiveScaffold::Config::Core.left_handed
        ie_css = stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path('tools-stylesheet-ie.css', frontend))
        active_scaffold_includes_without_tools + "\n" + css + "\n<!--[if IE]>" + ie_css + "<![endif]-->\n"
      end
      alias_method_chain :active_scaffold_includes, :tools

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
