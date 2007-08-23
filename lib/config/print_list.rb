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
    
  end
end
