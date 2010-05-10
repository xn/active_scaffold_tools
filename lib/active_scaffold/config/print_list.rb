module ActiveScaffold::Config
  class PrintList < Base    
    self.crud_type = :read

    def initialize(core_config)
      @core = core_config
    end

    # global level configuration
    # --------------------------
    # the ActionLink for this action
    cattr_accessor :link
    @@link = ActiveScaffold::DataStructures::ActionLink.new('show_print_list', :label => :print, :type => :collection, :security_method => :print_list_authorized?)

    # configures where the plugin itself is located. there is no instance version of this.
    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]


    # instance-level configuration
    # ----------------------------

    attr_writer :link
    def link
      @link ||= if show_form
        self.class.link.clone
      else
        ActiveScaffold::DataStructures::ActionLink.new('print_list', :label => :print, :type => :collection, :inline => false, :security_method => :print_list_authorized?, :popup => true)
      end
    end

    attr_writer :show_form, :allow_full_download, :default_full_download, :default_deselected_columns, :empty_field_text, :maximum_rows, :font_size, :header_text
    def show_form
      self.show_form = @core.print_list_show_form if @show_form.nil?
      @show_form
    end
    def allow_full_download
      self.allow_full_download = @core.print_list_allow_full_download if @allow_full_download.nil?
      @allow_full_download
    end
    def default_full_download
      self.default_full_download = @core.print_list_default_full_download if @default_full_download.nil?
      @default_full_download
    end
    def default_deselected_columns
      self.default_deselected_columns = [] if @default_deselected_columns.nil?
      @default_deselected_columns
    end
    def empty_field_text
      self.empty_field_text = @core.print_list_empty_field_text if @empty_field_text.nil?
      @empty_field_text
    end
    def maximum_rows
      self.maximum_rows = @core.print_list_maximum_rows if @maximum_rows.nil?
      @maximum_rows
    end
    def font_size
      self.font_size = @core.print_list_font_size if @font_size.nil?
      @font_size
    end
    def header_text
      self.header_text = @core.print_list_header_text if @header_text.nil?
      @header_text
    end

    
    # provides access to the list of columns specifically meant for this action to use
    def columns
      self.columns = @core.list.columns.collect {|c| c.name} unless @columns
      @columns
    end
    def columns=(val)
      @columns = ActiveScaffold::DataStructures::ActionColumns.new(*val)
      @columns.action = self
    end
  end
end
