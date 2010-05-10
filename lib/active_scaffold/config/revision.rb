# 
# Works with acts_as_revisionable plugin
# 
module ActiveScaffold::Config
  class Revision < Base
    self.crud_type = :read

    def initialize(core_config)
      @core = core_config

    end

    # global level configuration
    # --------------------------
    cattr_reader :link
    @@link = ActiveScaffold::DataStructures::ActionLink.new('revision', :label => :revision, :type => :member, :security_method => :revision_authorized?)

    cattr_accessor :plugin_directory
    @@plugin_directory = File.expand_path(__FILE__).match(/vendor\/plugins\/([^\/]*)/)[1]

    # instance-level configuration
    # ----------------------------

    # the label for this action. used for the header.
    attr_writer :label
    def label
      @label ? as_(@label) : as_(:revisions_for_model, :model => @core.label.singularize)
    end

    # provides access to the list of columns specifically meant for this action to use
    def columns
      unless @columns
        self.columns = @core.columns._inheritable 
        self.columns.exclude @core.columns.active_record_class.locking_column.to_sym
      end
      @columns
    end
    def columns=(val)
      @columns = ActiveScaffold::DataStructures::ActionColumns.new(*val)
      @columns.action = self
    end
  end
end
