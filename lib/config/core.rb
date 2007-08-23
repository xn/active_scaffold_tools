module ActiveScaffold::Config
  class Core
    # configures where the active_scaffold_tools plugin itself is located. there is no instance version of this.
    cattr_accessor :tools_plugin_directory
    @@tools_plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]

    # the active_scaffold_tools template path
    def template_search_path_with_tools
      search_path = template_search_path_without_tools
      search_path << "../../vendor/plugins/#{ActiveScaffold::Config::Core.tools_plugin_directory}/frontends/default/views"
      return search_path
    end
    alias_method_chain :template_search_path, :tools

    ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:print_list] = :get

  end
end
