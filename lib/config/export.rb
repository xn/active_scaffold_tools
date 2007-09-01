module ActiveScaffold::Config
  class Export < Base

    self.crud_type = :read

    def initialize(core_config)
      @core = core_config

      # inherit from global scope
      @empty_field_text = self.class.empty_field_text
      @delimiter = self.class.delimiter
      @force_quotes = self.class.force_quotes
      @skip_header = self.class.skip_header
    end

    # global level configuration
    # --------------------------
    # the ActionLink for this action
    cattr_reader :link
    @@link = ActiveScaffold::DataStructures::ActionLink.new('export', :label => 'Export', :type => :table, :security_method => :export_authorized?, :inline => false)
    
    cattr_accessor :empty_field_text
    @@empty_field_text = ''
    
    cattr_accessor :delimiter
    @@delimiter = ","
    
    cattr_accessor :force_quotes
    @@force_quotes = false
    
    cattr_accessor :skip_header
    @@skip_header = false

    # instance-level configuration
    # ----------------------------

    # what string to use when a field is empty
    attr_accessor :empty_field_text

    attr_accessor :delimiter
    
    attr_accessor :force_quotes
    
    attr_accessor :skip_header

    # provides access to the list of columns specifically meant for this action to use
    def columns
      self.columns = @core.columns._inheritable unless @columns
      @columns
    end
    def columns=(val)
      @columns = ActiveScaffold::DataStructures::ActionColumns.new(*val)
      @columns.action = self
    end
  end
end
