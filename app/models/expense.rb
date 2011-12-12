class Expense < ActiveRecord::Base
  attr_accessible :author, :realname, :address, :email, :idcard, :article_id, :text_count, :fee_per_word, :pages, :fee_per_page, :total_fee, :tax, :paid, :bankno, :bank, :user_id, :exp_type, :career, :comment
  belongs_to :user
  belongs_to :article
  
  validates :author,  :presence => true
  validates :total_fee, :presence => true
  validates :paid, :presence => true
end
