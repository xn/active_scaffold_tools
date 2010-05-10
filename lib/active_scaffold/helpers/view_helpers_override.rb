ActiveScaffold::Helpers::ViewHelpers.module_eval do
  # Add the tools plugin includes

  def active_scaffold_stylesheets_with_print_list(frontend = :default)
    active_scaffold_stylesheets_without_print_list.to_a << ActiveScaffold::Config::Core.asset_path("tools-stylesheet.css", frontend)
  end
  alias_method_chain :active_scaffold_stylesheets, :print_list

  # Provides stylesheets for IE to include with +stylesheet_link_tag+
  def active_scaffold_ie_stylesheets_with_print_list(frontend = :default)
    active_scaffold_ie_stylesheets_without_print_list.to_a << ActiveScaffold::Config::Core.asset_path("tools-stylesheet-ie.css", frontend)
  end
  alias_method_chain :active_scaffold_ie_stylesheets, :print_list

  def active_scaffold_javascripts_with_print_list(frontend = :default)
    active_scaffold_javascripts_without_print_list.to_a << ActiveScaffold::Config::Core.asset_path("input_box.js", frontend)
    active_scaffold_javascripts_without_print_list.to_a << ActiveScaffold::Config::Core.asset_path("usa_phone.js", frontend)
  end
  alias_method_chain :active_scaffold_javascripts, :print_list

end

