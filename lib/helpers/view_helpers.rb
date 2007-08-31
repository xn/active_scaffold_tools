module ActiveScaffold
  module Helpers
    module ViewHelpers
      # Add the tools plugin includes
      def active_scaffold_includes_with_tools(frontend = :default)
        js = javascript_include_tag(ActiveScaffold::Config::Core.asset_path('input_box.js', frontend))
        js << javascript_include_tag(ActiveScaffold::Config::Core.asset_path('usa_phone.js', frontend))
        css = stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path('tools-stylesheet.css', frontend))
        css << stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path('tools-left-handed-stylesheet.css', frontend)) if ActiveScaffold::Config::Core.left_handed
        ie_css = stylesheet_link_tag(ActiveScaffold::Config::Core.asset_path('tools-stylesheet-ie.css', frontend))
        active_scaffold_includes_without_tools + "\n" + js + "\n" + css + "\n<!--[if IE]>" + ie_css + "<![endif]-->\n"
      end
      alias_method_chain :active_scaffold_includes, :tools

    end
  end
end
