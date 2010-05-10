ActiveScaffold::Helpers::FormColumnHelpers.module_eval do

  def active_scaffold_column_usa_phone(column, record)
    number_to_phone(record[column.name].to_s)
  end

  def active_scaffold_input_usa_phone(column, options)
    column.description ||= as_("Ex. 111-333-4444")
    text_field :record, column.name, options.merge(
      :value => number_to_phone(@record[column.name].to_s),
      :onblur => "PhoneDashAdd(this);return true;",
      :onchange => "NukeBadChars(this); return true;").merge(active_scaffold_input_text_options)
  end

  def active_scaffold_input_timezone(column, options)
    time_zone_select(:record, column.name)
  end

end

