module ActiveScaffold::Config
  class PrintPdf < PrintList

      def initialize(*args)
        super
      end

    # global level configuration
    # --------------------------
    # the ActionLink for this action
    cattr_reader :link
    @@link = ActiveScaffold::DataStructures::ActionLink.new('print_pdf', :label => 'PDF', :type => :table, :security_method => :print_list_authorized?, :popup => true)
    
    # instance-level configuration
    # ----------------------------

    attr_accessor :header_image
    attr_accessor :header_size
    attr_accessor :header_text
    
  end
end