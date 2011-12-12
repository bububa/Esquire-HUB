class Message < ActiveRecord::Base
  attr_accessible :msg, :from_user_id, :to_user_id, :auto, :unread
  belongs_to :from_user, :class_name => "User", :foreign_key => "from_user_id"
  belongs_to :to_user, :class_name => "User", :foreign_key => "to_user_id"
  
  default_scope :order => 'messages.created_at DESC'
  
  validates :msg,  :presence => true
  
end
