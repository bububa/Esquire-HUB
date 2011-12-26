class UserStats < ActiveRecord::Base
  attr_accessible :no, :total, :finished, :delay_material, :delay_draft, :delay_final, :user_id, :user_type
  belongs_to :user
  default_scope :order => 'user_stats.no DESC'
  validates_uniqueness_of :no, :scope => [:user_id], :unique=>true
  
end
