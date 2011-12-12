module ArticlesHelper
  def article_edit_path(article)
    "#{root_url}article/edit/#{article.id}"
  end
end
