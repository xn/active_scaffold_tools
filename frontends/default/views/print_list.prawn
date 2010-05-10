# pdf.text active_scaffold_config.print_list.header_text if active_scaffold_config.print_list.header_text
headers = @print_list_columns.collect { |column| format_print_list_column_header_name(column) }
rows = [headers]
if @full_download
  @records.each do |record|
    rows << @print_list_columns.collect { |column|
      get_print_list_column_value(record, column)
    }
  end
else
  for i in 0..@maximum_rows do
    rows << @print_list_columns.collect { |column|
      get_print_list_column_value(@records[i], column)
    }
  end
end
  
pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
pdf.font_size((@font_size * 1.5).to_i)
pdf.text @header_text
pdf.font_size @font_size
pdf.table rows, :cell_style => {:padding => 3}, :width => pdf.bounds.width, :header => false do |tbl|
  tbl.style tbl.row(0), :border_width => 2, :borders => [:bottom]
end