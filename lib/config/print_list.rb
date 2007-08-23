module ActiveScaffold::Config
  class PrintList < List
    def initialize(core_config)
      @core = core_config

      # inherit from global scope
      # full configuration path is: defaults => global table => local table
      @per_page = 2#self.class.per_page

      # originates here
      @sorting = ActiveScaffold::DataStructures::Sorting.new(@core.columns)
      @sorting.add @core.model.primary_key, 'ASC'

      # inherit from global scope
      @empty_field_text = self.class.empty_field_text
    end
    cattr_reader :link
    @@link = ActiveScaffold::DataStructures::ActionLink.new('print_list', :label => 'Print List', :type => :table, :security_method => :print_list_authorized?, :popup => true)
    
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
