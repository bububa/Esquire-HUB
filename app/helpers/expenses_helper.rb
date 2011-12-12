module ExpensesHelper
  def expense_new_path(article, exp_type)
    "#{root_url}expense/new/#{exp_type}/#{article.id}"
  end
  
  def expenses_article_path(article)
    "#{root_url}expenses/#{article.id}"
  end
  
  def expense_delete_path(expense)
    "#{root_url}expense/delete/#{expense.id}"
  end
  
end
