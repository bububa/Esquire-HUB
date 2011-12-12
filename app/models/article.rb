# encoding: UTF-8
class Article < ActiveRecord::Base
  attr_accessible :no, :brand, :pages, :subject, :form, :position, :material_on, :material_at, :draft_on, :draft_at, :final_on, :final_at, :sales_sign_at, :editor_sign_at, :print_at, :comment, :editor_id, :designer_id, :sales_id, :editor_manager_id, :canceled, :closed
  belongs_to :sales, :class_name => "User", :foreign_key => "sales_id"
  belongs_to :editor, :class_name => "User", :foreign_key => "editor_id"
  belongs_to :designer, :class_name => "User", :foreign_key => "designer_id"
  belongs_to :editor_manager, :class_name => "User", :foreign_key => "editor_manager_id"
  has_many :expenses, :dependent => :destroy
  
  default_scope :order => 'articles.created_at DESC'
  
  validate :material_expired_submit
  validate :special_expired_submit
  validate :expired_submit
  validates :no,  :presence => true
  validates :subject,   :presence => true,
                        :length => { :maximum => 255 }
  validates :brand,   :presence => true,
                      :length => { :maximum => 128 }
  validates :pages,   :presence => true
  validates :form,   :presence => true
  validates :position,   :presence => true
  validates :material_on,   :presence => true
  
  after_save :after_save
  after_destroy :after_destroy
  
  def self.fetch(id)
    Rails.cache.fetch("Article_#{id}") do 
      Article.find(id)
    end
  end 

  def after_save
    Rails.cache.write("Article_#{self.id}", self)
  end

  def after_destroy
    Rails.cache.delete("Article_#{self.id}")
  end
  
  private
    
    def material_expired_submit
      if no.nil? or material_on.nil?
        return
      end
      no_pre = no-1.month
      errors.add(:material_on, "如非特殊情况，每月软文资料请于刊期前一月5日前给到，截止到前一月10日不再接收策划稿签。偶有特殊，需要在销售表里涂黄标记，或告知策划主管") unless material_on <= Date.new(no_pre.year, no_pre.month, 10) 
    end
    
    def special_expired_submit
      if no.nil?
        return
      end
      no_pre = no-2.month
      no_pre = Time.new(no_pre.year, no_pre.month, 25)
      errors.add(:no, "若须大片拍摄、手绘插画、品牌专册或其它特殊形式，请于刊期前二个月的25日前注明或告知") if [3, 4, 6].include?form && Time.zone.now > no_pre
    end
    
    def expired_submit
      if no.nil?
        return
      end
      no_pre = no-1.month
      no_pre = Time.new(no_pre.year, no_pre.month, 15)
      errors.add(:no, "一般情况下，每月软文最终截稿时间为刊期前一月15日") if [0, 1, 2, 5].include?form && Time.zone.now > no_pre
    end
end
