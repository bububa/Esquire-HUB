class ArticleStats < ActiveRecord::Base
  attr_accessible :no, :total, :finished, :delay_material, :delay_draft, :delay_final
  default_scope :order => 'article_stats.no DESC'
  validates :no,  :presence => true, :uniqueness => true
end
