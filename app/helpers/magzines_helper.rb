module MagzinesHelper
  def magzine_path(no)
    "#{root_url}magzine/#{no}"
  end
  
  def export_excel_path(no)
    "#{root_url}expenses/excel/#{no}"
  end
end
