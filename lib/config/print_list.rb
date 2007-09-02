module ActiveScaffold::Config
  class PrintList < Base
    
    self.crud_type = :read

    def initialize(core_config)
      @core = core_config

      # inherit from global scope
      @empty_field_text = self.class.empty_field_text
    end

    # global level configuration
    # --------------------------
    # the ActionLink for this action
    
    cattr_accessor :empty_field_text
    @@empty_field_text = '-'
    
    # instance-level configuration
    # ----------------------------
    # the ActionLink for this action
    attr_accessor :link

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
    
  end
end
