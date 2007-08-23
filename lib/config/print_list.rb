module ActiveScaffold::Config
  class PrintList < Base
    
    self.crud_type = :read

    def initialize(core_config)
      @core = core_config

      # inherit from global scope
      @empty_field_text = self.class.empty_field_text
    end

    # what string to use when a field is empty
    cattr_accessor :empty_field_text
    @@empty_field_text = '-'

    cattr_reader :link
    @@link = ActiveScaffold::DataStructures::ActionLink.new('print_list', :label => 'Print List', :type => :table, :security_method => :print_list_authorized?, :popup => true)
    
    # instance-level configuration
    # ----------------------------

    # provides access to the list of columns specifically meant for the Table to use
    def columns
      self.columns = @core.columns._inheritable unless @columns # lazy evaluation
      @columns
    end
    def columns=(val)
      @columns = ActiveScaffold::DataStructures::ActionColumns.new(*val)
      @columns.action = self
    end

    # what string to use when a field is empty
    attr_accessor :empty_field_text

    # the label for this List action. used for the header.
    attr_writer :label
    def label
      @label ? as_(@label) : @core.label
    end

    attr_accessor :header_image
    attr_accessor :header_size
    attr_accessor :header_text
    
    def print_format=(value = :pdf)
      if value.to_s.downcase.to_sym == :pdf
        @@link.action = 'print_pdf'
        @@link.label = 'Print PDF'
      else
        @@link.action = 'print_list'
        @@link.label = 'Print List'
      end
    end
  end
end
