module ActiveScaffold::DataStructures
  class Column
    attr_accessor :file_column_display
  end
end

module ActiveScaffold::Config
  class Core < Base
    attr_accessor :file_column_fields
    def initialize_with_file_column(model_id)
      @file_column_fields||=[]
      
      initialize_without_file_column(model_id)
      
      @file_column_fields = self.model.instance_methods.grep(/_just_uploaded\?$/).collect{|m| m[0..-16].to_sym }
      # check to see if file column was used on the model
      return if @file_column_fields.empty?
      
      self.update.multipart = true
      self.create.multipart = true
      
      # automatically set the forum_ui to a file column
      @file_column_fields.each{|field|
        begin
          self.columns[field].form_ui = :file_column
          
          # set null to false so active_scaffold wont set it to null
          # This is a bit hackish
          self.model.columns_hash[field.to_s].instance_variable_set("@null", false)
        rescue
        end
      }
    end
    
    alias_method_chain :initialize, :file_column
    
  end
end

module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a List Column
    module ListColumns
      def get_column_value_with_file_column(record, column)
        if column_override?(column) || !active_scaffold_config.file_column_fields.include?(column.name.to_sym)
          return get_column_value_without_file_column(record, column)
        end
        
        value = record.send(column.name)
        
        unless column.file_column_display
          begin
            options = record.send("#{column.name}_options")
            versions = options[:magick][:versions]
            raise unless versions.stringify_keys["thumb"]
            column.file_column_display = :image
          rescue
            column.file_column_display = :link
          end
        end
                
        return "&nbsp;" if value.nil?

        label = case column.file_column_display
                when :image
                  image_tag(url_for_file_column(record, column.name.to_s, "thumb"), :border => 0, :target => "_blank")
                when :link
                  File.basename(value)
                when :label
                  column.label
                when :click_message
                  "Click here to download"
                end
        link_to(label, url_for_file_column(record, column.name.to_s), :popup => true)
      end
      
      alias_method_chain :get_column_value, :file_column
    end
  end
end


module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a Form Column
    module FormColumns
      def active_scaffold_input_file_column(column, options)
        file_column_field("record", column.name, options)
      end      
    end
  end
end