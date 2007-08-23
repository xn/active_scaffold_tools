module ActiveScaffold::Config
  class Core
    # configures where the active_scaffold_tools plugin itself is located. there is no instance version of this.
    cattr_accessor :tools_plugin_directory
    @@tools_plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]

    # the active_scaffold_tools template path
    def template_search_path_with_tools(frontend = self.frontend)
      search_path = template_search_path_without_tools

      # Insert ourselves before active_scaffold
      new_search_path = []
      new_search_path << search_path.slice(0)
      new_search_path << "../../vendor/plugins/#{ActiveScaffold::Config::Core.tools_plugin_directory}/frontends/default/views"
      new_search_path << search_path.slice(1..search_path.length)

      return new_search_path.flatten
    end
    alias_method_chain :template_search_path, :tools

    ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:print_list] = :get

  end
end
