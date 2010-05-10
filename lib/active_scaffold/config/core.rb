# Need to open the AS module carefully due to Rails 2.3 lazy loading
ActiveScaffold::Config::Core.class_eval do
  # For some not obvious reasons, the class variables need to be defined
  # *before* the cattr !!
  @@print_list_show_form = true
  @@print_list_allow_full_download = true
  @@print_list_default_full_download = true
  @@print_list_empty_field_text = '-'
  @@print_list_maximum_rows = 10000
  @@print_list_font_size = 8
  @@print_list_header_text = ''
  cattr_accessor :print_list_show_form, :print_list_allow_full_download,
      :print_list_default_full_download,:print_list_empty_field_text,
      :print_list_maximum_rows, :print_list_font_size,
      :print_list_header_text


    ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:print_list] = :get
    ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:show_print_list] = :get
    ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:revision] = :get
    ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:next_revision] = :get
    ActionController::Resources::Resource::ACTIVE_SCAFFOLD_ROUTING[:collection][:previous_revision] = :get
end
