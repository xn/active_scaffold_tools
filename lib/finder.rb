module ActiveScaffold
  module Finder
    def self.condition_for_column_with_tools(column, value, like_pattern = '%?%')
      if value.is_a?(Hash)
        value = value[:id] 
        save_column_type = column.form_ui
        column.form_ui = :integer
      end
      condition_string = self.condition_for_column_without_tools(column, value, like_pattern)
      column.form_ui = save_column_type if save_column_type
      condition_string
    end
    
    class << self
      alias_method_chain :condition_for_column, :tools
    end
  end
end