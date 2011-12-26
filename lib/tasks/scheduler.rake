namespace :admin  do
  desc "This task is called by the Heroku scheduler add-on"
  task :update_stats => :environment do
      puts "Updating article stats..."
      total = 0
      finished = 0
      delay_material = 0
      delay_draft = 0
      delay_final = 0
      no = nil
      editors = Hash.new
      sales = Hash.new
      last_no = ArticleStats.maximum("no")
      Article.order("no ASC").find_each do |article|
        if no!=article.no && !no.nil?
          ArticleStats.new(:no=>no, :total=>total, :finished=>finished, :delay_material=>delay_material, :delay_draft=>delay_draft, :delay_final=>delay_final)
          editors.each do |editor_id, vals|
            UserStats.new(:no=>no, :user_id=>editor_id, :total=>vals[:total], :finished=>vals[:finished], :delay_material=>vals[:delay_material], :delay_draft=>vals[:delay_draft], :delay_final=>vals[:delay_final], :user_type=>5)
          end
        
          sales.each do |editor_id, vals|
            UserStats.new(:no=>no, :user_id=>editor_id, :total=>vals[:total], :finished=>vals[:finished], :delay_material=>vals[:delay_material], :delay_draft=>vals[:delay_draft], :delay_final=>vals[:delay_final], :user_type=>6)
          end
        
          no = article.no
          total = 0
          finished = 0
          delay_material = 0
          delay_draft = 0
          delay_final = 0
          editors = Hash.new
          sales = Hash.new
          puts "save stats for #{no}"
        end
        if article.no < last_no
          puts "outdated"
          break
        end
        unless editors.has_key?(article.editor_id)
          editors[article.editor_id] = Hash.new
        end
        unless sales.has_key?(article.sales_id)
          sales[article.sales_id] = Hash.new
        end
        editors[article.editor_id][:total] += 1
        sales[article.sales_id][:total] += 1
        total += 1
        if !article.print_at.nil? || article.closed
          finished += 1
          editors[article.editor_id][:finished] += 1
          sales[article.sales_id][:finished] += 1
        end
        if !article.material_on.nil? && !article.material_at.nil? && article.material_on < Date.new(article.material_at.year, article.material_at.month, article.material_at.day)
          delay_material += 1
          editors[article.editor_id][:delay_material] += 1
          sales[article.sales_id][:delay_material] += 1
        end
        if !article.draft_on.nil? && !article.draft_at.nil? && article.draft_on < Date.new(article.draft_at.year, article.draft_at.month, article.draft_at.day)
          delay_draft += 1
          editors[article.editor_id][:delay_draft] += 1
          sales[article.sales_id][:delay_draft] += 1
        end
        if !article.final_on.nil? && !article.final_at.nil? && article.final_on < Date.new(article.final_at.year, article.final_at.month, article.final_at.day)
          delay_final += 1
          editors[article.editor_id][:delay_final] += 1
          sales[article.sales_id][:delay_final] += 1
        end
      end
      puts "done."
  end
end
